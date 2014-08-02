//
//  FirstScreenController.m
//  InstaCollageExample
//
//  Created by Ivan Vavilov on 01/08/14.
//
//

#import "FirstScreenController.h"
#import "ImagePickerController.h"
#import "PhotosRequestPerformer.h"

//////////////////////////////////////////////////////////////////////////////

static NSString* const kImagePickerSegueIdentifier = @"ImagePicker";

//////////////////////////////////////////////////////////////////////////////

@interface FirstScreenController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *hud;
@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (strong, nonatomic) NSArray *images;

@end

//////////////////////////////////////////////////////////////////////////////

@implementation FirstScreenController

#pragma mark - View Lifecycle

-(void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    [self setupUI];
}

-(void) setupUI
{
    self.navigationController.navigationBarHidden = YES;
    self.hud.hidden = YES;
}

-(void) viewWillDisappear:(BOOL) animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UI Actions

- (IBAction) makeCollageTapped
{
    [self prepareForMediaDownload];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {

        self.images = [[PhotosRequestPerformer sharedInstance] getImagesForUserName:self.userNameTextField.text];

        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [self performSegueWithIdentifier:kImagePickerSegueIdentifier
                                      sender:nil];
            [self restoreNormalUIState];
        });
    });
}

-(void) prepareForMediaDownload
{
    self.hud.hidden = NO;
    self.view.userInteractionEnabled = NO;
    self.dimView.hidden = NO;
}

-(void) restoreNormalUIState
{
    self.hud.hidden = YES;
    self.view.userInteractionEnabled = YES;
    self.dimView.hidden = YES;
}

#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *) segue
                 sender:(id) sender
{
    if ([segue.identifier isEqualToString:kImagePickerSegueIdentifier]) {
        ImagePickerController *imagePickerController = segue.destinationViewController;
        imagePickerController.images = self.images;
    }
}

@end

//////////////////////////////////////////////////////////////////////////////