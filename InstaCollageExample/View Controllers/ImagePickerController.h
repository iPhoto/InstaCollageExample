//
//  ImagePickerController.h
//  InstaCollageExample
//
//  Created by Ivan Vavilov on 02/08/14.
//
//

#import <UIKit/UIKit.h>

@interface ImagePickerController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *images;

@end
