/*
     File: SquareCamViewController.h
 Abstract: Dmonstrates iOS 5 features of the AVCaptureStillImageOutput class
  Version: 1.0 
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class CIDetector;
@class LocalImageRootViewController;

@interface SquareCamViewController : UIViewController <UIGestureRecognizerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
	IBOutlet UIView *previewView;
    IBOutlet UIImageView *tapImageView;
    IBOutlet UILabel  * tipLabel;
    IBOutlet UIButton *switchCamButton;
    IBOutlet UIButton *resultImageButton;
    UINavigationController *navController_;
    LocalImageRootViewController *thumbsViewController;
    BOOL capturingFace;
    
	AVCaptureVideoPreviewLayer *previewLayer;
	AVCaptureVideoDataOutput *videoDataOutput;
	BOOL detectFaces;
	dispatch_queue_t videoDataOutputQueue;
	AVCaptureStillImageOutput *stillImageOutput;
	UIView *flashView;
	UIImage *square;
	BOOL isUsingFrontFacingCamera;
	CIDetector *faceDetector;
	CGFloat beginGestureScale;
	CGFloat effectiveScale;
    
    BOOL isLite;
    NSString *appName;
    NSNumber *faceCount;
}

@property (nonatomic, retain)  UINavigationController *navController;
@property (nonatomic, assign)  BOOL capturingFace;

- (IBAction)takePicture:(id)sender;
- (IBAction)switchCameras:(id)sender;
- (IBAction)handlePinchGesture:(UIGestureRecognizer *)sender;
- (IBAction)onInfoButton:(id)sender;

@end
