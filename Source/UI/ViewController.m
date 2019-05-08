#import "ViewController.h"
#import "IPFTestRunner.h"
#import "IPFTestRunnerConfiguration.h"

static int getTestDuration(NSUInteger selectedSegmentIndex)
{
  switch (selectedSegmentIndex) {
    case 0:
      return 10;

    case 1:
      return 30;

    case 2:
      return 300;

    default:
      return 10;
  }
}

@interface ViewController ()

@property (strong, nonatomic) IPFTestRunner *testRunner;

@end

@implementation ViewController {
  NSUInteger _averageBandwidthTotal;
  NSUInteger _averageBandwidthCount;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  if (self != nil) {
    self.title = NSLocalizedString(@"iPerf", @"Main screen title");
    [self showStartButton:YES];
  }

  return self;
}

- (void)showStartButton:(BOOL)showStartButton
{
  NSString *title = showStartButton ? NSLocalizedString(@"Start", @"Test start button name") : NSLocalizedString(@"Stop", @"Test stop button name");
  UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(startStopTest)];

  if (!showStartButton) {
    buttonItem.tintColor = [UIColor redColor];
  }

  self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)viewDidLoad
{
  [self restoreTestSettings];
}

- (void)restoreTestSettings
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *hostname = [defaults stringForKey:@"IPFTestHostname"];
  NSNumber *port = [defaults objectForKey:@"IPFTestPort"];

  if ([hostname length] > 0 && [port unsignedIntegerValue] > 0) {
    self.addressTextField.text = hostname;
    self.portTextField.text = [port stringValue];
  }
}

- (void)saveTestSettings
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *hostname = self.addressTextField.text;
  NSNumber *port = [NSNumber numberWithUnsignedInteger:(NSUInteger)[self.portTextField.text integerValue]];

  if ([hostname length] > 0 && [port unsignedIntegerValue] > 0) {
    [defaults setObject:hostname forKey:@"IPFTestHostname"];
    [defaults setObject:port forKey:@"IPFTestPort"];
    [defaults synchronize];
  }
}

- (void)startStopTest
{
  IPFTestRunner *testRunner = self.testRunner;

  if (testRunner) {
    [testRunner stopTest];
  } else {
    [self startTest];
  }
}

- (void)startTest
{
  IPFTestRunnerConfiguration *configuration = [[IPFTestRunnerConfiguration alloc] initWithHostname:self.addressTextField.text
                                                                                              port:[self.portTextField.text intValue]
                                                                                          duration:getTestDuration(self.testDurationSlider.selectedSegmentIndex)
                                                                                           streams:[self.streamsSlider selectedSegmentIndex] + 1
                                                                                           reverse:[self.transmitModeSlider selectedSegmentIndex]];
  IPFTestRunner *testRunner = [[IPFTestRunner alloc] initWithConfiguration:configuration];
  UIApplication *application = [UIApplication sharedApplication];
  __block UIBackgroundTaskIdentifier backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
    [application endBackgroundTask:backgroundTask];
    backgroundTask = UIBackgroundTaskInvalid;
  }];

  self.testRunner = testRunner;
  [self showStartButton:NO];
  self.addressTextField.enabled = NO;
  self.portTextField.enabled = NO;
  self.transmitModeSlider.enabled = NO;
  self.streamsSlider.enabled = NO;
  self.testDurationSlider.enabled = NO;
  self.bandwidthLabel.text = @"...";
  self.averageBandwidthLabel.text = @"";
  [application setNetworkActivityIndicatorVisible:YES];
  _averageBandwidthTotal = 0;
  _averageBandwidthCount = 0;

  [testRunner startTest:^(IPFTestRunnerStatus status) {
    switch (status.errorState) {
      case IPFTestRunnerErrorStateNoError:
        break;

      case IPFTestRunnerErrorStateCouldntInitializeTest:
        [self showAlert:NSLocalizedString(@"Error initializing the test", nil)];
        break;

      case IPFTestRunnerErrorStateCannotConnectToTheServer:
        [self showAlert:NSLocalizedString(@"Cannot connect to the server, please check that the server is running", nil)];
        break;

      case IPFTestRunnerErrorStateServerIsBusy:
        [self showAlert:NSLocalizedString(@"Server is busy, please retry later", nil)];
        break;

      default:
        [self showAlert:[NSString stringWithFormat:NSLocalizedString(@"Unknown error %d running the test", nil), status.errorState]];
        break;
    }
    if (status.errorState != IPFTestRunnerErrorStateNoError) {
      [self showAlert:NSLocalizedString(@"Error running the test", @"Default test error message")];
    }

    if (status.running == NO) {
      [self showStartButton:YES];
      self.addressTextField.enabled = YES;
      self.portTextField.enabled = YES;
      self.transmitModeSlider.enabled = YES;
      self.streamsSlider.enabled = YES;
      self.testDurationSlider.enabled = YES;
      self.testRunner = nil;
      [application setNetworkActivityIndicatorVisible:NO];
      [application endBackgroundTask:backgroundTask];

      if (status.errorState == IPFTestRunnerErrorStateNoError || status.errorState == IPFTestRunnerErrorStateServerIsBusy) {
        // Only persist settings if the test is successful
        [self saveTestSettings];
      }
    } else {
      self.bandwidthLabel.text = [NSString stringWithFormat:@"%.1f Mbits/s", status.bandwidth];
      self->_averageBandwidthTotal += status.bandwidth;
      self->_averageBandwidthCount++;
      self.averageBandwidthLabel.text = [NSString stringWithFormat:@"average: %.1f Mbits/s", (CGFloat)self->_averageBandwidthTotal / (CGFloat)self->_averageBandwidthCount];
    }
  }];
}

- (void)showAlert:(NSString *)alertText
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertText message:nil preferredStyle:UIAlertControllerStyleAlert];

  [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
  [self presentViewController:alertController animated:YES completion:NULL];
  self.bandwidthLabel.text = @"";
  self.averageBandwidthLabel.text = @"";
}

@end
