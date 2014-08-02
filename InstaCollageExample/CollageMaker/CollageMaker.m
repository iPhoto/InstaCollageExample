//
//  CollageMaker.m
//  InstaCollageExample
//
//  Created by Ivan Vavilov on 02/08/14.
//
//

#import "CollageMaker.h"

//////////////////////////////////////////////////////////////////////////////

static const NSUInteger kImageSideSizePx = 150;

//////////////////////////////////////////////////////////////////////////////

@implementation CollageMaker

+(id) sharedInstance
{
    static CollageMaker *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(UIImage *) getCollageForImages:(NSArray *)images
{
    NSInteger numberOfImagesInSide = (NSInteger) ceil(sqrt(images.count));
    CGSize size;
    size.width = size.height = (CGFloat) kImageSideSizePx * numberOfImagesInSide;
    
    UIGraphicsBeginImageContext(size);
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    NSInteger imagesAtRow = 0;
    
    for (UIImage *image in images) {
        [image drawInRect:CGRectMake(x, y, kImageSideSizePx, kImageSideSizePx)];

        x += kImageSideSizePx;
        imagesAtRow++;

        if (imagesAtRow == numberOfImagesInSide) {
            x = 0;
            y += kImageSideSizePx;
            imagesAtRow = 0;
        }
    }
    
    UIImage *outputImage =  UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end

//////////////////////////////////////////////////////////////////////////////