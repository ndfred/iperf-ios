#import "ViewController.h"
#import "IPFTestRunner.h"
#import "IPFTestRunnerConfiguration.h"

static int getTestDuration(NSUInteger selectedSegmentIndex)
{
  switch (selectedSegmentIndex) {
    case 0:
      return 1;
      break;

    case 1:
      return 5;
      break;

    case 2:
      return 10;
      break;

    case 3:
      return 30;
      break;

    case 4:
      return 60;
      break;

    default:
      break;
  }

  return 10;
}

@interface ViewController ()

@property (strong, nonatomic) IPFTestRunner *testRunner;

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  if (self != nil) {
    self.title = NSLocalizedString(@"iperf3", @"Main screen title");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Start", @"Test start button name")
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(startTest)];
  }

  return self;
}

- (void)startTest
{
  IPFTestRunnerConfiguration *configuration = [[IPFTestRunnerConfiguration alloc] initWithHostname:self.addressTextField.text
                                                                                              port:[self.portTextField.text intValue]
                                                                                          duration:getTestDuration(self.testDurationSlider.selectedSegmentIndex)
                                                                                           streams:[self.streamsSlider selectedSegmentIndex] + 1
                                                                                           reverse:[self.transmitModeSlider selectedSegmentIndex]];
  IPFTestRunner *testRunner = [[IPFTestRunner alloc] initWithConfiguration:configuration];

  self.testRunner = testRunner;
  self.navigationItem.rightBarButtonItem.enabled = NO;
  self.addressTextField.enabled = NO;
  self.portTextField.enabled = NO;
  self.transmitModeSlider.enabled = NO;
  self.streamsSlider.enabled = NO;
  self.testDurationSlider.enabled = NO;
  self.bandwidthLabel.text = @"...";
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

  [testRunner startTest:^(IPFTestRunnerStatus status) {
    if (status.errorState != IPFTestRunnerErrorStateNoError) {
      [self showAlert:@"Error running the test"];
    }

    if (status.running == NO) {
      self.navigationItem.rightBarButtonItem.enabled = YES;
      self.navigationItem.rightBarButtonItem.enabled = YES;
      self.addressTextField.enabled = YES;
      self.portTextField.enabled = YES;
      self.transmitModeSlider.enabled = YES;
      self.streamsSlider.enabled = YES;
      self.testDurationSlider.enabled = YES;
      self.testRunner = nil;
      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } else {
      self.bandwidthLabel.text = [NSString stringWithFormat:@"%.1f Mbits/s", status.bandwidth];
    }
  }];
}

- (void)showAlert:(NSString *)alertText
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertText message:nil preferredStyle:UIAlertControllerStyleAlert];

  [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
  [self presentViewController:alertController animated:YES completion:NULL];
  self.bandwidthLabel.text = @"";
}

@end
