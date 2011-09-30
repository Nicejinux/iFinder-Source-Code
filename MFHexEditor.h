//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>
#import "MFFile.h"

@interface MFHexEditor: UIView <UITextViewDelegate> {
	MFFile *file;
	NSString *hexData;
	UITextView *textView;
	UITextView *bytes;
	UITextView *ascii;
}

@property (retain) MFFile *file;
@property (retain) NSString *hexData;

- (MFHexEditor *) initWithFile: (MFFile *) aFile;
- (void) save;

@end

