#import <Foundation/Foundation.h>

#import "IPFIcon.h"

int main(int argc, char **argv) {
  int error = 0;

  if (argc != 3) {
    NSLog(@"Please specify a size and output file path");
    NSLog(@"usage: %s <size> <output file>", argv[0]);
    error = 1;
  } else {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSUInteger size = [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] integerValue];
    NSString *path = [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding];
    CGImageRef image = IPFCreateIconImageWithSize(CGSizeMake(size, size));
    NSError *error = nil;

    IPFWriteImageToFile(image, path, &error);

    CGImageRelease(image);
    [pool release];
  }

  return error;
}
