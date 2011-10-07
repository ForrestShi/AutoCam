//
//  UIViewController+CameraSetup.m
//  SquareCam 
//
//  Created by forrest on 11-10-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+CameraSetup.h"


@implementation UIViewController (CameraSetup)


- (DDExpandableButton*) torchModeButton{
    DDExpandableButton *torchModeButton = [[[DDExpandableButton alloc] initWithPoint:CGPointMake(20.0f, 20.0f)
																		   leftTitle:[UIImage imageNamed:@"Flash.png"]
																			 buttons:[NSArray arrayWithObjects:@"Auto", @"On", @"Off", nil]] autorelease];

	[torchModeButton addTarget:self action:@selector(toggleFlashlight:) forControlEvents:UIControlEventValueChanged];
	[torchModeButton setVerticalPadding:6];
	[torchModeButton updateDisplay];
    
	[torchModeButton setSelectedItem:2];
    return torchModeButton;
}

- (DDExpandableButton*) toggleButton{
    DDExpandableButton *toggleButton = [[[DDExpandableButton alloc] initWithPoint:CGPointMake(20.0f, 155.0f)
																		leftTitle:nil
																		  buttons:[NSArray arrayWithObjects:@"HDR On", @"HDR Off", nil]] autorelease];
	[toggleButton addTarget:self action:@selector(toggleBkgd:) forControlEvents:UIControlEventValueChanged];
	[toggleButton setToggleMode:YES];
	[toggleButton setInnerBorderWidth:0];
	[toggleButton setHorizontalPadding:6];
	[toggleButton updateDisplay];
    return toggleButton;
}

- (void)toggleFlashlight:(DDExpandableButton *)sender
{
	if (NSClassFromString(@"AVCaptureDevice") != nil)
	{
		AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		
		if ([device hasTorch])
		{
			[device lockForConfiguration:nil];
			[device setTorchMode:(2 - [sender selectedItem])];
			[device unlockForConfiguration];
		}		
	}
}

- (void)toggleBkgd:(DDExpandableButton *)sender
{
	switch ([sender selectedItem])
	{
		case 0:
			[self.view setBackgroundColor:[UIColor grayColor]];
			break;
		case 1:
			[self.view setBackgroundColor:[UIColor lightGrayColor]];
			break;
	}
}

@end
