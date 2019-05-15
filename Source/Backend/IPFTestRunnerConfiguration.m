/**
 * This file is generated using the remodel generation script.
 * The name of the input file is IPFTestRunnerConfiguration.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "IPFTestRunnerConfiguration.h"

@implementation IPFTestRunnerConfiguration

- (instancetype)initWithHostname:(NSString *)hostname port:(NSUInteger)port duration:(NSUInteger)duration streams:(NSUInteger)streams reverse:(BOOL)reverse
{
  if ((self = [super init])) {
    _hostname = [hostname copy];
    _port = port;
    _duration = duration;
    _streams = streams;
    _reverse = reverse;
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t hostname: %@; \n\t port: %tu; \n\t duration: %tu; \n\t streams: %tu; \n\t reverse: %@; \n", [super description], _hostname, _port, _duration, _streams, _reverse ? @"YES" : @"NO"];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_hostname hash], _port, _duration, _streams, (NSUInteger)_reverse};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 5; ++ii) {
    unsigned long long base = (((unsigned long long)result) << 32 | subhashes[ii]);
    base = (~base) + (base << 18);
    base ^= (base >> 31);
    base *=  21;
    base ^= (base >> 11);
    base += (base << 6);
    base ^= (base >> 22);
    result = base;
  }
  return result;
}

- (BOOL)isEqual:(IPFTestRunnerConfiguration *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _port == object->_port &&
    _duration == object->_duration &&
    _streams == object->_streams &&
    _reverse == object->_reverse &&
    (_hostname == object->_hostname ? YES : [_hostname isEqual:object->_hostname]);
}

@end

