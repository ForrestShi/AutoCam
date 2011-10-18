//
//  AppConfigure.h
//  AutoCam
//
#import <Foundation/Foundation.h>

@interface AppConfigure : NSObject {

}
@property (nonatomic,assign) BOOL isLite;
@property (nonatomic,copy  ) NSString *appName;
@property (nonatomic,assign) NSNumber *faceCount;


+ (AppConfigure*) sharedInstance;

@end
