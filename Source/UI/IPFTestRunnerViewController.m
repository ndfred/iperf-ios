#import "IPFTestRunnerViewController.h"
#import "IPFTestRunner.h"
#import "IPFTestRunnerConfiguration.h"
#import "IPFIcon.h"
#import "IPFHelpViewController.h"

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

@interface IPFTestRunnerViewController ()

@property (strong, nonatomic) IPFTestRunner *testRunner;

@end

@implementation IPFTestRunnerViewController {
  CGFloat _averageBandwidthTotal;
  NSUInteger _averageBandwidthCount;
  CGFloat _maxBandwidth;
  CGFloat _minBandwidth;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  if (self != nil) {
    self.title = NSLocalizedString(@"iPerf", @"Main screen title");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Help", @"Help start button name")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showHelp)];
    [self showStartButton:YES];
  }

  return self;
}

- (IBAction)showHelp
{
  IPFHelpViewController *helpViewController = [[IPFHelpViewController alloc] initWithNibName:nil bundle:nil];

  [self.navigationController pushViewController:helpViewController animated:YES];
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
                                                                                              type:[self.transmitModeSlider selectedSegmentIndex]];
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
  self.progressView.progress = 0.0;
  self.progressView.hidden = YES;
  [application setNetworkActivityIndicatorVisible:YES];
  _averageBandwidthTotal = 0;
  _averageBandwidthCount = 0;
  _maxBandwidth = CGFLOAT_MIN;
  _minBandwidth = CGFLOAT_MAX;

  // NSLog(@"Starting the test");

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
      self.progressView.hidden = YES;
      self.testRunner = nil;
      [application setNetworkActivityIndicatorVisible:NO];
      [application endBackgroundTask:backgroundTask];

      // NSLog(@"Not running");

      if (status.errorState == IPFTestRunnerErrorStateNoError || status.errorState == IPFTestRunnerErrorStateServerIsBusy) {
        if (self->_averageBandwidthTotal) {
          self.bandwidthLabel.text = [NSString stringWithFormat:@"%.0f Mbits/s", self->_averageBandwidthTotal / (CGFloat)self->_averageBandwidthCount];
          self.averageBandwidthLabel.text = [NSString stringWithFormat:@"min: %.0f max: %.0f", self->_minBandwidth, self->_maxBandwidth];
          self.progressView.hidden = NO;
        } else {
          self.bandwidthLabel.text = @"";
        }

        // Only persist settings if the test is successful
        [self saveTestSettings];
      }
    } else {
      CGFloat bandwidth = status.bandwidth;

      // NSLog(@"Bandwidth: %.2f, progress: %.2f", status.bandwidth, status.progress);

      self->_averageBandwidthTotal += status.bandwidth;
      self->_averageBandwidthCount++;
      self.progressView.hidden = NO;

      if (bandwidth < self->_minBandwidth) {
        self->_minBandwidth = bandwidth;
      }

      if (bandwidth > self->_maxBandwidth) {
        self->_maxBandwidth = bandwidth;
      }

      self.bandwidthLabel.text = [NSString stringWithFormat:@"%.0f Mbits/s", status.bandwidth];
      self.averageBandwidthLabel.text = [NSString stringWithFormat:@"avg: %.0f min: %.0f max: %.0f", self->_averageBandwidthTotal / (CGFloat)self->_averageBandwidthCount, self->_minBandwidth, self->_maxBandwidth];
      [self.progressView setProgress:status.progress animated:YES];
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
  self.progressView.hidden = YES;
}

@end
