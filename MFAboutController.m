//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFAboutController.h"

@implementation MFAboutController

- (id) init {

	self = [super init];
	
	self.title = NSLocalizedString(@"About & Help", @"About & Help");
	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	webView = [[UIWebView alloc] initWithFrame: CGRectMake (0, 0, 320, 460)];
	webView.scalesPageToFit = YES;
	webView.userInteractionEnabled = YES;
	webView.multipleTouchEnabled = YES;
	webView.autoresizingMask = self.view.autoresizingMask;
	[webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"about" ofType: @"html"]]]];
	[self.view addSubview: webView];
	[webView release];
	
	return self;
	
}

@end

