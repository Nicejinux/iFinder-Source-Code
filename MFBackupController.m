//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import "MFBackupController.h"


@implementation MFBackupController

@synthesize fileManager = fileManager;
- (void) viewDidLoad{
    restore = [[UIActionSheet alloc] init];
    restore.title = NSLocalizedString(@"Are you sure you want to restore this backup?\nThis can't be undone.", @"Are you sure you want to restore this backup?\nThis can't be undone.");
    restore.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    restore.delegate = self;
    restore.destructiveButtonIndex = 0;
    restore.cancelButtonIndex = 1;
    [restore addButtonWithTitle: NSLocalizedString(@"Restore", @"Restore")];
    [restore addButtonWithTitle: NSLocalizedString(@"Cancel", @"Cancel")];
    
    share = [[UIActionSheet alloc] init];
    share.title = NSLocalizedString(@"Backup File", @"Backup File");
    share.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    share.delegate = self;
    share.cancelButtonIndex = 2;
    [share addButtonWithTitle: NSLocalizedString(@"Restore", @"Restore")];
    [share addButtonWithTitle: NSLocalizedString(@"Share", @"Share")];
    [share addButtonWithTitle: NSLocalizedString(@"Cancel", @"Cancel")];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewDidLoad];

    self.fileManager = [[MFFileManager alloc] init];
	currentDirectory = @"/private/var/mobile/Library/Preferences/iFinderBackup";

    files = [[NSMutableArray alloc] init];
	[files addObjectsFromArray: [self.fileManager contentsOfDirectory: currentDirectory]];
	self.title = NSLocalizedString(@"Available Backups", @"Available Backups");
	self.view.backgroundColor = [UIColor whiteColor];
	
	fileIndex = -1;
	
	searchResult = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"Edit") style:UIBarButtonItemStylePlain target: self action: @selector(edit)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
	
	searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake (0, 0, 320, 48)];
	searchBar.tintColor = [UIColor colorWithRed: 0.65 green: 0.7 blue: 0.75 alpha: 1.0];
	searchBar.placeholder = NSLocalizedString(@"Search Backup", @"Search Backup");
	searchBar.showsCancelButton = YES;
	searchBar.delegate = self;
    
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 412)];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.tableHeaderView = searchBar;
	[self.view addSubview: tableView];
	
	toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake (0, 370, 320, 48)];
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
	UIBarButtonItem *toolbarItem_0 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Create Backup", @"Create Backup") style:UIBarButtonItemStyleDone target:self action:@selector(makebackup)];
    UIBarButtonItem *toolbarItem_1 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Share Backups", @"Share Backups") style:UIBarButtonItemStyleBordered target:self action:@selector(sharebackup)];
    NSArray *toolbarItems = [NSArray arrayWithObjects: flexItem, toolbarItem_0, flexItem, nil];
	toolbar.barStyle = UIBarStyleBlack;
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [toolbar setItems: toolbarItems animated: YES];
	[self.view addSubview: toolbar];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {
    
	return YES;
    
}

- (void) dealloc {
    
	[fileManager release];
	fileManager = nil;
	[files release];
	files = nil;
	currentDirectory = nil;
	[searchResult release];
	searchResult = nil;
	[toolbar release];
	toolbar = nil;
	
	[super dealloc];
    
}

// self
- (void)edit{
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStyleDone target:self action:@selector(cancel)] autorelease];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    [tableView setEditing:YES animated:YES];
    //[tableView setAllowsSelectionDuringEditing:YES];
    [tableView setAllowsSelectionDuringEditing:NO];
}

- (void)cancel{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"Edit") style:UIBarButtonItemStylePlain target: self action: @selector(edit)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
	[tableView setEditing:NO animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
	[super layoutSubviews];
    
	if (((UITableView *)tableView.superview).isEditing)
	{
		CGRect contentFrame = tableView.frame;
		contentFrame.origin.x = 50;
		tableView.frame = contentFrame;
	}
	else
	{
		CGRect contentFrame = tableView.frame;
		contentFrame.origin.x = 0;
		tableView.frame = contentFrame;
	}
    
	[UIView commitAnimations];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
            
    return UITableViewCellEditingStyleDelete;

    //return 3;
}

- (NSString *) currentDirectory {
    
	return currentDirectory;
	
}

- (void) loadDirectory: (NSString *) path {
    
	currentDirectory = path;
	[files removeAllObjects];
	[files addObjectsFromArray: [self.fileManager contentsOfDirectory: path]];
	[tableView reloadData];
    
}

- (void) reloadDirectory {
    
	[self loadDirectory: currentDirectory];
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
	return [files count];
    
}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {
    
	return currentDirectory;
    
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MFMainControllerCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: 3 reuseIdentifier: @"MFMainControllerCell"];
	}
	
	cell.textLabel.text = [[files objectAtIndex: indexPath.row] name];
	return cell;
    
}

// UITableViewDelegate
- (void) tableView: (UITableView *) theTableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
	if (tableView.editing) {
    }
}

//RESTORE
- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    restorestring = [NSString stringWithFormat:@"/private/var/mobile/Library/Preferences/iFinderBackup/%@", [[files objectAtIndex:indexPath.row] name]];
    mailme = indexPath.row;
    NSString *a = [NSString stringWithFormat:@"cd /private/var/mobile/Library/Preferences/iFinderBackup/; unzip '%@'; mv /private/var/mobile/Library/Preferences/iFinderBackup/cydia.list /etc/apt/sources.list.d/cydia.list; apt-get update; dpkg --set-selections < /private/var/mobile/Library/Preferences/iFinderBackup/installed-apps; apt-get -y dselect-upgrade; apt-get --fix-missing -y dselect-upgrade; rm /private/var/mobile/Library/Preferences/iFinderBackup/installed-apps;rm /var/mobile/Library/iFinder/restore", restorestring];
    [a writeToFile:@"/var/mobile/Library/iFinder/restore" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    [share showInView: self.view];
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
}
- (void) sharebackup{
}

- (void) makebackup{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMMM YYYY 'at' HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:today];
    [dateFormat release];
    NSString* backup = [NSString stringWithFormat:@"%@", dateString];
    char *cmdbackp = [[NSString stringWithFormat:@"/private/var/mobile/Library/Preferences/iFinderBackup/; dpkg --get-selections > /installed-apps; cp /etc/apt/sources.list.d/cydia.list /cydia.list; cd /; zip -r '/private/var/mobile/Library/Preferences/iFinderBackup/%@.backup' '/cydia.list' '/installed-apps'; rm -rf '/cydia.list' '/installed-apps'", backup] UTF8String];
    system(cmdbackp);
    UIAlertView *backed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Backup Succesfully", @"Backup Succesfully") message:NSLocalizedString(@"Your Backup was successfull.\nPlease Sync with iTunes to restore later", @"Your Backup was successfull.\nPlease Sync with iTunes to restore later") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    [backed show];
    [backed release];
    [self reloadDirectory];
}

- (NSString *) tableView: (UITableView *) theTableView titleForDeleteConfirmationButtonForRowAtIndexPath: (NSIndexPath *) indexPath {
    
	return @"Delete";
	
}

- (void) tableView: (UITableView *) theTableView commitEditingStyle: (UITableViewCellEditingStyle) style forRowAtIndexPath: (NSIndexPath *) indexPath {
        
    fileIndex = indexPath.row;
        char *cmd = [[NSString stringWithFormat: @"rm -rf '%@'", [NSString stringWithFormat:@"%@/%@", currentDirectory, [[files objectAtIndex: indexPath.row] name]]] UTF8String];
        system (cmd);
    [self reloadDirectory];
}

// UISearchBarDelegate
- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText {
	[self reloadDirectory];
	
	for (int i = 0; i < [files count]; i++) {
		NSRange textRange;
		textRange = [[[[files objectAtIndex: i] name] lowercaseString] rangeOfString: [bar.text lowercaseString]];
		if (textRange.location != NSNotFound) {
			[searchResult addObject: [files objectAtIndex: i]];
		}
	}
	
	[files removeAllObjects];
	[files addObjectsFromArray: searchResult];
	[searchResult removeAllObjects];
	[tableView reloadData];
	
    
}
- (void) searchBarSearchButtonClicked: (UISearchBar *) bar {
    
	[bar resignFirstResponder];
	
	[self reloadDirectory];
	
	for (int i = 0; i < [files count]; i++) {
		NSRange textRange;
		textRange = [[[[files objectAtIndex: i] name] lowercaseString] rangeOfString: [bar.text lowercaseString]];
		if (textRange.location != NSNotFound) {
			[searchResult addObject: [files objectAtIndex: i]];
		}
	}
	
	[files removeAllObjects];
	[files addObjectsFromArray: searchResult];
	[searchResult removeAllObjects];
	[tableView reloadData];
	
}

- (void) searchBarCancelButtonClicked: (UISearchBar *) bar {
    
	[bar resignFirstResponder];
	[self reloadDirectory];
    
    
}

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (int) index {
    
	if (actionSheet == restore) {
		if (index == 0) {
            loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeRestoring];
            [loadingView show];
            //char *restoring = [[NSString stringWithFormat:@"cd /private/var/mobile/Library/Preferences/iFinderBackup/; unzip '%@.backup'; mv /private/var/mobile/Library/Preferences/iFinderBackup/cydia.list /etc/apt/sources.list.d/cydia.list; apt-get update; dpkg --set-selections < /private/var/mobile/Library/Preferences/iFinderBackup/installed-apps; apt-get dselect-upgrade; apt-get --fix-missing dselect-upgrade", restorestring] UTF8String];
            // rm /private/var/mobile/Library/Preferences/iFinderBackup/installed-apps
            //system(restoring);
            //restorestring = [NSString stringWithContentsOfFile:@"/b.txt" encoding:NSUTF8StringEncoding error:nil];
            NSString *command = [NSString stringWithContentsOfFile:@"/var/mobile/Library/iFinder/restore" encoding:NSUTF8StringEncoding error:nil];
            restorethread = [[[MFThread alloc] init] autorelease];
            restorethread.cmd = command;
            restorethread.delegate = self;
            [restorethread start];

        } else {
            return;
        }
    } else if (actionSheet == share) {
		if (index == 0) {
            [restore showInView: self.view];
        } else if (index == 1) {
            mailController = [[MFMailComposeViewController alloc] init];
			NSData *attachment = [NSData dataWithContentsOfFile: [[files objectAtIndex:mailme] path]];
			[mailController setSubject: [NSString stringWithFormat: @"%@: %@ (%@)", NSLocalizedString(@"[iFinder] Attachment", @"[iFinder] Attachment"), [[files objectAtIndex:mailme] name], [[files objectAtIndex:mailme] fsize]]];
			[mailController setMessageBody: @"" isHTML: NO];
			[mailController addAttachmentData: attachment mimeType: @"application/octet-stream" fileName: [[files objectAtIndex:mailme] name]];
			mailController.mailComposeDelegate = self;
			[self presentModalViewController: mailController animated: YES];
            [mailController release];


        } else {
            return;
        }
    }
}

- (void) mailComposeController: (MFMailComposeViewController *) controller didFinishWithResult: (MFMailComposeResult) result error: (NSError *) error {
    
	[self dismissModalViewControllerAnimated: YES];
	
}

// MFThreadDelegate

- (void) threadEnded: (MFThread *) thread {
    
	[loadingView hide];
	//if (thread.exitCode != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restore Done", @"Restore Done") message:NSLocalizedString(@"You should reboot your device.\n Do you want to reboot now?", @"You should reboot your device.\n Do you want to reboot now?") delegate:self cancelButtonTitle:NSLocalizedString(@"No, Thanks", @"No, Thanks") otherButtonTitles:NSLocalizedString(@"Yes, Please", @"Yes, Please"), nil];
        alert.tag = 1;
        [alert show];
        [alert release];
	/*} else {
        NSString *errormessage = [NSString stringWithFormat:@"Error: %@", thread.exitCode];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Done" message:errormessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
        [alert release];
    }*/
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 & actionSheet.tag==1)
    {
        system("reboot");
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
