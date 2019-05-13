#import <CoreGraphics/CoreGraphics.h>

CGImageRef IPFCreateIconImageWithSize(CGSize size);
#if IPF_ENABLE_FILE_WRITE
void IPFWriteImageToFile(CGImageRef image, NSString *path, NSError **error);
#endif
