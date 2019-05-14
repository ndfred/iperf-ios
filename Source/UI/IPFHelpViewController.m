#import "IPFHelpViewController.h"

#import <WebKit/WebKit.h>

@interface IPFHelpViewController () <WKNavigationDelegate>

@end

@implementation IPFHelpViewController

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
  if (navigationAction.navigationType == WKNavigationTypeOther) {
    // Initial load
    decisionHandler(WKNavigationActionPolicyAllow);
  } else {
    // Tap on a link, open Safari
    decisionHandler(WKNavigationActionPolicyCancel);
    dispatch_async(dispatch_get_main_queue(), ^{
      [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
    });
  }
}

@end
