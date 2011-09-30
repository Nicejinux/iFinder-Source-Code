//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFThread.h"

@implementation MFThread

@synthesize delegate = delegate;
@synthesize cmd = cmd;
@synthesize exitCode = exitCode;

- (void) main {

	exitCode = system ([self.cmd UTF8String]);
    
    
	[self.delegate threadEnded: self];
	
}

@end

