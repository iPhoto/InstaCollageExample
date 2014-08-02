//
//  PhotosRequestPerformer.h
//  InstaCollageExample
//
//  Created by Ivan Vavilov on 02/08/14.
//
//

#import <Foundation/Foundation.h>

@interface PhotosRequestPerformer : NSObject

+(id) sharedInstance;

-(NSArray *) getImagesForUserName:(NSString *) username;

@end
