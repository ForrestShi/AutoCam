//
//  RootViewController.m
//  Sample
//
//  Created by Kirby Turner on 2/8/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "LocalImageRootViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreImage/CoreImage.h>


@interface LocalImageRootViewController (Private)
- (UIActivityIndicatorView *)activityIndicator;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
@end

@implementation LocalImageRootViewController
@synthesize imagePath;

- (void)dealloc 
{
   [activityIndicatorView_ release], activityIndicatorView_ = nil;
   [myPhotos_ release], myPhotos_ = nil;
   [activityIndicatorView_ release], activityIndicatorView_ = nil;
    
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddPhoto" object:nil];
   
   [super dealloc];
}

- (id) init{
    if (self = [super init]) {
       // NSLog(@"%s",__PRETTY_FUNCTION__);
        [self addObserver];
    }
    return self;
}
- (void) addObserver {
    
    if (myPhotos_ == nil) {
        myPhotos_ = [[Photos alloc] init];
        [myPhotos_ setDelegate:self];
    }
    [self setDataSource:myPhotos_];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"AddPhoto" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification *note) {
        NSLog(@"%s",__PRETTY_FUNCTION__);
        
        NSData *jpegData = (NSData*)[[note userInfo] objectForKey:@"imageData"];
        UIImage *image = [UIImage imageWithData:jpegData];
        
        NSString * const key = @"nextNumber";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *nextNumber = [defaults valueForKey:key];
        if ( ! nextNumber ) {
            nextNumber = [NSNumber numberWithInt:1];
        }
        [defaults setObject:[NSNumber numberWithInt:([nextNumber intValue] + 1)] forKey:key];
        
        NSString *name = [NSString stringWithFormat:@"picture-%05i", [nextNumber intValue]];
        
        [myPhotos_ savePhoto:image withName:name addToPhotoAlbum:NO];
        
    }];

}

- (void)viewDidLoad 
{
   [super viewDidLoad];
   
   [self setTitle:NSLocalizedString(@"Photo Album", @"Photo Album screen title.")];
   
//   UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
//                                                                              target:self
//                                                                              action:@selector(addPhoto)];
//   [[self navigationItem] setRightBarButtonItem:addButton];
//   [addButton release];
   

    
    /*
     */
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
   [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
   [myPhotos_ flushCache];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
   return YES;
}

- (void)willLoadThumbs 
{
   [self showActivityIndicator];
}

- (void)didLoadThumbs 
{
   [self hideActivityIndicator];
}


#pragma mark -
#pragma mark Activity Indicator
   
- (UIActivityIndicatorView *)activityIndicator 
{
   if (activityIndicatorView_) {
      return activityIndicatorView_;
   }
   
   activityIndicatorView_ = [[UIActivityIndicatorView alloc] 
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   [activityIndicatorView_ setCenter:self.view.center];
   [[self view] addSubview:activityIndicatorView_];
   
   return activityIndicatorView_;
}

- (void)showActivityIndicator 
{
   [[self activityIndicator] startAnimating];
}

- (void)hideActivityIndicator 
{
   [[self activityIndicator] stopAnimating];
}


#pragma mark -
#pragma mark Actions

- (void)addPhoto 
{
   if (!photoPicker_) {
      photoPicker_ = [[PhotoPickerController alloc] initWithDelegate:self];
   }
   [photoPicker_ show];
}


#pragma mark -
#pragma mark PhotoPickerControllerDelegate

- (void)photoPickerController:(PhotoPickerController *)controller didFinishPickingWithImage:(UIImage *)image isFromCamera:(BOOL)isFromCamera 
{
   [self showActivityIndicator];
   
   NSString * const key = @"nextNumber";
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   NSNumber *nextNumber = [defaults valueForKey:key];
   if ( ! nextNumber ) {
      nextNumber = [NSNumber numberWithInt:1];
   }
   [defaults setObject:[NSNumber numberWithInt:([nextNumber intValue] + 1)] forKey:key];
   
   NSString *name = [NSString stringWithFormat:@"picture-%05i", [nextNumber intValue]];

   // Save to the photo album if picture is from the camera.
   [myPhotos_ savePhoto:image withName:name addToPhotoAlbum:isFromCamera];
}


#pragma mark -
#pragma mark PhotosDelegate

- (void)didFinishSave 
{
   [self reloadThumbs];
}


- (void) saveToAlbum:(NSData*)imageData{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            //[self displayErrorOnMainQueue:error withMessage:@"Save to camera roll failed"];
        }
        
    }];
    [library release];
    
}

- (void) sendAsEmail:(NSData*)imageData{

    MFMailComposeViewController *controller = 
    [[MFMailComposeViewController alloc] init];
    
    [controller setMailComposeDelegate:self];
    [controller addAttachmentData:imageData 
                         mimeType:@"image/jpeg" 
                         fileName:@"Image.jpg"];
    
    [controller setMessageBody:@"Image attached" isHTML:NO];
    
    // Show the status bar because, otherwise, we will have some layout
    // problems when the controller is dismissed.
    if ([[UIApplication sharedApplication] respondsToSelector:
         @selector(setStatusBarHidden:withAnimation:)]) 
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO 
                                                withAnimation:YES];
    } 
    else 
    {
        // get around deprecation warnings.
        id sharedApp = [UIApplication sharedApplication];
        [sharedApp setStatusBarHidden:NO animated:YES];
    }
    
    [self.navigationController presentModalViewController:controller 
                                                 animated:YES];
    [controller release]; 
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%s %d", __PRETTY_FUNCTION__, buttonIndex);
    NSData *imageData = [NSData dataWithContentsOfFile:self.imagePath];

    switch (buttonIndex) {
        case 0:
            [self saveToAlbum:imageData];
            break;
          
        case 1:
            [self sendAsEmail:imageData];
            break;
        case 2:
            
            break;
        default:
            break;
    }
}
- (void)exportImageAtPath:(NSString *)path
{
    self.imagePath = path;
    
   
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle:nil otherButtonTitles:@"Album", @"Email",  nil];
    //[actionSheet showInView:self.view];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark -
#pragma mark MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController*)controller 
			 didFinishWithResult:(MFMailComposeResult)result 
								error:(NSError*)error
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
