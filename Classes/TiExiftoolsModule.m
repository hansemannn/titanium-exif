/**
 * titanium-exif-tools
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Hans Knöchel. All rights reserved.
 */

#import "TiExiftoolsModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "EXF.h"

@implementation TiExiftoolsModule

#pragma mark Internal

- (id)moduleGUID
{
	return @"6ee22516-22f8-430c-b505-55dcbf18b612";
}

- (NSString *)moduleId
{
	return @"ti.exiftools";
}

#pragma mark Lifecycle

- (void)startup
{
	[super startup];
	NSLog(@"[DEBUG] %@ loaded",self);
}

#pragma Public APIs

- (void)scanEXIFDataFromImage:(id)arguments
{
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  TiBlob *image = [arguments objectForKey:@"image"];
  KrollCallback *callback = [arguments objectForKey:@"callback"];
  NSArray *tags = [arguments objectForKey:@"tags"];
  
  if (image == nil || callback == nil) {
    NSLog(@"[ERROR] Missing \"image\" or \"callback\" parameter!");
    return;
  }
  
  EXFJpeg *jpegHandler = [[EXFJpeg alloc] init];
  
  __weak __typeof__(self) weakSelf = self;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    [jpegHandler scanImageData:[image data]];
    EXFMetaData *metadata = jpegHandler.exifMetaData;
    NSDictionary *keyedTagValues = metadata.keyedTagValues;
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
   
    __typeof__(self) strongSelf = weakSelf;

    if (keyedTagValues == nil) {
      [callback call:@[@{@"error": @"Cannot receive EXIF-tags."}] thisObject:self];
      return;
    }
    
    // Find desired tag-keys
    for (NSNumber *tagKey in keyedTagValues) {
      if ([tags containsObject:tagKey]) {
        [result setObject:[keyedTagValues objectForKey:tagKey] forKey:[NSString stringWithFormat:@"%@", tagKey]];
      }
    }
    
    // Call back home
    TiThreadPerformOnMainThread(^{
      [callback call:@[ @{ @"exif": result } ] thisObject:strongSelf];
    }, NO);
  });
}

@end
