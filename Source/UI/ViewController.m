#import "ViewController.h"

#import "iperf_api.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  if (self != nil) {
    self.title = NSLocalizedString(@"iperf", @"Main screen title");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Start", @"Test start button name")
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(start)];
  }

  return self;
}

- (void)loadView
{
  CGRect frame = [[UIScreen mainScreen] bounds];
  UIView *view = [[UIView alloc] initWithFrame:frame];

  view.backgroundColor = [UIColor whiteColor];
  self.view = view;
}

- (void)start
{
  // See https://github.com/esnet/iperf/blob/master/src/main.c
  // Assume a client test to 192.168.1.10
  struct iperf_test *test = iperf_new_test();

  if (!test) {
    NSLog(@"Couldn't initialize a test!");

    return;
  }

  if (iperf_defaults(test) < 0) {
    NSLog(@"Couldn't set the default options on the test!");

    return;
  }

  iperf_set_test_role(test, 'c');
  iperf_set_test_server_hostname(test, "192.168.1.10");
  iperf_set_test_server_port(test, 5201);
  iperf_set_test_duration(test, 1);
  iperf_set_test_num_streams(test, 1);
  iperf_set_test_reverse(test, 0);

  NSLog(@"Running the test");
  iperf_run_client(test);
  NSLog(@"%s", iperf_strerror(i_errno));
  iperf_free_test(test);
}

@end
