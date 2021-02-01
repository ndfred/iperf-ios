#import "IPFIcon.h"

#import <Foundation/Foundation.h>
#import <math.h>

static void fillQuarterCirclePath(CGContextRef context, CGSize contextSize, CGFloat circleHeight, CGFloat angle)
{
  CGContextMoveToPoint(context, contextSize.width / 2.0, 0.0);
  CGContextAddArc(context, contextSize.width / 2.0, 0.0, circleHeight, M_PI - angle, angle, true);
  CGContextFillPath(context);
}

CGImageRef IPFCreateIconImageWithSize(CGSize size)
{
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 4 * size.width, colorSpace, kCGImageAlphaPremultipliedLast);
  CGColorRef whiteColor = CGColorCreate(colorSpace, (CGFloat []){1.0, 1.0, 1.0, 1.0});
  CGColorRef blueColor = CGColorCreate(colorSpace, (CGFloat []){14.0 / 255.0, 32.0 / 255.0, 98.0 / 255.0, 1.0});
  CGImageRef image = NULL;

  // White background
  CGContextSetFillColorWithColor(context, whiteColor);
  CGContextFillRect(context, (CGRect){CGPointZero, size});

  // Scale to center the logo
  {
    const CGFloat padding = 0.9;
    const CGFloat scale = padding * cos(M_PI_4);

    CGContextTranslateCTM(context, size.width * (1.0 - scale) / 2.0, size.height * (1.0 - scale) / 2.0);
    CGContextScaleCTM(context, scale, scale);
  }

  // Wifi fan out
  {
    const NSUInteger stripes = 3;
    const CGFloat stripeWeight = 0.6;
    const CGFloat gapWeight = 0.4;
    CGFloat heightUnit = size.height / (stripeWeight * (CGFloat)stripes + gapWeight * (CGFloat)(stripes - 1));

    for (NSUInteger stripeIndex = 0; stripeIndex < stripes; stripeIndex++) {
      CGContextSetFillColorWithColor(context, blueColor);
      fillQuarterCirclePath(context, size, size.height - (CGFloat)stripeIndex * heightUnit, M_PI_4);

      if (stripeIndex != stripes - 1) {
        CGContextSetFillColorWithColor(context, whiteColor);
        fillQuarterCirclePath(context, size, size.height - (CGFloat)stripeIndex * heightUnit - heightUnit * stripeWeight, M_PI_4 / 2.0);
      }
    }
  }

  image = CGBitmapContextCreateImage(context);

  CGColorRelease(blueColor);
  CGColorRelease(whiteColor);
  CGContextRelease(context);
  CGColorSpaceRelease(colorSpace);

  return image;
}

#if IPF_ENABLE_FILE_WRITE

#import <ImageIO/ImageIO.h>
#import <CoreServices/CoreServices.h>

void IPFWriteImageToFile(CGImageRef image, NSString *path, NSError **error)
{
  CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
  CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);

  CGImageDestinationAddImage(destination, image, nil);

  if (!CGImageDestinationFinalize(destination) && error) {
    *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:nil];
  }

  CFRelease(destination);
}

#endif
