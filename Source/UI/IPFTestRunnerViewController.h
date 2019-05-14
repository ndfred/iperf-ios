#import <UIKit/UIKit.h>

@interface IPFTestRunnerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextField *portTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *transmitModeSlider;
@property (strong, nonatomic) IBOutlet UISegmentedControl *streamsSlider;
@property (strong, nonatomic) IBOutlet UISegmentedControl *testDurationSlider;
@property (strong, nonatomic) IBOutlet UILabel *bandwidthLabel;
@property (strong, nonatomic) IBOutlet UILabel *averageBandwidthLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

- (IBAction)startStopTest;

@end
