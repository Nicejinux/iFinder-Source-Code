//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFCompressMultipleController.h"

@implementation MFCompressMultipleController

@synthesize mainController = mainController;

// self

- (id) init{

        self = [super init];

        self.title = NSLocalizedString(@"Compress Files", @"Compress Files");
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") style:UIBarButtonItemStyleDone target: self action: @selector(compress)] autorelease];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

        compressCommands = [[NSArray alloc] initWithObjects: @"cd %@; zip -r %@.zip %@", @"cd %@; tar -czf %@.gz %@", @"cd %@; tar --bzip2 -cf %@.bz2 %@", @"cd %@; xar -cf %@.xar %@", nil];

        fileName = [[UITextField alloc] initWithFrame: CGRectMake (20, 40, 280, 30)];
        fileName.placeholder = NSLocalizedString(@"Type Output Name Here", @"Type Output Name Here");
        fileName.backgroundColor = [UIColor clearColor];
        fileName.delegate = self;
        fileName.textAlignment = UITextAlignmentCenter;
        [self.view addSubview: fileName];
        [fileName release];

        type = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects: @"ZIP", @"GZIP", @"BZIP2", @"XAR", nil]];
        type.frame = CGRectMake (20, 100, 280, 45);
        type.selectedSegmentIndex = 0;
        [self.view addSubview: type];
        [type release];

        doCompress = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        doCompress.frame = CGRectMake (20,   180, 280, 45); 
        [doCompress setTitle: NSLocalizedString(@"Compress", @"Compress") forState: UIControlStateNormal];
        [doCompress addTarget: self action: @selector(compress) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview: doCompress];

        return self;

}

- (void) compress {
        [fileName resignFirstResponder];
        if ((fileName.text == nil) || [fileName.text isEqualToString: @""]) {
            [[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Compress failed", @"Compress failed") message: NSLocalizedString(@"Please specify output filename.", @"Please specify output filename.") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];
                return;
        } else {
            loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
            [loadingView show];
        }
        NSString *compriming = [[NSString alloc] initWithContentsOfFile:@"/var/mobile/Library/iFinder/stc" usedEncoding:nil error:nil];
        compriming = [compriming stringByReplacingOccurrencesOfString:[self.mainController currentDirectory] withString:@""];
        compriming = [compriming stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSString *cmd = [[NSString alloc] initWithFormat: [compressCommands objectAtIndex: type.selectedSegmentIndex], [self.mainController currentDirectory], [fileName text] ,compriming];
        thread = [[MFThread alloc] init];
        thread.delegate = self;
        thread.cmd = cmd;
        [cmd release];
        [thread start];
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

        [textField resignFirstResponder];

        return YES;

}

// MFThreadDelegate

- (void) threadEnded: (MFThread *) theThread {

        [loadingView hide];
        [self.mainController reloadDirectory];
        if (theThread.exitCode == 0) {
                [self close];
                [self.mainController reloadDirectory];
        } else {
                [[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Compress failed", @"Compress failed") message: [NSString stringWithFormat: @"%@: %@\n%@: %i", NSLocalizedString(@"Failed command", @"Failed command"), theThread.cmd, NSLocalizedString(@"Exit code", @"Exit code"), theThread.exitCode] delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];
        }

}

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

        return UIInterfaceOrientationIsPortrait (orientation);

}

- (void) dealloc {

        [files release];
        files = nil;
        [compressCommands release];
        compressCommands = nil;
        [thread release];
        thread = nil;
        [fileName release];

        [super dealloc];

}

- (void) close {
    
	[mc dismissModalViewControllerAnimated: YES];
    fileName.text = @"";
    
}
@end
