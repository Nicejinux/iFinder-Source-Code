//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFSettingsController.h"

@implementation MFSettingsController

@synthesize mainController = mainController;

// super

- (void) close {
    
	[self.mainController settingsControllerDidClose:self];
	[super close];
	
}

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return (orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown);
	
}
-(void) viewWillDisappear:(BOOL)animated {
}
- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"Registering for keyboard events");
    
	// Register for the events
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector (keyboardDidShow:)
     name: UIKeyboardDidShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector (keyboardDidHide:)
     name: UIKeyboardDidHideNotification
     object:nil];
    
	// Setup content size
	tableView.contentSize = CGSizeMake(320, 900);
    
	//Initially the keyboard is hidden
	keyboardVisible = NO;
    
    NSInteger crit = [[NSUserDefaults standardUserDefaults] integerForKey:@"SortCriteria"]; 
	if (crit == 0){
        criteria.text = NSLocalizedString(@"Name", @"Name");
    } else if (crit == 1){
        criteria.text = NSLocalizedString(@"Type", @"Type");
    } else if (crit == 2){
        criteria.text = NSLocalizedString(@"Size", @"Size");
    } else if (crit == 3){
        criteria.text = NSLocalizedString(@"Creation", @"Creation");
    } else if (crit == 4){
        criteria.text = NSLocalizedString(@"Modification", @"Modification");
    } else {
        criteria.text = NSLocalizedString(@"Name", @"Name");
    }
    
    NSInteger ord = [[NSUserDefaults standardUserDefaults] integerForKey:@"SortOrder"]; 
	if (ord == 0){
        order.text = NSLocalizedString(@"Ascending", @"Ascending");
    } else if (ord == 1){
        order.text = NSLocalizedString(@"Descending", @"Descending");
    } else {
        order.text = NSLocalizedString(@"Ascending", @"Ascending");
    }
    
    NSInteger them = [[NSUserDefaults standardUserDefaults] integerForKey:@"MFTheme"]; 
	if (them == 0){
        selectedtheme.text = @"Crystal";
    } else if (them == 1){
        selectedtheme.text = @"Metallen";
    } else {
        selectedtheme.text = @"Crystal";
    }
    
    [tableView reloadData];
}

-(void) keyboardDidShow: (NSNotification *)notif {
	NSLog(@"Keyboard is visible");
	// If keyboard is visible, return
	if (keyboardVisible) {
		NSLog(@"Keyboard is already visible. Ignore notification.");
		return;
	}
    tableView.scrollEnabled = YES;
    offset = CGPointMake(0, 0);
    if([uploadPath isFirstResponder]){
        // Get the size of the keyboard.
        NSDictionary* info = [notif userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        // Save the current location so we can restore
        // when keyboard is dismissed
        offset = tableView.contentOffset;
        
        // Resize the scroll view to make room for the keyboard
        CGRect viewFrame = CGRectMake(0, 0, 320, 660);
        viewFrame.size.height -= keyboardSize.height;
        tableView.frame = viewFrame;
        tableView.contentSize = CGSizeMake(320, 910);
        
        CGRect textFieldRect = [uploadPath frame];
        CGRect uploadrect = CGRectMake(0, 310, 320, 750);
        [tableView scrollRectToVisible:uploadrect animated:YES];
    }
    if([fontSize isFirstResponder]){
        // Get the size of the keyboard.
        NSDictionary* info = [notif userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        // Save the current location so we can restore
        // when keyboard is dismissed
        offset = tableView.contentOffset;
        
        // Resize the scroll view to make room for the keyboard
        CGRect viewFrame = CGRectMake(0, 0, 320, 550);
        viewFrame.size.height -= keyboardSize.height;
        tableView.frame = viewFrame;
        
        CGRect textFieldRect = [fontSize frame];
        CGRect fontrect = CGRectMake(0, 310, 320, 550);
        [tableView scrollRectToVisible:fontrect animated:YES];
    }
    if([homestring isFirstResponder]){
        // Get the size of the keyboard.
        NSDictionary* info = [notif userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        // Save the current location so we can restore
        // when keyboard is dismissed
        offset = tableView.contentOffset;
        
        // Resize the scroll view to make room for the keyboard
        CGRect viewFrame = CGRectMake(0, 0, 320, 550);
        viewFrame.size.height -= keyboardSize.height;
        tableView.frame = viewFrame;
        
        CGRect textFieldRect = [homestring frame];
        CGRect fontrect = CGRectMake(0, 310, 320, 200);
        [tableView scrollRectToVisible:fontrect animated:YES];
    }
	NSLog(@"ao fim");
	// Keyboard is now visible
    keyboardVisible = YES;
    tableView.scrollEnabled = NO;
}

-(void) keyboardDidHide: (NSNotification *)notif {
	// Is the keyboard already shown
	if (!keyboardVisible) {
		NSLog(@"Keyboard is already hidden. Ignore notification.");
		return;
	}
    
	// Reset the frame scroll view to its original value
	tableView.frame = CGRectMake(0, 0, 320, 460);
    
	// Reset the scrollview to previous location
	tableView.contentOffset = offset;
    
	// Keyboard is no longer visible
	keyboardVisible = NO;
    tableView.scrollEnabled = YES;
	tableView.contentSize = CGSizeMake(320, 710);
}

- (id) init {

	self = [super init];

	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	self.title = NSLocalizedString(@"Settings", @"Settings");

	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") style:UIBarButtonItemStyleDone target: self action: @selector(done)];
	self.navigationItem.rightBarButtonItem = rightButtonItem;
	[rightButtonItem release];


	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.contentSize = CGSizeMake(320, 710);
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.scrollEnabled = YES;
	[self.view addSubview: tableView];
	
	passwordEnabled = [[UISwitch alloc] initWithFrame: CGRectMake (217, 8, 80, 30)];
	passwordEnabled.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	passwordEnabled.on = [[NSUserDefaults standardUserDefaults] boolForKey: @"MFPasswordEnabled"];
	
	passwordString = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 180, 30)];
	passwordString.secureTextEntry = YES;
	passwordString.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	passwordString.placeholder = NSLocalizedString(@"Type password", @"Type password");
	passwordString.text = [[NSUserDefaults standardUserDefaults] stringForKey: @"MFPasswordString"];
	passwordString.delegate = self;
	
    homestring = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 180, 30)];
	homestring.secureTextEntry = NO;
    homestring.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    homestring.placeholder = NSLocalizedString(@"Type Home Path", @"Type Home Path");
    homestring.text = [[NSUserDefaults standardUserDefaults] stringForKey: @"MFHome"];
    homestring.delegate = self;
    homestring.autocorrectionType = UITextAutocorrectionTypeNo;
    homestring.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    usetrash = [[UISwitch alloc] initWithFrame: CGRectMake (217, 8, 80, 30)];
	usetrash.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	//usetrash.on = [[NSUserDefaults standardUserDefaults] boolForKey: @"MFTrashEnabled"];
    if ([[[NSUserDefaults standardUserDefaults] stringForKey: @"MFTrashEnabled"] isEqualToString:@"YES"]){
        usetrash.on = YES;
    } else{
        usetrash.on = NO;
    }

//	fontSize = [[UITextField alloc] initWithFrame: CGRectMake (140, 250, 140, 30)];
	fontSize = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 140, 30)];
	fontSize.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	fontSize.placeholder = NSLocalizedString(@"Font size of text editor", @"Font size of text editor");
	fontSize.text = [NSString stringWithFormat: @"%2.1f", [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] != 0.0 ? [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] : 12.0];
	fontSize.delegate = self;
    fontSize.textAlignment = UITextAlignmentCenter;
	
//	uploadPath = [[UITextField alloc] initWithFrame: CGRectMake (140, 425, 140, 30)];
	uploadPath = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 140, 30)];
	uploadPath.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	uploadPath.placeholder = @"Dropbox upload path";
    uploadPath.text = @"/Public/iFinder";
	uploadPath.text = [[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"];
	uploadPath.delegate = self;
//    uploadPath.enabled = NO;

	aboutController = [[MFAboutController alloc] init];
    sortCriteria = [[MFSortCriteria alloc] init];
    sortOrder = [[MFSortOrder alloc] init];
    themeSelect = [[MFThemeSelect alloc] init];
    
    /*theme = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects: @"Crystal Theme", @"Metallen Theme", nil]];
    theme.frame = CGRectMake (10, 0, 280, 45);
    theme.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey: @"MFTheme"];*/
	
	return self;

}

- (void) viewDidLoad {
	criteria = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 140, 30)];
	criteria.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    NSInteger crit = [[NSUserDefaults standardUserDefaults] integerForKey:@"SortCriteria"]; 
	if (crit == 0){
        criteria.text = NSLocalizedString(@"Name", @"Name");
    } else if (crit == 1){
        criteria.text = NSLocalizedString(@"Type", @"Type");
    } else if (crit == 2){
        criteria.text = NSLocalizedString(@"Size", @"Size");
    } else if (crit == 3){
        criteria.text = NSLocalizedString(@"Creation", @"Creation");
    } else if (crit == 4){
        criteria.text = NSLocalizedString(@"Modification", @"Modification");
    } else {
        criteria.text = NSLocalizedString(@"Name", @"Name");
    }
    criteria.textAlignment = UITextAlignmentRight;
	criteria.delegate = self;
	criteria.enabled = NO;
    
    order = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 140, 30)];
    order.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    NSInteger ord = [[NSUserDefaults standardUserDefaults] integerForKey:@"SortOrder"]; 
	if (ord == 0){
        order.text = NSLocalizedString(@"Ascending", @"Ascending");
    } else if (ord == 1){
        order.text = NSLocalizedString(@"Descending", @"Descending");
    } else {
        order.text = NSLocalizedString(@"Ascending", @"Ascending");
    }
    order.textAlignment = UITextAlignmentRight;
    order.delegate = self;
    order.enabled = NO;
    
    selectedtheme = [[UITextField alloc] initWithFrame: CGRectMake (140, 10, 140, 30)];
    selectedtheme.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    NSInteger them = [[NSUserDefaults standardUserDefaults] integerForKey:@"MFTheme"]; 
	if (them == 0){
        selectedtheme.text = @"Crystal";
    } else if (them == 1){
        selectedtheme.text = @"Metallen";
    } else {
        selectedtheme.text = @"Crystal";
    }
    selectedtheme.textAlignment = UITextAlignmentRight;
    selectedtheme.delegate = self;
    selectedtheme.enabled = NO;
}

- (void) done {
    seteuid(501);
	[[NSUserDefaults standardUserDefaults] setBool: passwordEnabled.on forKey: @"MFPasswordEnabled"];
	[[NSUserDefaults standardUserDefaults] setObject: passwordString.text forKey: @"MFPasswordString"];
    [[NSUserDefaults standardUserDefaults] setObject: homestring.text forKey: @"MFHome"];
    if (usetrash.on){
        NSString *trash = @"YES";
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:trash forKey:@"MFTrashEnabled"];
        [prefs synchronize];
    }
    else{
        NSString *trash = @"NO";
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:trash forKey:@"MFTrashEnabled"];
        [prefs synchronize];
    }
	[[NSUserDefaults standardUserDefaults] setFloat: [fontSize.text floatValue] forKey: @"MFFontSize"];
	[[NSUserDefaults standardUserDefaults] setObject: uploadPath.text forKey: @"MFDropboxUploadPath"];
    //[[NSUserDefaults standardUserDefaults] setInteger: theme.selectedSegmentIndex forKey: @"MFTheme"];
    seteuid(0);
	[[self mainController] reloadDirectory];
    [self close];
}

- (void) dealloc {

	[tableView release];
	tableView = nil;
	[aboutController release];
	aboutController = nil;
    [sortCriteria release];
	sortCriteria = nil;
	[passwordEnabled release];
	passwordEnabled = nil;
	[passwordString release];
	passwordString = nil;
	[fontSize release];
	fontSize = nil;
    [homestring release];
    homestring = nil;
    [usetrash release];
    usetrash = nil;
	[super dealloc];

}

// UITableViewDataSource

- (int) numberOfSectionsInTableView: (UITableView *) theTableView {

	return 3;
	
}

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	int nRows;
	
	if (section == 0) {
        
		nRows = 1;
		
	} else if (section == 1) {
	
		nRows = 9;
		
	} else if (section == 2) {
        
		nRows = 2;
		
	}

	return nRows;

}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {

	NSString *title;

	if (section == 0) {
		title = @"";
	} else if (section == 1) {
		title = NSLocalizedString(@"Application", @"Application");
	} else if (section == 2) {
		title = NSLocalizedString(@"Dropbox", @"Dropbox");
	}
	
	return title;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	/*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MFSCCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFSCCell"] autorelease];
	}*/
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil] autorelease];
	}
	
	if (indexPath.section == 1) {
	
		if (indexPath.row == 0) {
		
			cell.text = NSLocalizedString(@"Password Protection", @"Password Protection");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[cell.contentView addSubview: passwordEnabled];
			
		} else if (indexPath.row == 1) {
		
			cell.text = NSLocalizedString(@"Password", @"Password");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[cell.contentView addSubview: passwordString];
			
		} else if (indexPath.row == 2) {
		
			cell.text = NSLocalizedString(@"Home Path", @"Home Path");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[cell.contentView addSubview: homestring];
			
		} else if (indexPath.row == 3) {
            
			cell.text = NSLocalizedString(@"Use Trash", @"Use Trash");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[cell.contentView addSubview: usetrash];
			
		} else if (indexPath.row == 4) {
            
			cell.text = NSLocalizedString(@"Sort Criteria", @"Sort Criteria");
            //[cell.contentView addSubview: criteria];
            cell.detailTextLabel.text = criteria.text;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
		} else if (indexPath.row == 5) {
            
			cell.text = NSLocalizedString(@"Sort Order", @"Sort Order");
            //[cell.contentView addSubview: order]; 
            cell.detailTextLabel.text = order.text;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
		} else if (indexPath.row == 6) {
            
			cell.text = NSLocalizedString(@"Text font size", @"Text font size");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[cell.contentView addSubview: fontSize];
			
		} else if (indexPath.row == 7) {
            
            cell.text = NSLocalizedString(@"Theme", @"Theme");
            //[cell.contentView addSubview: selectedtheme];
            cell.detailTextLabel.text = selectedtheme.text;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
		} else if (indexPath.row == 8) {
            
			cell.text = NSLocalizedString(@"About iFinder & Help", @"About iFinder & Help");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
        
		
	} else if (indexPath.section == 2) {
	
		if (indexPath.row == 0) {
	
			cell.text = [[DBSession sharedSession] isLinked] ? NSLocalizedString(@"Unlink Device from Dropbox", @"Unlink Device from Dropbox") : NSLocalizedString(@"Log in to Dropbox", @"Log in to Dropbox");
			
		} else if (indexPath.row == 1) {
		
			cell.text = NSLocalizedString(@"Upload path", @"Upload path");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[cell.contentView addSubview: uploadPath];
			
		}
		
	} else if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Contact Developer";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

	return cell;

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if (indexPath.section == 1) {
		if (indexPath.row == 4) {
            
            [self.navigationController pushViewController:sortCriteria animated:YES];
            
		} else if (indexPath.row == 5) {
            
			[self.navigationController pushViewController:sortOrder animated:YES];
			
		} else if (indexPath.row == 7) {
            
            [self.navigationController pushViewController:themeSelect animated:YES];
            
        } else if (indexPath.row == 8) {
            
			[aboutController presentFrom: self];
			
		}
	} else if (indexPath.section == 2) {
	
		if (indexPath.row == 0) {

                        if ([[DBSession sharedSession] isLinked]) {

			        [[DBSession sharedSession] unlink];
			        [[NSUserDefaults standardUserDefaults] synchronize];

                        } else {

                                DBLoginController *lc = [[DBLoginController alloc] init];
                                lc.delegate = self;
                                [lc presentFromController: self];
                                [lc release];

                        }

			[self close];
			
		}

	} else if (indexPath.section == 0) {
		if (indexPath.row == 0) {
            
            mailController = [[MFMailComposeViewController alloc] init];
            [mailController setToRecipients:[NSArray arrayWithObject:@"itay@itaysoft.com"]];
            [mailController setSubject: @"iFinder Support"];
            [mailController setMessageBody:[NSString stringWithFormat:@"<br /><br /><br />Please do not remove below information<br /><table><tr><td style='text-align:center'><b>iFinder Version</b>:</td><td>%@</td></tr><tr><td style='text-align:center'><b>Model</b>:</td><td>%@</td></tr><tr><td style='text-align:center'><b>iOS:<b/></td><td>%@</td></tr><tr><td style='text-align:center'><b>UDID</b>:</td><td>%@</td></tr></table>", @"1.3[B]", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] uniqueIdentifier]] isHTML: YES];
            mailController.mailComposeDelegate = self;
            [self presentModalViewController: mailController animated: YES];
            [mailController release];
            
		}
    } 

}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];
	
	return YES;
	
}

// DBLoginControllerDelegate

- (void) loginControllerDidLogin: (DBLoginController *) controller {

        [tableView reloadData];

}

- (void) loginControllerDidCancel: (DBLoginController *) controller {

}

- (void) mailComposeController: (MFMailComposeViewController *) controller didFinishWithResult: (MFMailComposeResult) result error: (NSError *) error {
    
	[self dismissModalViewControllerAnimated: YES];
	
}

@end

