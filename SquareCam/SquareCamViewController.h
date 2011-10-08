/*
     File: SquareCamViewController.h
 Abstract: Dmonstrates iOS 5 features of the AVCaptureStillImageOutput class
  Version: 1.0 
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class CIDetector;

@interface SquareCamViewController : UIViewController <UIGestureRecognizerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
	IBOutlet UIView *previewView;
    IBOutlet UIButton *resultThumb;
	//IBOutlet UISegmentedControl *camerasControl;
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
}

- (IBAction)takePicture:(id)sender;
- (IBAction)switchCameras:(id)sender;
//- (IBAction)handlePinchGesture:(UIGestureRecognizer *)sender;
//- (IBAction)toggleFaceDetection:(id)sender;

@end
