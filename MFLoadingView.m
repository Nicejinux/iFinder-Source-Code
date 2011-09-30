//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFLoadingView.h"

@implementation MFLoadingView

// super

- (id) initWithType: (MFLoadingViewType) type {

	self = [super initWithFrame: CGRectMake (0, 0, 320, 480)];
	background = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"loadingbg.png"]];
	background.frame = CGRectMake (80, 160, 160, 160);
	[self addSubview: background];

	spinwheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	spinwheel.center = CGPointMake (160, 240);
	[self addSubview: spinwheel];
	
	text = [[UILabel alloc] initWithFrame: CGRectMake (90, 170, 140, 30)];
	text.backgroundColor = [UIColor clearColor];
	text.textColor = [UIColor whiteColor];
	text.font = [UIFont boldSystemFontOfSize: 18.0];
	text.textAlignment = UITextAlignmentCenter;
	[self addSubview: text];

	if (type == MFLoadingViewTypeProgress) {
		progressBar = [[UIProgressView alloc] initWithFrame: CGRectMake (90, 290, 140, 20)];
		[self addSubview: progressBar];
		text.text = NSLocalizedString(@"Loading file", @"Loading file");	
	} else if (type == MFLoadingViewTypeTemporary) {
		progressBar = nil;
		text.text = NSLocalizedString(@"Working", @"Working");
	}else if (type == MFLoadingViewTypeCopying) {
		progressBar = nil;
		text.text = NSLocalizedString(@"Copying File", @"Copying File");
	}else if (type == MFLoadingViewTypeMoving) {
		progressBar = nil;
		text.text = NSLocalizedString(@"Moving File", @"Moving File");
	}else if (type == MFLoadingViewTypeCompressing) {
		progressBar = nil;
		text.text = NSLocalizedString(@"Compressing File(s)", @"Compressing File(s)");
	}else if (type == MFLoadingViewTypeInstalling) {
		progressBar = nil;
		text.text = NSLocalizedString(@"Installing", @"Installing");
	}else if (type == MFLoadingViewTypeBackuping) {
		progressBar = nil;
		text.text = NSLocalizedString(@"Backuping", @"Backuping");
	}else if (type == MFLoadingViewTypeRestoring) {
		progressBar = nil;
		text.text = NSLocalizedString(@"Restoring...", @"Restoring...");
	}else if (type == MFLoadingViewTypeValidating) {
		progressBar = nil;
		text.text = NSLocalizedString(@"Validating...", @"Validating...");
	}
	
	return self;
	
}
		
- (void) dealloc {

	[background release];
	background = nil;
	[spinwheel release];
	spinwheel = nil;
	[progressBar release];
	progressBar = nil;
	[text release];
	text = nil;
	
	[super dealloc];
	
}

// self

- (void) show {

	[[[UIApplication sharedApplication] keyWindow] addSubview: self];
	[spinwheel startAnimating];

}

- (void) hide {

	[spinwheel stopAnimating];
	[self removeFromSuperview];

}

- (void) setProgress: (float) progress {

	progressBar.progress = progress;

}

- (void) setTitle: (NSString *) title {

	text.text = title;
	
}

@end

