
//
//  PreviewViewController.m
//  InstaCollageExample
//
//  Created by Ivan Vavilov on 02/08/14.
//
//

#import "PreviewViewController.h"
#import "MessageUI/MessageUI.h"

//////////////////////////////////////////////////////////////////////////////

@interface PreviewViewController() <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end

//////////////////////////////////////////////////////////////////////////////

@implementation PreviewViewController

#pragma mark - View Lifecycle

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.previewImageView.image = self.previewImage;
}

#pragma mark - UI Actions

- (IBAction)sendImageTapped:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.previewImageView.image, 1)];
        [mailer addAttachmentData:imageData
                         mimeType:@"image/jpeg"
                         fileName:@"MyCollage.jpg"];
        
        [self.navigationController presentViewController:mailer
                                                animated:YES
                                              completion:nil];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Mail Failure"
                                    message:@"Your device doesn't support in-app email"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark MailComposer Delegate

-(void) mailComposeController:(MFMailComposeViewController *) controller
          didFinishWithResult:(MFMailComposeResult) result
                        error:(NSError *) error
{
    [controller dismissViewControllerAnimated:YES
                                   completion:nil];
}

@end

//////////////////////////////////////////////////////////////////////////////