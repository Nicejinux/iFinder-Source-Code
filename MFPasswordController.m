//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFPasswordController.h"

@implementation MFPasswordController

@synthesize delegate = delegate;

// super

- (id) init {

	self = [super init];
	
	self.title = NSLocalizedString(@"Enter password", @"Enter password");
	self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") style:UIBarButtonItemStyleDone target: self action: @selector(done)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
	
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.dataSource = self;
	tableView.scrollEnabled = NO;
	
	textField = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 140, 30)];
	textField.delegate = self;
	textField.secureTextEntry = YES;
	textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[self.view addSubview: tableView];
    
	return self;
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return 1;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFPCCell"];
	cell.text = NSLocalizedString(@"Password:", @"Password:");
	[cell.contentView addSubview: textField];
	
	return cell;
	
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];
	[self done];
	
	return YES;
	
}

- (void) done {
	
	if ([textField.text isEqualToString: [[NSUserDefaults standardUserDefaults] objectForKey: @"MFPasswordString"]]) {
	
		[self.delegate passwordControllerAcceptedPassword];
		
	} else {
	
		[[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Wrong password", @"Wrong password") message: NSLocalizedString(@"You have entered an incorrect password. Please try again.", @"You have entered an incorrect password. Please try again.") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];
		
	}
	
}

@end

