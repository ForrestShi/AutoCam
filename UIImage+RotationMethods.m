//
//  UIImage+RotationMethods.m
//  SquareCam 
//
//  Created by forrest on 11-10-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+RotationMethods.h"
#import "ImageUtility.h"




@implementation UIImage (RotationMethods)

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees 
{   
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	[rotatedViewBox release];
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
	
}


- (UIImage*)image:(UIImage*)base overlay:(UIImage*)overlay {
	CGSize size = base.size;
	UIGraphicsBeginImageContext(size);
	[base drawInRect:CGRectMake(0, 0, size.width, size.height)];
	[overlay drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (UIImage*)image:(UIImage*)base resize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	[base drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}


@end
