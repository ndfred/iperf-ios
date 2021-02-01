#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class IPFTestRunnerConfiguration;

typedef NS_ENUM(NSUInteger, IPFTestRunnerErrorState) {
  IPFTestRunnerErrorStateNoError = 0,
  IPFTestRunnerErrorStateCouldntInitializeTest = 1,
  IPFTestRunnerErrorStateServerIsBusy = 2,
  IPFTestRunnerErrorStateCannotConnectToTheServer = 3,
  IPFTestRunnerErrorStateUnknown = 4,
};

typedef struct {
  BOOL running;
  CGFloat progress;
  CGFloat bandwidth;
  IPFTestRunnerErrorState errorState;
} IPFTestRunnerStatus;

typedef void (^IPFTestRunnerCallback)(IPFTestRunnerStatus status);

@interface IPFTestRunner : NSObject

@property (nonatomic, copy, readonly) IPFTestRunnerConfiguration *configuration;

- (id)initWithConfiguration:(IPFTestRunnerConfiguration *)configuration;
- (void)startTest:(IPFTestRunnerCallback)callback;
- (void)stopTest;

@end
