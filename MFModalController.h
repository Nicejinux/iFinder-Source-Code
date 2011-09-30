//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>

@interface MFModalController: UIViewController {
	NSAutoreleasePool *pool;
	id mc;
}

- (void) presentFrom: (id) mctrl;
- (void) close;

@end