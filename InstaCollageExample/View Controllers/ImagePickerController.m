//
//  ImagePickerController.m
//  InstaCollageExample
//
//  Created by Ivan Vavilov on 02/08/14.
//
//

#import "ImagePickerController.h"
#import "ImageCell.h"
#import "PreviewViewController.h"
#import "CollageMaker.h"

//////////////////////////////////////////////////////////////////////////////

static const CGFloat kAlphaValueForSelectedItem = 0.5;
static const CGFloat kAlphaDefaultValue = 1.0;
static NSString *const kImageCellIdentifier = @"ImageCell";
static NSString* const kPreviewImageSegueIdentifier = @"PreviewImage";

//////////////////////////////////////////////////////////////////////////////

@interface ImagePickerController()

@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) UIImage *outputImage;

@end

//////////////////////////////////////////////////////////////////////////////

@implementation ImagePickerController

#pragma mark - View Lifecycle

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.allowsMultipleSelection = YES;
    self.selectedImages = [@[] mutableCopy];
}

#pragma mark - UICollectionViewDelegate

-(void)   collectionView:(UICollectionView *) collectionView
didSelectItemAtIndexPath:(NSIndexPath *) indexPath
{
    [self.selectedImages addObject:self.images[(NSUInteger) indexPath.item]];
    [(ImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath] imageView].alpha = kAlphaValueForSelectedItem;
}

-(void)     collectionView:(UICollectionView *) collectionView
didDeselectItemAtIndexPath:(NSIndexPath *) indexPath
{
    [self.selectedImages removeObject:self.images[(NSUInteger) indexPath.item]];
    [(ImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath] imageView].alpha = kAlphaDefaultValue;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *) collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *) collectionView
     numberOfItemsInSection:(NSInteger) section
{
    return self.images.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *) collectionView
                  cellForItemAtIndexPath:(NSIndexPath *) indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCellIdentifier
                                                                forIndexPath:indexPath];

    cell.imageView.image = self.images[(NSUInteger) indexPath.item];
    cell.imageView.alpha = [self.selectedImages containsObject:cell.imageView.image] ? kAlphaValueForSelectedItem : kAlphaDefaultValue;
    
    return cell;
}

#pragma mark - UI Actions

- (IBAction) makeCollageTapped:(id)sender
{
    self.outputImage = [[CollageMaker sharedInstance] getCollageForImages:self.selectedImages];

    [self performSegueWithIdentifier:kPreviewImageSegueIdentifier
                              sender:nil];
}

#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *) segue
                 sender:(id) sender
{
    if ([segue.identifier isEqualToString:kPreviewImageSegueIdentifier]) {
        PreviewViewController *controller = segue.destinationViewController;
        controller.previewImage = self.outputImage;
    }
}

@end

//////////////////////////////////////////////////////////////////////////////