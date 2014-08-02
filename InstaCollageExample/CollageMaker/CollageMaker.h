//
//  CollageMaker.h
//  InstaCollageExample
//
//  Created by Ivan Vavilov on 02/08/14.
//
//

#import <Foundation/Foundation.h>

@interface CollageMaker : NSObject

+(id) sharedInstance;

-(UIImage *) getCollageForImages:(NSArray *) images;

@end
