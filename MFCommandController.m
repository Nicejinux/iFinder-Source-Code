//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import "MFCommandController.h"

@implementation MFCommandController

// self

- (id) initWithCommand: (NSString *) command {

	self = [super init];

	self.navigationItem.title = NSLocalizedString(@"Executing", @"Executing");
    self.navigationItem.leftBarButtonItem.enabled = NO;
	cmd = [command copy];

	output = [[UITextView alloc] initWithFrame: (UIInterfaceOrientationIsPortrait (self.interfaceOrientation) ? CGRectMake (0, 0, 320, 460) : [[UIScreen mainScreen] applicationFrame])];
	output.editable = NO;
	output.text = [NSString stringWithFormat: NSLocalizedString(@"Executing:\n%@...\n\n", @"Executing:\n%@...\n\n"), cmd];
	//output.font = [UIFont systemFontOfSize:12.0 /*fontWithName: @"Courir-BoldMT" size: 12.0*/];
	output.backgroundColor = [UIColor blackColor];
	output.textColor = [UIColor whiteColor];
	output.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: output];
	[output release];

	return self;

}

- (void) start {

	f = popen ([[NSString stringWithFormat:@"%@ 2>&1", cmd] UTF8String], "r");
	if (f == NULL) {
		[[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Command failed", @"Command failed") message: NSLocalizedString(@"The specified command couldn't be executed.", @"The specified command couldn't be executed.") delegate: nil cancelButtonTitle: @"Dismiss" otherButtonTitles: nil] autorelease] show];
	} else {
		 timer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(update) userInfo: NULL repeats: YES];
	}
	
}

- (void) update {

	char *out = malloc (sizeof(char) * 1025);

	if (fgets (out, 1024, f) != NULL) {
		output.text = [output.text stringByAppendingFormat: @"%s", out];
	} else {
		[self end];
	}
    
	free (out);

}

- (void) end {

	[timer invalidate];
	int exitCode = pclose (f);
	output.text = [output.text stringByAppendingFormat: NSLocalizedString(@"\nFinished with exit code: %i\n", @"\nFinished with exit code: %i\n"), exitCode];
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    if ([cmd rangeOfString:@"dpkg -i"].location !=NSNotFound && exitCode == 0){
        UIAlertView *respiring = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Installed Succesfully", @"Installed Succesfully") message:NSLocalizedString(@"Would you like to restart SpringBoard?", @"Would you like to restart SpringBoard?")
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"No") otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
        respiring.tag = 1;
        [respiring show];
        [respiring release];
    }
}

// super
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1 & actionSheet.tag==1)
    {
        system("killall SpringBoard");
    }
}

- (void) dealloc {

	[cmd release];

	[super dealloc];

}

@end
