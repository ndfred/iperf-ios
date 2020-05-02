#import "IPFHelpViewController.h"
#import <WebKit/WebKit.h>

@interface IPFHelpViewController () <WKNavigationDelegate>

@end

@implementation IPFHelpViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  if (self != nil) {
    self.title = NSLocalizedString(@"TestHelper.title", @"Help screen title");
  }

  return self;
}

- (void)loadView
{
  WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
  NSURL *helpFileURL = [[NSBundle mainBundle] URLForResource:@"Help" withExtension:@"html"];

  webView.allowsLinkPreview = NO;
  webView.navigationDelegate = self;
  [webView loadFileURL:helpFileURL allowingReadAccessToURL:helpFileURL];
  self.view = webView;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
  NSURL *URL = navigationAction.request.URL;

  if ([URL isFileURL]) {
    // Local file load
    decisionHandler(WKNavigationActionPolicyAllow);
  } else {
    // Tap on a link, open Safari
    decisionHandler(WKNavigationActionPolicyCancel);
    dispatch_async(dispatch_get_main_queue(), ^{
      [[UIApplication sharedApplication] openURL:URL];
    });
  }
}

@end
