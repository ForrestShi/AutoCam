//
//  AppConfigure.m
//  AutoCam

#import "AppConfigure.h"

static AppConfigure *_instance;
@implementation AppConfigure

@synthesize isLite, appName, faceCount;

#pragma mark -
#pragma mark Singleton Methods

+ (AppConfigure*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            
            // Allocate/initialize any member variables of the singleton class here
            // example
			//_instance.member = @"";
            
            NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"common" ofType:@"plist"];
            NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistFile];
            _instance.isLite = [[plistDict objectForKey:@"isLiteVersion"] boolValue];
            //_instance.appName = [[plistDict objectForKey:@"AppName"] stringValue];
            _instance.faceCount = [NSNumber numberWithInt:[[plistDict objectForKey:@"faceCount"] intValue]];
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [super allocWithZone:zone];			
            return _instance;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here

@end
