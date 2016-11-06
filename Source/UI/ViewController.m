#import "ViewController.h"

#import "iperf_api.h"

#import "iperf.h"
#import "queue.h"

static __unsafe_unretained ViewController *s_currentViewController;

@interface ViewController ()

- (void)handleStatsCallback:(struct iperf_test *)test;

@end

static void vc_reporter_callback(struct iperf_test *test)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [s_currentViewController handleStatsCallback:test];
  });
}

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
  // Assume a client test to 192.168.1.10
  struct iperf_test *test = iperf_new_test();
  NSString *streamFilePathTemplate = [NSTemporaryDirectory() stringByAppendingPathComponent:@"iperf3.XXXXXX"];

  if (!test) {
    [self showAlert:@"Couldn't initialize a test!"];
    return;
  }

  if (iperf_defaults(test) < 0) {
    [self showAlert:@"Couldn't set the default options on the test!"];
    return;
  }

  iperf_set_test_role(test, 'c');
  iperf_set_test_server_hostname(test, (char *)[self.addressTextField.text cStringUsingEncoding:NSASCIIStringEncoding]);
  iperf_set_test_server_port(test, [self.portTextField.text intValue]);
  iperf_set_test_duration(test, 10);
  iperf_set_test_num_streams(test, (int)[self.streamsSlider selectedSegmentIndex] + 1);
  iperf_set_test_reverse(test, (int)[self.transmitModeSlider selectedSegmentIndex]);
  iperf_set_test_template(test, (char *)[streamFilePathTemplate cStringUsingEncoding:NSUTF8StringEncoding]);
  i_errno = IENONE;

  self.navigationItem.rightBarButtonItem.enabled = NO;
  self.addressTextField.enabled = NO;
  self.portTextField.enabled = NO;
  self.transmitModeSlider.enabled = NO;
  self.streamsSlider.enabled = NO;
  self.bandwidthLabel.text = @"...";
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  test->reporter_callback = vc_reporter_callback;
  s_currentViewController = self;

  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
    iperf_run_client(test);

    dispatch_async(dispatch_get_main_queue(), ^{
      s_currentViewController = nil;

      if (i_errno != IENONE) {
        [self showAlert:[NSString stringWithUTF8String:iperf_strerror(i_errno)]];
      }

      iperf_free_test(test);
      self.navigationItem.rightBarButtonItem.enabled = YES;
      self.navigationItem.rightBarButtonItem.enabled = YES;
      self.addressTextField.enabled = YES;
      self.portTextField.enabled = YES;
      self.transmitModeSlider.enabled = YES;
      self.streamsSlider.enabled = YES;

      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
  });
}

- (void)showAlert:(NSString *)alertText
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertText message:nil preferredStyle:UIAlertControllerStyleAlert];

  [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
  [self presentViewController:alertController animated:YES completion:NULL];
  self.bandwidthLabel.text = @"";
}

- (void)handleStatsCallback:(struct iperf_test *)test
{
  BOOL showFinalResults = NO;

  switch (test->state) {
    case TEST_END:
    case DISPLAY_RESULTS:
    case IPERF_DONE:
      showFinalResults = YES;
      break;
  }

  // See iperf_reporter_callback
  {
    extern double timeval_diff(struct timeval * tv0, struct timeval * tv1);

    struct iperf_stream *stream = NULL;
    struct iperf_interval_results *interval_results = NULL;
    iperf_size_t bytes = 0;
    double bandwidth = 0.0;
    int retransmits = 0;
    int total_packets = 0, lost_packets = 0;
    double avg_jitter = 0.0, lost_percent = 0.0;

    SLIST_FOREACH(stream, &test->streams, streams) {
      interval_results = TAILQ_LAST(&stream->result->interval_results, irlisthead);
      bytes += interval_results->bytes_transferred;

      if (test->protocol->id == Ptcp) {
        if (test->sender && test->sender_has_retransmits) {
          retransmits += interval_results->interval_retrans;
        }
      } else {
        total_packets += interval_results->interval_packet_count;
        lost_packets += interval_results->interval_cnt_error;
        avg_jitter += interval_results->jitter;
      }
    }

    stream = SLIST_FIRST(&test->streams);

    if (stream) {
      interval_results = TAILQ_LAST(&stream->result->interval_results, irlisthead);
      bandwidth = (double)bytes / (double)interval_results->interval_duration;
      avg_jitter /= test->num_streams;

      if (total_packets > 0) {
        lost_percent = 100.0 * lost_packets / total_packets;
      } else {
        lost_percent = 0.0;
      }

//      NSLog(@"Bandwidth on %d streams: %.2f Mbits/s (retransmits: %d, lost: %.2f%%, jitter: %.0f, interval: %.2fs)", test->num_streams, bandwidth * 8 / 1000000, retransmits, lost_percent, avg_jitter * 1000.0, interval_results->interval_duration);
      self.bandwidthLabel.text = [NSString stringWithFormat:@"%.1f Mbits/s", bandwidth * 8 / 1000000];
    }
  }
}

@end
