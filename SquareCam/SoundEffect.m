/*
     File: SoundEffect.m
 Abstract: SoundEffect is a class that loads and plays sound files.
  Version: 1.11

 
*/

#import "SoundEffect.h"

@implementation SoundEffect

// Creates a sound effect object from the specified sound file
+ (id)soundEffectWithContentsOfFile:(NSString *)aPath {
    if (aPath) {
        return [[[SoundEffect alloc] initWithContentsOfFile:aPath] autorelease];
    }
    return nil;
}

// Initializes a sound effect object with the contents of the specified sound file
- (id)initWithContentsOfFile:(NSString *)path {
    self = [super init];
    
	// Gets the file located at the specified path.
    if (self != nil) {
        NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
        
		// If the file exists, calls Core Audio to create a system sound ID.
        if (aFileURL != nil)  {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, &aSoundID);
            
            if (error == kAudioServicesNoError) { // success
                _soundID = aSoundID;
            } else {
                NSLog(@"Error %d loading sound at path: %@", error, path);
                [self release], self = nil;
            }
        } else {
            NSLog(@"NSURL is nil for path: %@", path);
            [self release], self = nil;
        }
    }
    return self;
}

// Releases resouces when no longer needed.
-(void)dealloc {
    AudioServicesDisposeSystemSoundID(_soundID);
    [super dealloc];
}

// Plays the sound associated with a sound effect object.
-(void)play {
	// Calls Core Audio to play the sound for the specified sound ID.
    AudioServicesPlaySystemSound(_soundID);
}

@end
