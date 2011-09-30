//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFCompressController.h"

@implementation MFCompressController

@synthesize mainController = mainController;

// self

- (id) initWithFiles: (NSArray *) someFiles {

        self = [super init];

        self.title = NSLocalizedString(@"Compress Folder", @"Compress Folder");
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") style:UIBarButtonItemStyleDone target: self action: @selector(compress)] autorelease];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

        files = [[NSMutableArray alloc] init];
        [files addObjectsFromArray: someFiles];

        compressCommands = [[NSArray alloc] initWithObjects: @"cd %@; zip -r %@.zip %@", @"cd %@; tar -czf %@.gz %@", @"cd %@; tar --bzip2 -cf %@.bz2 %@", @"cd %@; xar -cf %@.xar %@", @"cd %@; dpkg-deb --build %@ %@", nil];

        fileName = [[UITextField alloc] initWithFrame: CGRectMake (20, 40, 280, 30)];
        fileName.backgroundColor = [UIColor clearColor];
        fileName.placeholder = NSLocalizedString(@"Type file name here",@"Type file name here");
        fileName.delegate = self;
        fileName.text = [[files objectAtIndex: 0] lastPathComponent];
        fileName.textAlignment = UITextAlignmentCenter;
        [self.view addSubview: fileName];
        [fileName release];

        type = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects: @"ZIP", @"GZIP", @"BZIP2", @"XAR", @"DEB", nil]];
        type.frame = CGRectMake (20, 100, 280, 45);
        type.selectedSegmentIndex = 0;
        [self.view addSubview: type];
        [type release];

        doCompress = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        doCompress.frame = CGRectMake (20,   180, 280, 45); 
        [doCompress setTitle: NSLocalizedString(@"Compress",@"Compress") forState: UIControlStateNormal];
        [doCompress addTarget: self action: @selector(compress) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview: doCompress];

        return self;

}

- (void) compress {
        if (type.selectedSegmentIndex == 4) {
                NSString *cmd = [[NSString alloc] initWithFormat: [compressCommands objectAtIndex: type.selectedSegmentIndex], [self.mainController currentDirectory], [[files objectAtIndex: 0] lastPathComponent], [[files objectAtIndex: 0] lastPathComponent]];
                thread = [[MFThread alloc] init];
                thread.delegate = self;
                thread.cmd = cmd;
                [cmd release];
                [thread start];
                loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeCompressing];
                [loadingView show];

        } else {
            if ((fileName.text == nil) || [fileName.text isEqualToString: @""]) {
                [[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Compress failed", @"Compress failed") message: NSLocalizedString(@"Please specify output filename.",@"Please specify output filename.") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss",@"Dismiss") otherButtonTitles: nil] autorelease] show];
                return;
            } else {
                loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeCompressing];
                [loadingView show];
                NSString *cmd = [[NSString alloc] initWithFormat: [compressCommands objectAtIndex: type.selectedSegmentIndex], [self.mainController currentDirectory], [files componentsJoinedByString: @" "], fileName.text];
                thread = [[MFThread alloc] init];
                thread.delegate = self;
                thread.cmd = cmd;
                [cmd release];
                [thread start];
            }

        }

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

        [super dealloc];

}

@end
