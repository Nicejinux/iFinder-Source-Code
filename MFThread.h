//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <Foundation/Foundation.h>

@protocol MFThreadDelegate;

@interface MFThread: NSThread {
	id <MFThreadDelegate> delegate;
	NSString *cmd;
	int exitCode;
    NSString *algo;
}

@property (retain) id <MFThreadDelegate> delegate;
@property (retain) NSString *cmd;
@property (readonly) int exitCode;

@end

@protocol MFThreadDelegate

- (void) threadEnded: (MFThread *) thread;

@end

