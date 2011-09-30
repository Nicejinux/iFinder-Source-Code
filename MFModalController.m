//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFModalController.h"

@implementation MFModalController

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {
    
	return (orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationLandscapeRight);
    
}

- (id) init {
    
	self = [super init];
    
	pool = [[NSAutoreleasePool alloc] init];
    
	self.view.backgroundColor = [UIColor whiteColor];
    
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Close", @"Close") style: UIBarButtonItemStylePlain target: self action: @selector(close)];
	self.navigationItem.leftBarButtonItem = leftButtonItem;
	[leftButtonItem release];
    
	return self;
    
}

- (void) dealloc {
    
	[pool release];
	pool = nil;
    
	[super dealloc];
    
}

// self

- (void) presentFrom: (id) mctrl {
    
	mc = mctrl;
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: self];
	navController.navigationBar.barStyle = UIBarStyleBlack;
	[mc presentModalViewController: navController animated: YES];
    [navController release];
    
}

- (void) close {
    
	[mc dismissModalViewControllerAnimated: YES];
    
}

@end

