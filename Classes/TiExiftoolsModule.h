/**
 * titanium-exif-tools
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Your Company. All rights reserved.
 */

#import "TiModule.h"

@interface TiExiftoolsModule : TiModule {

}
  
/**
 @abstract Scan EXIF-data from a given image.
 
 @param arguments The arguments passed to the EXIF-parser.
 */
- (void)scanEXIFDataFromImage:(id)arguments;

@end
