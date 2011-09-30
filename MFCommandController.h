//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import <stdlib.h>
#import <unistd.h>
#import <stdio.h>
#import "MFModalController.h"

@interface MFCommandController: MFModalController <UIAlertViewDelegate> {
	UITextView *output;
	NSTimer *timer;
	NSString *cmd;
	FILE *f;
}

- (id) initWithCommand: (NSString *) command;
- (void) start;
- (void) update;
- (void) end;

@end
