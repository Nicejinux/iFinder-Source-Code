//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFDropboxController.h"
#import "EGORefreshTableHeaderView.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation MFDropboxController

//////Pull To Refresh
@synthesize reloading=_reloading;
@synthesize refreshHeaderView;
@synthesize mainController = mainController;

// super

- (id) init {

	self = [super init];

	self.title = @"/";
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize target: self action: @selector(loadRoot)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
	
	loginController = [[DBLoginController alloc] init];
	loginController.delegate = self;
	files = [[NSMutableArray alloc] init];
	currentDirectory = @"/";
	
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460)];
	tableView.autoresizingMask = self.view.autoresizingMask;
	tableView.delegate = self;
	tableView.dataSource = self;
    
    if (refreshHeaderView == nil) {
        refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableView.bounds.size.height, 320.0f, tableView.bounds.size.height)];
        refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        refreshHeaderView.bottomBorderThickness = 1.0;
        [tableView addSubview:refreshHeaderView];
        tableView.showsVerticalScrollIndicator = YES;
        [refreshHeaderView release];
    }
    [self.refreshHeaderView setLastRefreshDate:nil];
    
	[self.view addSubview: tableView];
	
	return self;
	
}

- (void)refresh {
//    [self performSelector:@selector(loadMetadata:) withObject:nil afterDelay:2.0];
	[self showLoading];
	[[self.mainController fileManager] dbLoadMetadata: currentDirectory];
    [self stopLoading2];
}

- (void) reload3 {
    [tableView reloadData];
}

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews model to reload
	//  put here just for demo
    //    [self recargar];
	[super performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:3.0];
	
}
- (void)dataSourceDidFinishLoadingNewData{
	[refreshHeaderView setCurrentDate];  //  should check if data reload was successful 
	
    _reloading = NO;
	[[self.mainController fileManager] dbLoadMetadata: currentDirectory];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    //	[self recargar];
    [tableView reloadData];
    [UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	if (scrollView.isDragging) {
		if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		[self reloadTableViewDataSource];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

// self

- (void) showLoading {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];

}

- (void) hideLoading {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

}

- (void) loadRoot {

	if ([[DBSession sharedSession] isLinked]) {
	
		[self loadMetadata: [currentDirectory stringByDeletingLastPathComponent]];
		
	} else {
	
		[loginController presentFromController: self];
		
	}
	
}

- (void) loadMetadata: (NSString *) path {

	currentDirectory = [path retain];
	[self showLoading];
	[[self.mainController fileManager] dbLoadMetadata: path];

}

- (void) downloadFile: (NSString *) path {

	loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeProgress];
	[loadingView show];
	[self showLoading];
	[[self.mainController fileManager] dbDownloadFile: path];
	
}

- (void) deleteFile: (NSString *) path {

	[self showLoading];
	[[self.mainController fileManager] dbDeleteFile: path];
	
}

- (void) createDirectory: (NSString *) path {

	[self showLoading];
	[[self.mainController fileManager] dbCreateDirectory: path];
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [files count];
	
}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {

	return currentDirectory;

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFDBCell"];
	if (cell == nil) {
	
		cell = [[UITableViewCell alloc] initWithStyle: 3 reuseIdentifier: @"MFDBCell"];
		
	}
	cell.textLabel.text = [[[files objectAtIndex: indexPath.row] path] lastPathComponent];
	cell.detailTextLabel.text = [[files objectAtIndex: indexPath.row] isDirectory] ? nil : [[files objectAtIndex: indexPath.row] humanReadableSize];
    
    NSString *dirimg;
    seteuid(501);
    if ([[NSUserDefaults standardUserDefaults] integerForKey: @"MFTheme"] == 1){
        dirimg = [NSString stringWithFormat: @"dirMetallen.png"];
    } else {
        dirimg = [NSString stringWithFormat: @"dir.png"];
    }
    seteuid(0);
    UIImage *img = [UIImage imageNamed: dirimg];
    cell.imageView.image = [[files objectAtIndex: indexPath.row] isDirectory] ? img : [MFFileType imageForName: cell.textLabel.text];
	
	return cell;
		
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if ([[files objectAtIndex: indexPath.row] isDirectory]) {

		[self loadMetadata: [[files objectAtIndex: indexPath.row] path]];

	} else {

		[self downloadFile: [[files objectAtIndex: indexPath.row] path]];

	}

}

- (void) tableView: (UITableView *) theTableView commitEditingStyle: (UITableViewCellEditingStyle) style forRowAtIndexPath: (NSIndexPath *) indexPath {

	[self deleteFile: [[files objectAtIndex: indexPath.row] path]];
	[files removeObjectAtIndex: indexPath.row];
	[tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationRight];

}

// DBLoginControllerDelegate

- (void) loginControllerDidLogin: (DBLoginController *) controller {

	[self loadMetadata: @"/"];
	
}

- (void) loginControllerDidCancel: (DBLoginController *) controller {

	[[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Login required", @"Login required") message: NSLocalizedString(@"Please note that you'll need to log in in order to use iFinder with your Dropbox account.", @"Please note that you'll need to log in in order to use iFinder with your Dropbox account.") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];

}

// MFFileManagerDelegate

- (void) fileManagerDBLoadedMetadata: (DBMetadata *) metadata {

	[files removeAllObjects];
	[self hideLoading];
	self.title = [metadata.path lastPathComponent];
	for (DBMetadata *item in metadata.contents) {

		[files addObject: [item retain]];

	}

	[tableView reloadData];

}

- (void) fileManagerDBLoadMetadataFailed {

	[self hideLoading];
	[[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error loading metadata", @"Error loading metadata") message: NSLocalizedString(@"Please make sure that you are connected to the Internet and try again.", @"Please make sure that you are connected to the Internet and try again.") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];

}

- (void) fileManagerDBDownloadedFile: (NSString *) path {

	[self hideLoading];
	[loadingView hide];
    [[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"File Downloaded", @"File Downloaded") message: NSLocalizedString(@"Your file was saved in /private/var/mobile/Documents", @"Your file was saved in /private/var/mobile/Documents") delegate: nil cancelButtonTitle: NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil] autorelease] show];
}

- (void) fileManagerDBDownloadProgress: (float) progress forFile: (NSString *) path {

	[loadingView setProgress: progress];

}

- (void) fileManagerDBDownloadFileFailed {

	[self hideLoading];
	[loadingView hide];
	[[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error downloading file", @"Error downloading file") message: NSLocalizedString(@"Please make sure that you are connected to the Internet, logged in and you have enough space on your device and try again.", @"Please make sure that you are connected to the Internet, logged in and you have enough space on your device and try again.") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];

}

- (void) fileManagerDBUploadedFile: (NSString *) path {

	[self hideLoading];
	[loadingView hide];

}

- (void) fileManagerDBUploadProgress: (float) progress forFile: (NSString *) path {

	[loadingView setProgress: progress];

}

- (void) fileManagerDBUploadFileFailed {

	[self hideLoading];
	[loadingView hide];
	[[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error uploading file", @"Error uploading file") message: NSLocalizedString(@"Please make sure that you are connected to the Internet, logged in and the file to be uploaded doesn't exist yet and try again.", @"Please make sure that you are connected to the Internet, logged in and the file to be uploaded doesn't exist yet and try again.") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];

}

- (void) fileManagerDBDeletedFile: (NSString *) path {

	[self hideLoading];

}

- (void) fileManagerDBDeleteFileFailed {

	[self hideLoading];
	[[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error deleting file", @"Error deleting file") message: NSLocalizedString(@"Please make sure that you are connected to the Internet, logged in and the file to be deleted exists and try again.", @"Please make sure that you are connected to the Internet, logged in and the file to be deleted exists and try again.") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];

}

- (void) fileManagerDBCreatedDirectory: (NSString *) path {

	[self hideLoading];

}

- (void) fileManagerDBCreateDirectoryFailed {

	[self hideLoading];
	[[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error creating folder", @"Error creating folder") message: NSLocalizedString(@"Please make sure that you are connected to the Internet, logged in and the folder to be created doesn't yet exist and try again.", @"Please make sure that you are connected to the Internet, logged in and the folder to be created doesn't yet exist and try again.") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];

}

@end

