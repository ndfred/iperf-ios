/**
 * This file is generated using the remodel generation script.
 * The name of the input file is IPFTestRunnerConfiguration.value
 */

#import <Foundation/Foundation.h>
#import "IPFTestRunnerConfigurationType.h"

@interface IPFTestRunnerConfiguration : NSObject <NSCopying>

@property (nonatomic, copy) NSString *hostname;
@property (nonatomic) NSUInteger port;
@property (nonatomic) NSUInteger duration;
@property (nonatomic) NSUInteger streams;
@property (nonatomic) IPFTestRunnerConfigurationType type;

- (instancetype)initWithHostname:(NSString *)hostname port:(NSUInteger)port duration:(NSUInteger)duration streams:(NSUInteger)streams type:(IPFTestRunnerConfigurationType)type;

@end

