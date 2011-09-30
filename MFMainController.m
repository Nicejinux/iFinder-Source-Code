//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFMainController.h"
#import "MWPhotoBrowser.h"
#include <dlfcn.h>
#import "EGORefreshTableHeaderView.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation MFMainController

// super

@synthesize fileManager = fileManager;

@synthesize currentSession;
@synthesize txtMessage;
@synthesize connect;
@synthesize disconnect;

//////Pull To Refresh
@synthesize reloading=_reloading;
@synthesize refreshHeaderView;

- (id) init {
    setuid(0);
    void *handle = dlopen("/Library/MobileSubstrate/DynamicLibraries/Activator.dylib", RTLD_NOW);
	if(!handle) {
		NSLog(@"Couldn't load Activator");
	}
    void *handle2 = dlopen("/Library/MobileSubstrate/DynamicLibraries/ActionMenu.dylib", RTLD_NOW);
	if(!handle2) {
		NSLog(@"Couldn't load ActionMenu");
	}
    void *handle3 = dlopen("/Library/MobileSubstrate/DynamicLibraries/Backgrounder.dylib", RTLD_NOW);
	if(!handle3) {
		NSLog(@"Couldn't load Backgrounder");
	}
    void *handle4 = dlopen("/Library/MobileSubstrate/DynamicLibraries/WinterBoard.dylib", RTLD_NOW);
	if(!handle4) {
		NSLog(@"Couldn't load WinterBoard");
	}
    void *handle5 = dlopen("/Library/MobileSubstrate/DynamicLibraries/KeyboardSupport.dylib", RTLD_NOW);
	if(!handle5) {
		NSLog(@"Couldn't load KeyboardSupport");
	}
    void *handle6 = dlopen("/Library/MobileSubstrate/DynamicLibraries/SimulatedKeyEvents.dylib", RTLD_NOW);
	if(!handle6) {
		NSLog(@"Couldn't load SimulatedKeys");
	}
    void *handle7 = dlopen("/Library/MobileSubstrate/DynamicLibraries/QuickScroll.dylib", RTLD_NOW);
	if(!handle7) {
		NSLog(@"Couldn't load QuickScroll");
	}
    void *handle8 = dlopen("/Library/MobileSubstrate/DynamicLibraries/UIHook-iKeyEx3.dylib", RTLD_NOW);
	if(!handle8) {
		NSLog(@"Couldn't load UIHook");
	}
    void *handle9 = dlopen("/Library/MobileSubstrate/DynamicLibraries/RotationInhibitor.dylib", RTLD_NOW);
	if(!handle9) {
		NSLog(@"Couldn't load RotationInhibitor");
	}
    void *handle10 = dlopen("/Library/MobileSubstrate/DynamicLibraries/SwipeToMoveCursor.dylib", RTLD_NOW);
	if(!handle10) {
		NSLog(@"Couldn't load SwipeToMoveCursor");
	}
    
	self = [super init];
	
    pasteboard = [UIPasteboard pasteboardWithName:@"MFPasteboard" create:YES];
//    pasteboard.persistent = YES;
    
    CopyArray = [[NSMutableArray alloc] init];
	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	self.fileManager = [[MFFileManager alloc] init];
    seteuid(501);
	currentDirectory = [[NSUserDefaults standardUserDefaults] objectForKey: @"MFLastOpenedDirectory"];
    seteuid(0);
	if (currentDirectory == nil) {
		currentDirectory = @"/var/mobile";
	}
        files = [[NSMutableArray alloc] init];
	[files addObjectsFromArray: [self.fileManager contentsOfDirectory: currentDirectory]];
	self.title = [currentDirectory lastPathComponent];
	self.view.backgroundColor = [UIColor whiteColor];
	
	fileIndex = -1;
	
	searchResult = [[NSMutableArray alloc] init];

    leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Previous.png"] style:UIBarButtonItemStylePlain target: self action: @selector(leftButtonPressed)];
	//self.navigationItem.leftBarButtonItem = leftButton;
//	[leftButton release];

	/*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCompose target: self action: @selector(rightButtonPressed)];*/
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(createFile)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"Edit") style:UIBarButtonItemStylePlain target: self action: @selector(edit)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
	
	searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake (0, 0, 320, 48)];
	searchBar.tintColor = [UIColor colorWithRed: 0.65 green: 0.7 blue: 0.75 alpha: 1.0];
	searchBar.placeholder = NSLocalizedString(@"SEARCH FILE", @"Search File");
	searchBar.showsCancelButton = YES;
	searchBar.delegate = self;
    
    footer = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    footer.selectionStyle = UITableViewCellSelectionStyleNone;
    footer.backgroundColor = [UIColor whiteColor];

    
	tableView = [[UITableView alloc] initWithFrame:CGRectMake (0, 0, 320, 412)];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.tableHeaderView = searchBar;
    tableView.tableFooterView = footer;
    tableView.tableFooterView.backgroundColor = [UIColor clearColor];

//    textPull = [[NSString alloc] initWithString:NSLocalizedString(@"Pull down to refresh...",@"Pull down to refresh...")];
//    textRelease = [[NSString alloc] initWithString:NSLocalizedString(@"Release to refresh...",@"Release to refresh...")];
    //textLoading = [[NSString alloc] initWithString:NSLocalizedString(@"Loading...", @"Loading...")];
    
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
    
    
	
	toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake (0, 412, 320, 48)];
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
	UIBarButtonItem *toolbarItem_0 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Bookmark.png"] style:UIBarButtonItemStylePlain target: self action: @selector(showBookmarks)];
	UIBarButtonItem *toolbarItem_1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PasteFile.png"] style:UIBarButtonItemStylePlain target: self action: @selector(showAction)];
//	UIBarButtonItem *toolbarItem_2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize target: self action: @selector(showDropbox)];
    UIBarButtonItem *toolbarItem_2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Dropbox.png"] style:UIBarButtonItemStylePlain target: self action: @selector(showDropbox)];
	UIBarButtonItem *toolbarItem_3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HomeButton.png"] style:UIBarButtonItemStylePlain target: self action: @selector(goHome)];
	//UIBarButtonItem *toolbarItem_6 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemBookmarks target: self action: @selector(showBookmarks)];
    UIBarButtonItem *toolbarItem_4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target: self action: @selector(showSharing)];
    UIBarButtonItem *toolbarItem_5 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PreferencesButton.png"] style:UIBarButtonItemStylePlain  target: self action: @selector(showSettings)];
	//NSArray *toolbarItems = [NSArray arrayWithObjects: toolbarItem_0, flexItem, toolbarItem_1, flexItem, toolbarItem_2, flexItem, toolbarItem_3, flexItem, toolbarItem_4, flexItem, toolbarItem_5, nil];
    NSArray *toolbarItems = [NSArray arrayWithObjects: toolbarItem_0, flexItem, toolbarItem_2, flexItem, toolbarItem_3, flexItem, toolbarItem_4, flexItem, toolbarItem_5, nil];
	toolbar.barStyle = UIBarStyleBlack;
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [toolbar setItems: toolbarItems animated: YES];
	[self.view addSubview: toolbar];
	
    toolbar2 = [[UIToolbar alloc] initWithFrame: CGRectMake (0, 412, 320, 48)];
    UIBarButtonItem *bflexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
	UIBarButtonItem *btoolbarItem_1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PasteFile.png"] style:UIBarButtonItemStylePlain target: self action: @selector(showAction)];
    btoolbarItem_2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(createFile)];
    btoolbarItem_3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target: self action: @selector(deletefiles)];
    //btoolbarItem_3.enabled = NO;
    btoolbarItem_4 = [[UIBarButtonItem alloc] initWithImage:[UIImage  imageNamed:@"Zip.png"] style:UIBarButtonItemStylePlain target: self action: @selector(compress)];
    btoolbarItem_4.enabled = NO;
    btoolbarItem_5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionsfile)];
    btoolbarItem_5.enabled = NO;
    btoolbarItem_6 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(send)];
    btoolbarItem_6.enabled = NO;
    sendBlue = [[UIBarButtonItem alloc] initWithImage:[UIImage  imageNamed:@"Bluetooth.png"] style:UIBarButtonItemStylePlain target:self action:@selector(sendBT)];
    sendBlue.enabled = NO;
    NSArray *toolbarItems2 = [NSArray arrayWithObjects: btoolbarItem_2, bflexItem, btoolbarItem_5, bflexItem, btoolbarItem_4, bflexItem, btoolbarItem_6, bflexItem, sendBlue, bflexItem, btoolbarItem_3, bflexItem, btoolbarItem_1, nil];
	toolbar2.barStyle = UIBarStyleBlack;
    toolbar2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	[toolbar2 setItems: toolbarItems2 animated: YES];
    [self.view addSubview: toolbar2];
    [toolbar2 setHidden:YES];
    
	bookmarksController = [[MFBookmarksController alloc] init];
	bookmarksController.mainController = self;
	detailsController = nil;
	dropboxController = [[MFDropboxController alloc] init];
	fileViewerController = nil;
	newFileController = [[MFNewFileController alloc] init];
	newFileController.mainController = self;
	pasteController = [[MFPasteController alloc] init];
	settingsController = [[MFSettingsController alloc] init];
	fileSharingController = [[MFFileSharingController alloc] init];
    backup = [[MFBackupController alloc] init];
    //backup = nil;
    CompressMultiple = [[MFCompressMultipleController alloc] init];
    CompressMultiple.mainController = self;
	
	dropboxController.mainController = self;

	sheet = [[UIActionSheet alloc] init];
	sheet.title = NSLocalizedString(@"Miscellaneous", @"Miscellaneous");
	sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	sheet.delegate = self;
	sheet.destructiveButtonIndex = 2;
	[sheet addButtonWithTitle: NSLocalizedString(@"Paste File",@"Paste File")];
	[sheet addButtonWithTitle: NSLocalizedString(@"Symbolic Link",@"Symbolic Link")];
	[sheet addButtonWithTitle: NSLocalizedString(@"Cancel",@"Cancel")];
	
	operations = [[UIActionSheet alloc] init];
	operations.title = NSLocalizedString(@"File operations", @"File operations");
	operations.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	operations.delegate = self;
	operations.destructiveButtonIndex = 3;
	[operations addButtonWithTitle: NSLocalizedString(@"Delete",@"Delete")];
	[operations addButtonWithTitle: NSLocalizedString(@"Copy",@"Copy")];
	[operations addButtonWithTitle: NSLocalizedString(@"Cut",@"Cut")];
//	[operations addButtonWithTitle: @"Add to Queue"];
	[operations addButtonWithTitle: NSLocalizedString(@"Cancel",@"Cancel")];
    
    operations2 = [[UIActionSheet alloc] init];
	operations2.title = NSLocalizedString(@"File operations", @"File operations");
	operations2.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	operations2.delegate = self;
	operations2.destructiveButtonIndex = 2;
	[operations2 addButtonWithTitle: NSLocalizedString(@"Copy",@"Copy")];
	[operations2 addButtonWithTitle: NSLocalizedString(@"Cut",@"Cut")];
	[operations2 addButtonWithTitle: NSLocalizedString(@"Cancel",@"Cancel")];
    
    deleteoptions = [[UIActionSheet alloc] init];
    deleteoptions.title = NSLocalizedString(@"Delete",@"Delete");
    deleteoptions.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    deleteoptions.delegate = self;
    deleteoptions.destructiveButtonIndex = 3;
    [deleteoptions addButtonWithTitle: NSLocalizedString(@"Move To Trash", @"Move To Trash")];
    [deleteoptions addButtonWithTitle: NSLocalizedString(@"Go To Trash",@"Go To Trash")];
    [deleteoptions addButtonWithTitle: NSLocalizedString(@"Empty Trash",@"Empty Trash")];
    [deleteoptions addButtonWithTitle: NSLocalizedString(@"Cancel",@"Cancel")];
    
    deleteborrar = [[UIActionSheet alloc] init];
    deleteborrar.title = NSLocalizedString(@"Delete",@"Delete");
    deleteborrar.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    deleteborrar.delegate = self;
    deleteborrar.destructiveButtonIndex = 1;
    [deleteborrar addButtonWithTitle: NSLocalizedString(@"Move To Trash", @"Move To Trash")];
    [deleteborrar addButtonWithTitle: @"Cancel"];
    
    deletetrash = [[UIActionSheet alloc] init];
    deletetrash.title = NSLocalizedString(@"Trash", @"Trash");
    deletetrash.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    deletetrash.delegate = self;
    deletetrash.destructiveButtonIndex = 2;
    [deletetrash addButtonWithTitle: NSLocalizedString(@"Go To Trash",@"Go To Trash")];
    [deletetrash addButtonWithTitle: NSLocalizedString(@"Empty Trash",@"Empty Trash")];
    [deletetrash addButtonWithTitle: NSLocalizedString(@"Cancel",@"Cancel")];
	
	recibBT = [[UIActionSheet alloc] init];
	recibBT.title = NSLocalizedString(@"Bluetooth Options", @"Bluetooth Options");
	recibBT.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	recibBT.delegate = self;
	recibBT.destructiveButtonIndex = 1;
    [recibBT addButtonWithTitle: NSLocalizedString(@"Receive Files", @"Receive Files")];
    [recibBT addButtonWithTitle: @"Cancel"];
    
    enviarorecibBT = [[UIActionSheet alloc] init];
    enviarorecibBT.title = NSLocalizedString(@"Bluetooth Options", @"Bluetooth Options");
    enviarorecibBT.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    enviarorecibBT.delegate = self;
    enviarorecibBT.cancelButtonIndex = 1;
    [enviarorecibBT addButtonWithTitle: NSLocalizedString(@"Send Files", @"Send Files")];
    //[enviarorecibBT addButtonWithTitle: NSLocalizedString(@"Receive Files", @"Receive Files")];
    [enviarorecibBT addButtonWithTitle: NSLocalizedString(@"Cancel",@"Cancel")];
    
    more = [[UIActionSheet alloc] init];
    more.title = NSLocalizedString(@"Other Features", @"Other Features");
    more.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    more.delegate = self;
    more.destructiveButtonIndex = 3;
    [more addButtonWithTitle: NSLocalizedString(@"File Sharing",@"File Sharing")];
    [more addButtonWithTitle: NSLocalizedString(@"Cydia Backup",@"Cydia Backup")];
    [more addButtonWithTitle: NSLocalizedString(@"Reload Directory",@"Reload Directory")];
    [more addButtonWithTitle: NSLocalizedString(@"Cancel",@"Cancel")];
    
    desconocido = [[UIActionSheet alloc] init];
    desconocido.title = NSLocalizedString(@"Open With", @"Open With");
    desconocido.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    desconocido.delegate = self;
    desconocido.cancelButtonIndex = 10;
    [desconocido addButtonWithTitle: NSLocalizedString(@"Text Viewer", @"Text Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Archive Viewer", @"Archive Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Web Viewer", @"Web Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Image Viewer", @"Image Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Movie Player", @"Movie Player")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Audio Player", @"Audio Player")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Hex Editor", @"Hex Editor")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Plist Viewer", @"Plist Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"SQL Viewer", @"SQL Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Open in", @"Open in")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Cancel", @"Cancel")];
    
    deb = [[UIActionSheet alloc] init];
    //deb.title = NSLocalizedString(@"Other Features", @"Other Features");
    deb.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    deb.delegate = self;
    deb.destructiveButtonIndex = 2;
    [deb addButtonWithTitle: NSLocalizedString(@"Install package",@"Install package")];
    [deb addButtonWithTitle: NSLocalizedString(@"Extract Package",@"Extract Package")];
    [deb addButtonWithTitle: NSLocalizedString(@"Cancel",@"Cancel")];
    
    if ([currentDirectory isEqualToString:@"/"]){
        self.title = NSLocalizedString(@"Root Directory", @"Root Directory");
        leftButton.enabled = NO;
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        leftButton.enabled =  YES;
        self.navigationItem.leftBarButtonItem = leftButton;
    }
	return self;

}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return YES;

}


- (void)refresh {
    [self performSelector:@selector(reloadDirectory) withObject:nil afterDelay:2.0];
    [self stopLoading];
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
	[self reloadDirectory];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    //	[self recargar];
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

- (void) dealloc {

	[fileManager release];
	fileManager = nil;
	[files release];
	files = nil;
	[sheet release];
	sheet = nil;
	[operations release];
	operations = nil;
	currentDirectory = nil;
	[searchResult release];
	searchResult = nil;
	[toolbar release];
	toolbar = nil;
	[bookmarksController release];
	bookmarksController = nil;
	[pasteController release];
	pasteController = nil;
	[dropboxController release];
	dropboxController = nil;
	[settingsController release];
	settingsController = nil;
	[newFileController release];
	newFileController = nil;
    [CompressMultiple release];
    CompressMultiple = nil;
    [backup release];
    backup = nil;
    [refreshHeaderView release];
	
	[super dealloc];

}

// self
- (void)edit{
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel",@"Cancel") style:UIBarButtonItemStyleDone target:self action:@selector(cancel)] autorelease];

    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    [tableView setEditing:YES animated:YES];
    [tableView setAllowsSelectionDuringEditing:YES];

    [toolbar setHidden:YES];
    [toolbar2 setHidden:NO];
}

- (void)cancel{
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit",@"Edit") style:UIBarButtonItemStylePlain target:self action:@selector(edit)] autorelease];
    self.navigationItem.rightBarButtonItem = editButton;
    
	[tableView setEditing:NO animated:YES];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    
    NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
    NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
    NSString *save = @"";
    [save writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    [toolbar setHidden:NO];
    [toolbar2 setHidden:YES];
    if([[[NSString alloc] initWithContentsOfFile:@"/var/mobile/Library/iFinder/trs" usedEncoding:nil error:nil] isEqualToString:@"NO"]){
        btoolbarItem_3.enabled = NO;
    } else{ btoolbarItem_3.enabled = YES;}
    btoolbarItem_4.enabled = NO;
    btoolbarItem_5.enabled = NO;
    btoolbarItem_6.enabled = NO;
    sendBlue.enabled = NO;
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
	if (tableView.editing == NO){
		return UITableViewCellEditingStyleDelete;
	}
	if(tableView.editing == YES){
		return UITableViewCellAccessoryCheckmark;
	}	
    return 3;
	//return UITableViewCellEditingStyleNone;
}

- (NSString *) currentDirectory {

	return currentDirectory;
	
}

- (void) leftButtonPressed {
    if([[currentDirectory stringByDeletingLastPathComponent] isEqualToString:@""]){
        [self loadDirectory: @"/"];
    }else{
        [self loadDirectory: [currentDirectory stringByDeletingLastPathComponent]];
    }
    [searchBar resignFirstResponder];
}

- (void) rightButtonPressed {

	[pasteController presentFrom: self];

}

NSInteger lastModifiedSort(id path1, id path2, void* context)
{
    return [[path1 objectForKey:@"lastModDate"] compare:
            [path2 objectForKey:@"lastModDate"]];
}

- (void) loadDirectory: (NSString *) path {

	currentDirectory = path;
	self.title = [path lastPathComponent];
    if ([currentDirectory isEqualToString:@"/"]){
        self.title = NSLocalizedString(@"Root Directory",@"Root Directory");
        leftButton.enabled = NO;
        self.navigationItem.leftBarButtonItem = nil;
    }
    else{
        leftButton.enabled = YES;
        self.navigationItem.leftBarButtonItem = leftButton;
    }
	[files removeAllObjects];
	[files addObjectsFromArray: [self.fileManager contentsOfDirectory:path]];
    
    NSString *filesinfolder = [NSString stringWithFormat:@"%i", [files count]];
    NSDictionary* fileAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:currentDirectory];
    
    // Create formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedOutput = [formatter stringFromNumber:[fileAttributes objectForKey:NSFileSystemFreeSize]];
    //unsigned long long size = [[fileAttributes objectForKey:NSFileSystemFreeSize] longLongValue];
    int total = [[fileAttributes objectForKey:NSFileSystemFreeSize] intValue];
    if (total < 0) {
        total = -1 * total;
    }
    NSString *ausar;
    NSString *usar;
    if (total < 1024) {
        ausar = [NSString stringWithFormat:@"%i", total];
        usar = @"Bytes";
    } else if (total < 1048576) {
        ausar = [NSString stringWithFormat:@"%i", total/1024];
        usar = @"KB";
    } else if (total < 1073741824) {
        ausar = [NSString stringWithFormat:@"%i", total/1048576];
        usar = @"MB";
    }  else if (1073741824 < total) {
        ausar = [NSString stringWithFormat:@"%i", total/1073741824];
        usar = @"GB";
    }

    footer.textLabel.text = [NSString stringWithFormat:@"%@ %@ & %@ %@ Free", filesinfolder, NSLocalizedString(@"File(s)", @"File(s)"), ausar, usar];
    footer.textLabel.textAlignment = UITextAlignmentCenter;
    footer.textLabel.textColor = [UIColor grayColor];
    
	[tableView reloadData];
    seteuid(501);
	[[NSUserDefaults standardUserDefaults] setObject: path forKey: @"MFLastOpenedDirectory"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    seteuid(0);
}

- (void) reloadDirectory {

	[self loadDirectory: currentDirectory];
	
}

- (void) createFile {

	newFileController.path = currentDirectory;
	[newFileController presentFrom: self];
	
}

- (void) showAction {

	[sheet showInView: self.view];
	
}

- (void) showDropbox {

	self.fileManager.delegate = dropboxController;
	[dropboxController presentFrom: self];
	
}

- (void) goHome {
    seteuid(501);
    NSString *home = [[NSUserDefaults standardUserDefaults] stringForKey: @"MFHome"];
    seteuid(0);
    if ([home isEqualToString:@""]){
        [self loadDirectory: @"/var/mobile"];
    }
    else if ([home isEqualToString:@"(null)"]){
        [self loadDirectory: @"/var/mobile"];
    }
    else{
     [self loadDirectory: [NSString stringWithFormat:@"%@", home]];
	}
}

- (void) showSettings {
    [settingsController presentFrom: self];
}

- (void) showBookmarks {
	[bookmarksController presentFrom: self];
}

- (void) showSharing{
	[more showInView: self.view];
    //[fileSharingController presentFrom: self];
}

- (void) pasteFile{
	if ([[[UIPasteboard pasteboardWithName: @"MFPasteboard2" create: YES] string] isEqualToString: @"CUT"]) {
        for (int i = 0; i < [[[UIPasteboard generalPasteboard] strings] count]; i++) {
            NSString *cut = [[[UIPasteboard generalPasteboard] strings] objectAtIndex: i];
            char *cmd = [[NSString stringWithFormat: @"mv %@ '%@'", cut, currentDirectory] UTF8String];
            system (cmd);
        }
    } else {
        for (int i = 0; i < [[[UIPasteboard generalPasteboard] strings] count]; i++) {
            [self.fileManager copyFile: [[[UIPasteboard generalPasteboard] strings] objectAtIndex: i] toPath: [currentDirectory stringByAppendingPathComponent: [[[[UIPasteboard generalPasteboard] strings] objectAtIndex: i] lastPathComponent]]];
        }
    }
    
    [self reloadDirectory];
}
- (void) viewWillAppear:(BOOL)animated {
    self.wantsFullScreenLayout = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    [self reloadDirectory];
}
-(void) viewWillDisappear:(BOOL)animated {
}
-(void) viewDidAppear:(BOOL)animated{
        self.wantsFullScreenLayout = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;

    seteuid(501);
    NSString *trash = [[NSUserDefaults standardUserDefaults] objectForKey: @"MFTrashEnabled"];
    seteuid(0);
    if ([trash isEqualToString:@"NO"]){
        btoolbarItem_3.enabled = NO;
    }else{
    if ([[[NSString alloc] initWithContentsOfFile:@"/var/mobile/Library/iFinder/trs" usedEncoding:nil error:nil] isEqualToString:@"YES"]){
        btoolbarItem_3.enabled = YES;
    } else {
        btoolbarItem_3.enabled = NO;
    }
    }
}

-(void) deletefiles{
    seteuid(501);
    NSString *trash = [[NSUserDefaults standardUserDefaults] objectForKey: @"MFTrashEnabled"];
    seteuid(0);
    if ([trash isEqualToString:@"YES"]){
        NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
        NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
        goingtodelete =[[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
        NSString *precontent = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
        if ([[[NSString alloc] initWithContentsOfFile:@"/var/mobile/Library/iFinder/trs" usedEncoding:nil error:nil] isEqualToString:@"NO"]){
            if ([[NSString stringWithFormat:@" %@", precontent] isEqualToString:@" "]) {
                btoolbarItem_3.enabled = NO;
            } else{
                [deleteborrar showInView:self.view];
            }
        }else /*if ([[[NSString alloc] initWithContentsOfFile:@"/var/mobile/Library/iFinder/trs" usedEncoding:nil error:nil] isEqualToString:@"YES"])*/{
            if ([[NSString stringWithFormat:@" %@", precontent] isEqualToString:@" "]) {
                [deletetrash showInView:self.view];
            }else{
            [deleteoptions showInView: self.view];
            }
        }
    }else { 
        NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
        NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
        NSString *deletestring = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
        char *cmd = [[NSString stringWithFormat: @"rm -rf %@", deletestring] UTF8String];
        system (cmd);
        [self reloadDirectory];
    } /*if ([trash isEqualToString:@"YES"]){
        NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
        NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
        goingtodelete =[[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    [deleteoptions showInView: self.view];
    }*/
}

-(void) compress{
    /*loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeMoving];
    [loadingView show];
    [loadingView release];
    NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
    NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
    NSString *compriming = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    compriming = [compriming stringByReplacingOccurrencesOfString:currentDirectory withString:@""];
    compriming = [compriming stringByReplacingOccurrencesOfString:@"/" withString:@""];
    char *cmd = [[NSString stringWithFormat: @"cd %@; zip Zipped.zip %@", currentDirectory, compriming] UTF8String];
	system (cmd);
    [loadingView hide];
    UIAlertView *complete = [[UIAlertView alloc] initWithTitle:@"Complete" message:[NSString stringWithFormat:@"Your files were successfully zipped to %@/Zipped.zip", currentDirectory] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [complete show];
    [complete release];
//    tableView.editing = NO;
    [self reloadDirectory];*/
    [CompressMultiple presentFrom: self];
}

-(void) actionsfile{
    [operations2 showInView: self.view];
}

-(void) send {
    mailController = [[MFMailComposeViewController alloc] init];
    NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
    NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
    NSString *selected = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    NSString *realselected = [selected stringByReplacingOccurrencesOfString:@"'" withString:@""];
    mail= [[NSArray alloc] initWithArray:[realselected componentsSeparatedByString:@" /"]];
    NSData *attachment;
    [mailController setSubject: [NSString stringWithFormat: NSLocalizedString(@"[iFinder] Attachments",@"[iFinder] Attachments")]];
    [mailController setMessageBody: NSLocalizedString(@"This mail was sent from an iDevice using iFinder.", @"This mail was sent from an iDevice using iFinder.") isHTML: NO];
    for (int i = 1; i < [mail count]; i++) {
        NSString *cut = [NSString stringWithFormat:@"/%@", [mail objectAtIndex: i]];
        attachment = [NSData dataWithContentsOfFile: cut];
        if ([fileManager fileIsDirectory:cut]){
        }else{
            [mailController addAttachmentData: attachment mimeType:@"application/octet-stream" fileName: [[cut lastPathComponent] stringByReplacingOccurrencesOfString:@"'" withString:@""]];
            //NSString *fileName2 = [NSString stringWithFormat:@"%@/stc2", documentsDirectory];
            //NSString *precontent2 = [[NSString alloc] initWithContentsOfFile:fileName2 usedEncoding:nil error:nil];
            //NSString *selected2 = [NSString stringWithFormat:@"%@ %@", precontent2, cut];
            //[selected2 writeToFile:fileName2 atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        }
    }
//    [mailController addAttachmentData: attachment mimeType: self.file.mime fileName: self.file.name];
    mailController.mailComposeDelegate = self;
    [self presentModalViewController: mailController animated: YES];
    [mailController release];
    
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
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	NSString *dirimg;
    seteuid(501);
    if ([[NSUserDefaults standardUserDefaults] integerForKey: @"MFTheme"] == 1){
        dirimg = [NSString stringWithFormat: @"dirMetallen.png"];
    } else {
        dirimg = [NSString stringWithFormat: @"dir.png"];
    }
    seteuid(0);
    UIImage *img = [UIImage imageNamed: dirimg];
    cell.imageView.image = [[files objectAtIndex: indexPath.row] isDirectory] ? img : [MFFileType imageForType: [[files objectAtIndex: indexPath.row] type]];
	cell.textLabel.text = [[files objectAtIndex: indexPath.row] name];
    if ([[files objectAtIndex: indexPath.row] isDirectory] & ![currentDirectory isEqualToString: @"/var/mobile/Applications"] & ![currentDirectory isEqualToString: @"/User/Applications"] & ![currentDirectory isEqualToString: @"/private/var/mobile/Applications"]) {
        
        NSString *folder = [[[files objectAtIndex: indexPath.row] path] stringByAppendingPathComponent:[[files objectAtIndex: indexPath.row] name]];
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%@: %i, %@: %@", NSLocalizedString(@"Files", @"Files"), [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:nil] count], NSLocalizedString(@"permissions", @"permissions"), [[files objectAtIndex: indexPath.row] permissions]];
    } else if ([currentDirectory isEqualToString: @"/var/mobile/Applications"] || [currentDirectory isEqualToString: @"/User/Applications"] || [currentDirectory isEqualToString: @"/private/var/mobile/Applications"]) {
		NSArray *appFiles = [self.fileManager contentsOfDirectory: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex: indexPath.row] name]]];
		NSString *appDir = nil;
		for (int i = 0; i < [appFiles count]; i++) {
			if ([[[appFiles objectAtIndex: i] name] hasSuffix: @".app"]) {
				appDir = [@"/var/mobile/Applications" stringByAppendingPathComponent: [[[files objectAtIndex: indexPath.row] name] stringByAppendingPathComponent: [[appFiles objectAtIndex: i] name]]];
				break;
			}
		}
		NSDictionary *infoPlist = [[NSDictionary alloc] initWithContentsOfFile: [appDir stringByAppendingPathComponent: @"Info.plist"]];
		NSString *appName = [infoPlist objectForKey: @"CFBundleDisplayName"];
		//cell.detailTextLabel.text = [NSString stringWithFormat: @"Application: %@", appName];
		cell.textLabel.text = appName;
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"Folder", @"Folder") ,[[files objectAtIndex: indexPath.row] name]];
        [infoPlist release];
    } else if ([[files objectAtIndex: indexPath.row] isSymlink]) {
        
		char *buf = malloc (256 * sizeof (char));
		int bytes = readlink ([[[files objectAtIndex: indexPath.row] fullPath] UTF8String], buf, 255);
		buf[bytes] = '\0';
		if ([[[NSString stringWithUTF8String: buf] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]) {
            cell.detailTextLabel.text = [NSString stringWithUTF8String: buf];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"/%@", [NSString stringWithUTF8String: buf]];
        }
		free (buf);
        
	} else {
		cell.detailTextLabel.text = [NSString stringWithFormat: @"%@: %@, %@: %@", NSLocalizedString(@"Size", @"Size"), [[files objectAtIndex: indexPath.row] fsize], NSLocalizedString(@"permissions", @"permissions"), [[files objectAtIndex: indexPath.row] permissions]];
	}
	if ([[files objectAtIndex: indexPath.row] isSymlink]) {
		cell.textLabel.textColor = [UIColor colorWithRed: 0.1 green: 0.3 blue: 1.0 alpha: 1.0];
	} else {
		cell.textLabel.textColor = [UIColor blackColor];
	}
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [cell addGestureRecognizer:longPress];
    
	return cell;

}

-(BOOL) canBecomeFirstResponder {
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    BOOL canPerform = NO;
    
    if (action == @selector(selectcell)) {
        canPerform = YES;
    }
    if (action == @selector(selectall)) {
        canPerform = YES;
    }
    if (action == @selector(deselectall)) {
        canPerform = YES;
    }
    if (action == @selector(selectinverse)) {
        canPerform = YES;
    }
    
    return canPerform;
}

- (void) selectcell {
    [self edit];
//    [tableView setEditing:YES];
    [tableView.delegate tableView:tableView didSelectRowAtIndexPath:[tableView indexPathForRowAtPoint:pressLocation2]];
    [tableView selectRowAtIndexPath:[tableView indexPathForRowAtPoint:pressLocation2] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void) selectall {
    [self edit];
    [tableView setEditing:YES];
    for (int i = 0; i < [tableView numberOfRowsInSection:0]; i++) {
        [tableView.delegate tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        /*[self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
         [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
         [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
         
         NSString *documentsDirectory = @"/private/var/mobile/iRepo";
         system("mkdir -p /private/var/mobile/iRepo");
         NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
         NSString *precontent = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
         NSString *selected = [NSString stringWithFormat:@"%@ '%@/%@'", precontent, @"/private/var/mobile/iRepo",[[packages objectAtIndex: i] name]];
         NSString *realselected = [selected stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
         [realselected writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
         deletebutton.enabled = YES;*/
    }
}

- (void) deselectall {
    [self edit];
//    [tableView setEditing:YES];
    for (int i = 0; i < [tableView numberOfRowsInSection:0]; i++) {
        [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO];
    }
}


- (void) selectinverse{
    [self edit];
//    [tableView setEditing:YES];
    for (int i = 0; i < [tableView numberOfRowsInSection:0]; i++) {
        /*NSString *currentDirectory = @"/private/var/mobile/iRepo";
         NSString *documentsDirectory = @"/private/var/mobile/iRepo";
         NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
         NSString *precontent = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
         NSString *preconten2 = [NSString stringWithFormat:@" '%@/%@'", currentDirectory,[[packages objectAtIndex: i] name]];
         precontent = [precontent stringByReplacingOccurrencesOfString:preconten2 withString:@""];
         if ([[NSString stringWithFormat:@" %@", precontent] isEqualToString:@" "]) {
         deletebutton.enabled = NO;
         }else{
         deletebutton.enabled = YES;
         }*/
        if ([tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].selected) {
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO];
            [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        } else {
            /*[self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
             [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
             [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];*/
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [tableView.delegate tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            /*
             //NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
             NSString *selected = [NSString stringWithFormat:@"%@ '%@/%@'", precontent, @"/private/var/mobile/iRepo",[[packages objectAtIndex: i] name]];
             precontent = [selected stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
             deletebutton.enabled = YES;*/
        }
        //[precontent writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
}

-(void)handleLongPress:(UIGestureRecognizer *)longPress {
    [self becomeFirstResponder];
    //pressLocation2.x = 0;
    //pressLocation2.y = 0;
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        CGPoint pressLocation = [longPress locationInView:tableView];
        pressLocation2 = [longPress locationInView:tableView];
        NSIndexPath *pressedIndexPath = [tableView indexPathForRowAtPoint:pressLocation];
        
        UIMenuItem *uno = [[UIMenuItem alloc] initWithTitle:@"Select Cell" action:@selector(selectcell)];
        UIMenuItem *first = [[UIMenuItem alloc] initWithTitle:@"Select All" action:@selector(selectall)];
        //UIMenuItem *second = [[UIMenuItem alloc] initWithTitle:@"Select Inverse" action:@selector(selectinverse)];
        UIMenuItem *third = [[UIMenuItem alloc] initWithTitle:@"Deselect All" action:@selector(deselectall)];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        menuController.menuItems = [NSArray arrayWithObjects:uno,first,third,nil];
        
        [menuController setTargetRect:longPress.view.frame inView:longPress.view.superview];
        [menuController setMenuVisible:YES animated:YES];
        [pressedIndexPath release];
    }
}


// UITableViewDelegate
- (void) tableView: (UITableView *) theTableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
	if (tableView.editing) {
    }
}

- (void) tableView: (UITableView *) theTableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
	if (tableView.editing) {
        //NSArray* selectedRows = [tableView indexPathsForSelectedRows];
        NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
        NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
        NSString *precontent = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
        NSString *preconten2 = [NSString stringWithFormat:@" '%@/%@'", currentDirectory,[[files objectAtIndex: indexPath.row] name]];
        precontent = [precontent stringByReplacingOccurrencesOfString:preconten2 withString:@""];
        //NSString *selected = [NSString stringWithFormat:@"%@ %@/%@", precontent, currentDirectory,[[files objectAtIndex: indexPath.row] name]];
        [precontent writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        if ([[NSString stringWithFormat:@" %@", precontent] isEqualToString:@" "]) {
            if([[[NSString alloc] initWithContentsOfFile:@"/var/mobile/Library/iFinder/trs" usedEncoding:nil error:nil] isEqualToString:@"NO"]){
                btoolbarItem_3.enabled = NO;
            } else{ btoolbarItem_3.enabled = YES;}
            btoolbarItem_4.enabled = NO;
            btoolbarItem_5.enabled = NO;
            btoolbarItem_6.enabled = NO;
            sendBlue.enabled = NO;
        }else{
            btoolbarItem_3.enabled = YES;
            btoolbarItem_4.enabled = YES;
            btoolbarItem_5.enabled = YES;
            btoolbarItem_6.enabled = YES;
            sendBlue.enabled = YES;
        }
    }
}

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	if (tableView.editing) {
		//NSArray* selectedRows = [tableView indexPathsForSelectedRows];
        NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
        system("mkdir -p /var/mobile/Library/iFinder");
        NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
        NSString *precontent = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
        NSString *selected = [NSString stringWithFormat:@"%@ '%@/%@'", precontent, currentDirectory,[[files objectAtIndex: indexPath.row] name]];
        NSString *realselected = [selected stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
        [realselected writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        btoolbarItem_3.enabled = YES;
        btoolbarItem_4.enabled = YES;
        btoolbarItem_5.enabled = YES;
        btoolbarItem_6.enabled = YES;
        sendBlue.enabled = YES;
            
            
        /*
		if ([[[files objectAtIndex:indexPath.row] rad] intValue] == 0) {
			NSLog(@"index: %d set to 1",indexPath.row);
			[[files objectAtIndex:indexPath.row] setRad:[NSNumber numberWithInt:1]];
			
		}
		else if([[[files objectAtIndex:indexPath.row] rad] intValue] == 1){
			
			NSLog(@"index: %d set to 0",indexPath.row);
			[[files objectAtIndex:indexPath.row] setRad:[NSNumber numberWithInt:0]];
		}
        */
	}
    else{
        seteuid(501);
        [[NSUserDefaults standardUserDefaults] setObject:[[files objectAtIndex: indexPath.row] fullPath] forKey: @"LastFileAccesed"];
        seteuid(0);
        /*if ([[files objectAtIndex: indexPath.row] isSymlink]) {
            char *buf = malloc (256 * sizeof (char));
            int bytes = readlink ([[[files objectAtIndex: indexPath.row] fullPath] UTF8String], buf, 255);
            buf[bytes] = '\0';
            if ([[NSURL URLWithString:[NSString stringWithUTF8String: buf]] isDirectory]) {
                [self loadDirectory: [NSString stringWithUTF8String: buf]];
            }
            else{
                fileViewerController = [[MFFileViewerController alloc] initWithFile: [NSArray arrayWithContentsOfFile:[NSString stringWithUTF8String: buf]]];
                fileViewerController.delegate = self;
                [fileViewerController presentFrom: self];
                [fileViewerController release];
            }
            free (buf);
        }
        else */if ([[files objectAtIndex: indexPath.row] isDirectory]) {
            if ([[files objectAtIndex: indexPath.row] isSymlink]) {
                char *buf = malloc (256 * sizeof (char));
                int bytes = readlink ([[[files objectAtIndex: indexPath.row] fullPath] UTF8String], buf, 255);
                buf[bytes] = '\0';
                if ([[[NSString stringWithUTF8String: buf] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]) {
                    [self loadDirectory: [NSString stringWithUTF8String: buf]];
                }else /*if ([[NSString stringWithUTF8String: buf] isEqualToString:@"private/etc/"]) {
                        [self loadDirectory: @"/private/etc"];
                }else if ([[NSString stringWithUTF8String: buf] isEqualToString:@"private/var/tmp"]) {
                    [self loadDirectory: @"/private/tmp"];
                }else*/{
                    [self loadDirectory: [NSString stringWithFormat:@"/%@", [NSString stringWithUTF8String: buf]]];
                }
            }else{
                [self loadDirectory: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex: indexPath.row] name]]];
            }
        } else if ([[[files objectAtIndex: indexPath.row] type] isEqualToString:@"image"]){
            NSMutableArray *photos = [[NSMutableArray alloc] init];
            NSMutableArray *numero = [[NSMutableArray alloc] init];
            for (int i = 0; i < [files count]; i++) {
                if ([[[files objectAtIndex: i] type] isEqualToString: @"image"]) {
                    [photos addObject: [MWPhoto photoWithFilePath:[[files objectAtIndex: i] fullPath]]];
                    [numero addObject:[files objectAtIndex:i]];
                }
            }
            for (int i = 0; i < [numero count]; i++) {
                if ([[[files objectAtIndex: indexPath.row] fullPath] isEqualToString: [[numero objectAtIndex:i] fullPath]]) {
                    imagenabrir = i;
                }
            }
            //[photos addObject:[MWPhoto photoWithFilePath:[[files objectAtIndex: indexPath.row] fullPath]]];
            //        [photos addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo2l" ofType:@"jpg"]]];
            //        [photos addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo3l" ofType:@"jpg"]]];
            //        [photos addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo4l" ofType:@"jpg"]]];
            
            // Create browser
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
            browser.deletearray = numero;
            //[self.view addSubview:browser.view];
            [browser setInitialPageIndex:imagenabrir]; // Can be changed if desired
            [self.navigationController pushViewController:browser animated:YES];
            //[browser presentFrom: self];
            [browser release];
            [photos release];
            [tableView deselectRowAtIndexPath: indexPath animated: NO];
        } else if ([[[files objectAtIndex: indexPath.row] type] isEqualToString:@"file"]){
            [desconocido showInView: self.view];
            abrirfile = [files objectAtIndex: indexPath.row];
            [tableView deselectRowAtIndexPath: indexPath animated: NO];
        } else if ([[[[files objectAtIndex: indexPath.row] name] pathExtension] isEqualToString:@"deb"]){
            deb.title = [[files objectAtIndex: indexPath.row] name];
            [deb showInView:self.view];
            abrirfile = [files objectAtIndex: indexPath.row];
            [tableView deselectRowAtIndexPath: indexPath animated: NO];
        } else if ([[[[files objectAtIndex: indexPath.row] name] pathExtension] isEqualToString:@"pdf"]){
            ReaderDocument *document = [ReaderDocument unarchiveFromFileName:[[files objectAtIndex: indexPath.row] fullPath]];
            
            if (document == nil) // Create a brand new ReaderDocument object the first time we run
            {
                
                document = [[[ReaderDocument alloc] initWithFilePath:[[files objectAtIndex: indexPath.row] fullPath] password:nil] autorelease];
            }
            
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            /*readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentModalViewController:readerViewController animated:YES];*/


//            [options release];
            
            self.navigationController.title = [[files objectAtIndex: indexPath.row] name];
            self.navigationController.navigationBar.translucent = YES;
            [self.navigationController pushViewController:readerViewController animated:YES];
            [readerViewController release]; // Release the ReaderViewController
            
        }  else if ([[[files objectAtIndex: indexPath.row] type] isEqualToString:@"video"]){ 
            MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL: [NSURL fileURLWithPath: [[files objectAtIndex: indexPath.row] fullPath]]];
            //		moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
            moviePlayer.view.frame = CGRectMake (0, 0, 480, 320);
            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
//            [self.view addSubview: moviePlayer.view];
            //[self.navigationController pushViewController:moviePlayer animated:YES];
            //        moviePlayer.fullscreen = YES;
            moviePlayer.moviePlayer.shouldAutoplay = YES;
            [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
            //        [moviePlayer setMovieControlMode:MPMovieControlModeHidden];
            [moviePlayer.moviePlayer setFullscreen: YES animated: YES];
            [moviePlayer.moviePlayer play];
        }else {
                fileViewerController = [[MFFileViewerController alloc] initWithFile: [files objectAtIndex: indexPath.row]];
                fileViewerController.delegate = self;
                [fileViewerController presentFrom: self];
                [fileViewerController release];
                [tableView deselectRowAtIndexPath: indexPath animated: NO];
            }
        }
}

- (void) openfile:(NSString *)FilePath {
    [self loadDirectory:[FilePath stringByDeletingLastPathComponent]];
    MFFile *file = [[MFFile alloc] init];
    file.path = [FilePath stringByDeletingLastPathComponent];
    file.name = [FilePath lastPathComponent];
    file.type = [MFFileType fileTypeForName: [FilePath lastPathComponent]];
    
    seteuid(501);
    [[NSUserDefaults standardUserDefaults] setObject:FilePath forKey: @"LastFileAccesed"];
    seteuid(0);
    if ([file.type isEqualToString:@"image"]){
         NSMutableArray *photos = [[NSMutableArray alloc] init];
         NSMutableArray *numero = [[NSMutableArray alloc] init];
         for (int i = 0; i < [files count]; i++) {
             if ([[[files objectAtIndex: i] type] isEqualToString: @"image"]) {
                 [photos addObject: [MWPhoto photoWithFilePath:[[files objectAtIndex: i] fullPath]]];
                 [numero addObject:[files objectAtIndex:i]];
             }
         }
         for (int i = 0; i < [numero count]; i++) {
             if ([[file fullPath] isEqualToString: [[numero objectAtIndex:i] fullPath]]) {
                 imagenabrir = i;
             }
         }
         MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
         browser.deletearray = numero;
         [browser setInitialPageIndex:imagenabrir];
         [self.navigationController pushViewController:browser animated:YES];
         [browser release];
         [photos release];
     } else if ([file.type isEqualToString:@"file"]){
         [desconocido showInView: self.view];
         abrirfile = file;
     } else if ([[[file name] pathExtension] isEqualToString:@"deb"]){
         deb.title = [file name];
         [deb showInView:self.view];
         abrirfile = file;
     } else if ([[[file name] pathExtension] isEqualToString:@"pdf"]){
         ReaderDocument *document = [ReaderDocument unarchiveFromFileName:[file fullPath]];
         if (document == nil) // Create a brand new ReaderDocument object the first time we run
         {
             document = [[[ReaderDocument alloc] initWithFilePath:[file fullPath] password:nil] autorelease];
         }
         ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
         readerViewController.delegate = self; // Set the ReaderViewController delegate to self
         //            [options release];
         
         self.navigationController.title = [file name];
         self.navigationController.navigationBar.translucent = YES;
         [self.navigationController pushViewController:readerViewController animated:YES];
         [readerViewController release]; // Release the ReaderViewController
     } else {
         fileViewerController = [[MFFileViewerController alloc] initWithFile: file];
         fileViewerController.delegate = self;
         [fileViewerController presentFrom: self];
         [fileViewerController release];
     }    
    
    [file release];
}
- (void) tableView: (UITableView *) theTableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath {

	detailsController = [[MFDetailsController alloc] initWithFile: [files objectAtIndex: indexPath.row]];
	detailsController.mainController = self;
	self.fileManager.delegate = detailsController;
	[detailsController presentFrom: self];
	[detailsController release];

}

- (NSString *) tableView: (UITableView *) theTableView titleForDeleteConfirmationButtonForRowAtIndexPath: (NSIndexPath *) indexPath {

	return NSLocalizedString(@"Delete", @"Delete");
	
}

- (void) tableView: (UITableView *) theTableView commitEditingStyle: (UITableViewCellEditingStyle) style forRowAtIndexPath: (NSIndexPath *) indexPath {

	/*[operations showInView: self.view];*/
    seteuid(501);
    NSString *trash = [[NSUserDefaults standardUserDefaults] objectForKey: @"MFTrashEnabled"];
    seteuid(0);
    if ([trash isEqualToString:@"YES"]){
        fileIndex = indexPath.row;
        char *cmd = [[NSString stringWithFormat: @"mkdir -p /var/mobile/Library/iFinder/Trash%@ ;mv -f '%@' '/var/mobile/Library/iFinder/Trash%@'", currentDirectory, [NSString stringWithFormat:@"%@/%@", currentDirectory, [[files objectAtIndex: indexPath.row] name]], currentDirectory] UTF8String];
        system (cmd);
        [@"YES" writeToFile:@"/var/mobile/Library/iFinder/trs" atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }else { 
        fileIndex = indexPath.row;
        char *cmd = [[NSString stringWithFormat: @"rm -rf '%@'", [NSString stringWithFormat:@"%@/%@", currentDirectory, [[files objectAtIndex: indexPath.row] name]]] UTF8String];
        system (cmd);
    }/* if ([trash isEqualToString:@"YES"]){
        fileIndex = indexPath.row;
        char *cmd = [[NSString stringWithFormat: @"mkdir -p /var/mobile/Library/iFinder/Trash%@ ;mv %@ /var/mobile/Library/iFinder/Trash%@", currentDirectory, [NSString stringWithFormat:@"%@/%@", currentDirectory, [[files objectAtIndex: fileIndex] name]], currentDirectory] UTF8String];
        system (cmd);
        [@"YES" writeToFile:@"/var/mobile/Library/iFinder/trs" atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }*/
    [self reloadDirectory];
}

// UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (int) index {

	if (actionSheet == sheet) {

		if (index == 0) {
            NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
            NSString *fileName = [NSString stringWithFormat:@"%@/act", documentsDirectory];
            NSString *actiond = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
            NSMutableArray *array3;
//            if ([[[[UIPasteboard generalPasteboard] strings] objectAtIndex:0] rangeOfString:@"' '"].location == NSNotFound){
            NSString *pasteb = [NSString stringWithContentsOfFile:@"/private/var/mobile/Library/iFinder/pasteboard" encoding:NSUTF8StringEncoding error:nil];
            if ([pasteb rangeOfString:@"' '"].location == NSNotFound){
//                array3 = [[NSMutableArray alloc] initWithObjects:[[[UIPasteboard generalPasteboard] strings] objectAtIndex:0], nil];
                array3 = [[NSMutableArray alloc] initWithObjects:pasteb, nil];
                [array3 replaceObjectAtIndex:0 withObject:[[array3 objectAtIndex:0] stringByReplacingOccurrencesOfString:@" '" withString:@""]];
                [array3 replaceObjectAtIndex:0 withObject:[[array3 objectAtIndex:0] stringByReplacingOccurrencesOfString:@"'" withString:@""]];
            } else {
//                array3 = [[NSMutableArray alloc] initWithArray:[[[[UIPasteboard generalPasteboard] strings] objectAtIndex:0] componentsSeparatedByString:@"' '"]];
                array3 = [[NSMutableArray alloc] initWithArray:[pasteb componentsSeparatedByString:@"' '"]];
                [array3 replaceObjectAtIndex:0 withObject:[[array3 objectAtIndex:0] stringByReplacingOccurrencesOfString:@" '" withString:@""]];
                [array3 replaceObjectAtIndex:[array3 indexOfObject:[array3 lastObject]] withObject:[[array3 lastObject] stringByReplacingOccurrencesOfString:@"'" withString:@""]];
            }
            //NSString *conflictst = [array3 objectAtIndex: actionSheet.tag];
            if ([actiond isEqualToString: @"CUT"]) {
                for (int i = 0; i <= [array3 count] + 1; i++) {
                    //NSString *copy = [[[UIPasteboard generalPasteboard] strings] objectAtIndex: i];
                    NSString *copy = [array3 objectAtIndex: i];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", currentDirectory, [copy lastPathComponent]]]){
                        
                        NSString *title1 = [NSString stringWithFormat:@"'%@' %@", [[copy stringByReplacingOccurrencesOfString:@"'" withString:@""] lastPathComponent], NSLocalizedString(@"Already Exists", @"Already Exists")];
                        NSString *title2 = NSLocalizedString(@"What do you want to do?", @"What do you want to do?");
                        
                        /*UITextField *conflictstring = [[UITextField alloc] initWithFrame:CGRectMake(12,45,260,25)];
                         conflictstring.hidden = YES;
                         conflictstring.text = copy;
                         conflictstring.tag = i;*/
                        
                        conflict = [[UIAlertView alloc] initWithTitle:title1 message:title2 delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")otherButtonTitles:NSLocalizedString(@"Overwrtite", @"Overwrtite"), NSLocalizedString(@"Rename", @"Rename"), nil];
                        conflict.tag = i;
                        hacer = @"Cortar";
                        //[conflict addSubview:conflictstring];
                        //conflict.title = title1;
                        //conflict.message = title2;
                        
                        [conflict show];
                        [conflict release];
//                        [self reloadDirectory];
                    } else {
                        char *cmd = [[NSString stringWithFormat: @"mv '%@' '%@'", copy, currentDirectory] UTF8String];
                        system (cmd);
//                        [self reloadDirectory];
                    }
                    [self reloadDirectory];
                }
            } else {
                for (int i = 0; i <= [array3 count] + 1; i++) {
                    //NSString *copy = [[[UIPasteboard generalPasteboard] strings] objectAtIndex: i];
                    NSString *copy = [array3 objectAtIndex: i];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", currentDirectory, [copy lastPathComponent]]]){
                        
                        NSString *title1 = [NSString stringWithFormat:@"'%@' %@", [[copy stringByReplacingOccurrencesOfString:@"'" withString:@""] lastPathComponent], NSLocalizedString(@"Already Exists", @"Already Exists")];
                        NSString *title2 = NSLocalizedString(@"What do you want to do?", @"What do you want to do?");
                        
                        /*UITextField *conflictstring = [[UITextField alloc] initWithFrame:CGRectMake(12,45,260,25)];
                        conflictstring.hidden = YES;
                        conflictstring.text = copy;
                        conflictstring.tag = i;*/
                        
                        conflict = [[UIAlertView alloc] initWithTitle:title1 message:title2 delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")otherButtonTitles:NSLocalizedString(@"Overwrtite", @"Overwrtite"), NSLocalizedString(@"Rename", @"Rename"), nil];
                        conflict.tag = i;
                        hacer = @"Copiar";
                        //[conflict addSubview:conflictstring];
                        //conflict.title = title1;
                        //conflict.message = title2;
                        
                        [conflict show];
                        [conflict release];
//                        [self reloadDirectory];
                    } else {
                        char *cmd = [[NSString stringWithFormat: @"cp -r '%@' '%@'", copy, currentDirectory] UTF8String];
                        system (cmd);
//                        [self reloadDirectory];
                    }
                    [self reloadDirectory];
                }
            }
		} else if (index == 1) {
            NSString *pasteb = [NSString stringWithContentsOfFile:@"/private/var/mobile/Library/iFinder/pasteboard" encoding:NSUTF8StringEncoding error:nil];
//			for (int i = 0; i < [[[UIPasteboard generalPasteboard] strings] count]; i++) {
			for (int i = 0; i < [[pasteb componentsSeparatedByString:@"'"] count]; i++) {
//                NSString *from = [[[UIPasteboard generalPasteboard] strings] objectAtIndex: i];
                
                NSString *from = [[[[[pasteb componentsSeparatedByString:@"'"] objectAtIndex:i] stringByReplacingOccurrencesOfString:@"' " withString:@""] stringByReplacingOccurrencesOfString:@" '" withString:@""] stringByReplacingOccurrencesOfString:@"' '" withString:@""];
                char *symb = [[NSString stringWithFormat: @"ln -s '%@' '%@'", from, currentDirectory] UTF8String];
                system (symb);
            }
            
            [self reloadDirectory];
            self.navigationItem.leftBarButtonItem.enabled = NO;
		} else {
			return;
		}
		
	} else if (actionSheet == operations) {
	
		if (index == 0) {
		
			[self.fileManager deleteFile: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex: fileIndex] name]]];
			[files removeObjectAtIndex: fileIndex];
			[tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow: fileIndex inSection: 0]] withRowAnimation: UITableViewRowAnimationRight];
			
		} else if (index == 1) {
		            
//            [[UIPasteboard generalPasteboard] setStrings: [NSArray arrayWithObject: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex: fileIndex] name]]]];
            [pasteboard setStrings: [NSArray arrayWithObject: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex: fileIndex] name]]]];
			[[UIPasteboard pasteboardWithName: @"MFPasteboard2" create: YES] setString: @"COPY"];
			
		} else if (index == 2) {
		
//			[[UIPasteboard generalPasteboard] setStrings: [NSArray arrayWithObject: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex: fileIndex] name]]]];
			[pasteboard setStrings: [NSArray arrayWithObject: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex: fileIndex] name]]]];
			[[UIPasteboard pasteboardWithName: @"MFPasteboard2" create: YES] setString: @"CUT"];
//			[pasteboard setString: @"CUT"];
            
			
		} /*else if (index == 3) {
		
			[pasteController addFile: [files objectAtIndex: fileIndex]];
        }*/ else {
		
			return;
			
		}
		
	}else if (actionSheet == operations2) {
        
        if (index == 0) {
            NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
            NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
            NSString *copystring = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
            NSString *fileName2 = [NSString stringWithFormat:@"%@/act", documentsDirectory];
            [@"COPY" writeToFile:fileName2 atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
//            [[UIPasteboard generalPasteboard] setStrings: [NSArray arrayWithObject: copystring]];
            NSString *pasteb = [NSString stringWithContentsOfFile:@"/private/var/mobile/Library/iFinder/pasteboard" encoding:NSUTF8StringEncoding error:nil];
            pasteb = copystring;
            [pasteb writeToFile:@"/private/var/mobile/Library/iFinder/pasteboard" atomically:NO encoding:NSUTF8StringEncoding error:nil];
//            [pasteboard setStrings: [NSArray arrayWithObject: copystring]];
			
		} else if (index == 1) {
            NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
            NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
            NSString *cutstring = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
            NSString *fileName2 = [NSString stringWithFormat:@"%@/act", documentsDirectory];
            [@"CUT" writeToFile:fileName2 atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
//            [[UIPasteboard generalPasteboard] setStrings: [NSArray arrayWithObject: cutstring]];
//            [pasteboard setStrings: [NSArray arrayWithObject: cutstring]];
            NSString *pasteb = [NSString stringWithContentsOfFile:@"/private/var/mobile/Library/iFinder/pasteboard" encoding:NSUTF8StringEncoding error:nil];
            pasteb = cutstring;
            [pasteb writeToFile:@"/private/var/mobile/Library/iFinder/pasteboard" atomically:NO encoding:NSUTF8StringEncoding error:nil];
		}else {
               
               return;
               
           }
		
	} else if (actionSheet == sharing) {
        
        if (index == 0) {
            
            [fileSharingController presentFrom: self];
            
        } else if (index == 1) {
            
            [sftpController presentFrom: self];
            
        } else {
            
            return;
            
        }
        
    } else if (actionSheet == deleteoptions){
            if (index == 0){
                char *cmd = [[NSString stringWithFormat: @"mkdir -p '/var/mobile/Library/iFinder/Trash%@' ;mv -f %@ '/var/mobile/Library/iFinder/Trash%@'", currentDirectory, goingtodelete, currentDirectory] UTF8String];

                system (cmd);
                [self reloadDirectory];
                [@"YES" writeToFile:@"/var/mobile/Library/iFinder/trs" atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
                btoolbarItem_3.enabled = YES;
            } else if (index == 1){
                [self loadDirectory: @"/var/mobile/Library/iFinder/Trash"];
                UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit)] autorelease];
                self.navigationItem.rightBarButtonItem = editButton;
                
                [tableView setEditing:NO animated:YES];
                self.navigationItem.leftBarButtonItem.enabled = YES;
                
                NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
                NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
                NSString *save = @"";
                [save writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
                
                [toolbar setHidden:NO];
                [toolbar2 setHidden:YES];
                if([[[NSString alloc] initWithContentsOfFile:@"/var/mobile/Library/iFinder/trs" usedEncoding:nil error:nil] isEqualToString:@"NO"]){
                    btoolbarItem_3.enabled = NO;
                } else{ btoolbarItem_3.enabled = YES;}
                btoolbarItem_4.enabled = NO;
                btoolbarItem_5.enabled = NO;
                btoolbarItem_6.enabled = NO;
                sendBlue.enabled = NO;
            
            } else if (index == 2){
                system ("rm -rf /var/mobile/Library/iFinder/Trash");
                system ("mkdir /var/mobile/Library/iFinder");
                [@"NO" writeToFile:@"/var/mobile/Library/iFinder/trs" atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
                btoolbarItem_3.enabled = NO;
            } else{
                return;
            }
    }else if (actionSheet == deleteborrar){
        if (index == 0){
            char *cmd = [[NSString stringWithFormat: @"mkdir -p '/var/mobile/Library/iFinder/Trash%@' ;mv -f %@ '/var/mobile/Library/iFinder/Trash%@'", currentDirectory, goingtodelete, currentDirectory] UTF8String];
            
            system (cmd);
            [self reloadDirectory];
            [@"YES" writeToFile:@"/var/mobile/Library/iFinder/trs" atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        } else{
            return;
        }
    }else if (actionSheet == deletetrash){
        if (index == 0){
            [self loadDirectory: @"/var/mobile/Library/iFinder/Trash"];
            UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit)] autorelease];
            self.navigationItem.rightBarButtonItem = editButton;
            
            [tableView setEditing:NO animated:YES];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            
            NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
            NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
            NSString *save = @"";
            [save writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
            
            [toolbar setHidden:NO];
            [toolbar2 setHidden:YES];
            if([[[NSString alloc] initWithContentsOfFile:@"/var/mobile/Library/iFinder/trs" usedEncoding:nil error:nil] isEqualToString:@"NO"]){
                btoolbarItem_3.enabled = NO;
            } else{ btoolbarItem_3.enabled = YES;}
            btoolbarItem_4.enabled = NO;
            btoolbarItem_6.enabled = NO;
            sendBlue.enabled = NO;
            
        } else if (index == 1){
            system ("rm -rf /var/mobile/Library/iFinder/Trash");
            system ("mkdir /var/mobile/Library/iFinder");
            [@"NO" writeToFile:@"/var/mobile/Library/iFinder/trs" atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
            btoolbarItem_3.enabled = NO;
        } else{
            return;
        }
    }else if (actionSheet == recibBT){
        if (index == 0){     
            picker = [[GKPeerPickerController alloc] init];
            picker.delegate = self;
            picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;      
            [picker show]; 
            NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
            NSString *fileName = [NSString stringWithFormat:@"%@/bt", documentsDirectory];
            [@"receive" writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        } else{
            return;
        }
    }else if (actionSheet == enviarorecibBT){
        if (index == 0){
            picker = [[GKPeerPickerController alloc] init];
            picker.delegate = self;
            picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;      
            [picker show]; 
            NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
            NSString *fileName = [NSString stringWithFormat:@"%@/bt", documentsDirectory];
            [@"send" writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        }/* else if (index == 1){
            picker = [[GKPeerPickerController alloc] init];
            picker.delegate = self;
            picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;      
            [picker show]; 
            NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
            NSString *fileName = [NSString stringWithFormat:@"%@/bt", documentsDirectory];
            [@"receive" writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        }*/ else{
            return;
        }
    } else if (actionSheet == more){
        if (index == 0){
            [fileSharingController presentFrom: self];
        } else if (index == 1) {
            [backup presentFrom: self];
        } else if (index == 2) {
            [self reloadDirectory];
        }else {
            return;
        }
    } else if (actionSheet == desconocido){
        if (index == 0) {
            fileViewerController = [[MFFileViewerController alloc] initWithFile:abrirfile type:@"text"];
            fileViewerController.delegate = self;
            [fileViewerController presentFrom: self];
            [fileViewerController release];            
        } else if (index == 1) {
            fileViewerController = [[MFFileViewerController alloc] initWithFile:abrirfile type:@"package"];
            fileViewerController.delegate = self;
            [fileViewerController presentFrom: self];
            [fileViewerController release];
        } else if (index == 2) {
            fileViewerController = [[MFFileViewerController alloc] initWithFile:abrirfile type:@"html"];
            fileViewerController.delegate = self;
            [fileViewerController presentFrom: self];
            [fileViewerController release];
        } else if (index == 3) {
            NSMutableArray *photos = [[NSMutableArray alloc] init];
            [photos addObject: [MWPhoto photoWithFilePath:[abrirfile fullPath]]];
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
            [browser setInitialPageIndex:imagenabrir]; // Can be changed if desired
            [self.navigationController pushViewController:browser animated:YES];
            [browser release];
            [photos release];
        } else if (index == 4) {
            fileViewerController = [[MFFileViewerController alloc] initWithFile:abrirfile type:@"video"];
            fileViewerController.delegate = self;
            [fileViewerController presentFrom: self];
            [fileViewerController release];
        } else if (index == 5) {
            fileViewerController = [[MFFileViewerController alloc] initWithFile:abrirfile type:@"sound"];
            fileViewerController.delegate = self;
            [fileViewerController presentFrom: self];
            [fileViewerController release];
        } else if (index == 6) {
            fileViewerController = [[MFFileViewerController alloc] initWithFile:abrirfile type:@"binary"];
            fileViewerController.delegate = self;
            [fileViewerController presentFrom: self];
            [fileViewerController release];
        } else if (index == 7) {
            fileViewerController = [[MFFileViewerController alloc] initWithFile:abrirfile type:@"plist"];
            fileViewerController.delegate = self;
            [fileViewerController presentFrom: self];
            [fileViewerController release];
        } else if (index == 8) {
            fileViewerController = [[MFFileViewerController alloc] initWithFile:abrirfile type:@"sql"];
            fileViewerController.delegate = self;
            [fileViewerController presentFrom: self];
            [fileViewerController release];
        } else if (index == 9) {
            NSURL *path = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/private/var/mobile/%@",[abrirfile name]]];
            UIDocumentInteractionController *docController = [UIDocumentInteractionController interactionControllerWithURL:path];
            [docController retain];
            docController.delegate = self;
            [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        } else{
            return;
        }
    } else if (actionSheet == deb){
        if (index == 0) {
            execute = [[MFCommandController alloc] initWithCommand:[NSString stringWithFormat:@"dpkg -i '%@'", [abrirfile fullPath]]];
            [execute start];
            [execute presentFrom:self];
            [execute release];
        } else if (index == 1) {
            execute = [[MFCommandController alloc] initWithCommand:[NSString stringWithFormat:@"/usr/bin/7z x -y -o'%@/%@' '%@'", [abrirfile path], [abrirfile.name stringByReplacingOccurrencesOfString:@".deb" withString:@""], [abrirfile fullPath]]];
            [execute start];
            [execute presentFrom:self];
            [execute release];
        } else {
            return;
        }
    }
}
- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    char *copy = [[NSString stringWithFormat:@"cp -r '%@' /private/var/mobile/", [abrirfile fullPath]] UTF8String];
    system(copy);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    
}

-(void) documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller{
    [controller autorelease];
}


// UISearchBarDelegate
- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText {
	[self reloadDirectory];
	
    if ([currentDirectory isEqualToString:@"/var/mobile/Applications"] || [currentDirectory isEqualToString:@"/private/var/mobile/Applications"]) {
        
        for (int i = 0; i < [files count]; i++) {
            NSArray *appFiles = [self.fileManager contentsOfDirectory: [currentDirectory stringByAppendingPathComponent: [[files objectAtIndex:i] name]]];
            NSString *appDir = nil;
            for (int i = 0; i < [appFiles count]; i++) {
                if ([[[appFiles objectAtIndex: i] name] hasSuffix: @".app"]) {
                    appDir = [@"/var/mobile/Applications" stringByAppendingPathComponent: [[[files objectAtIndex:i] name] stringByAppendingPathComponent: [[appFiles objectAtIndex: i] name]]];
                    break;
                }
            }
            NSDictionary *infoPlist = [[NSDictionary alloc] initWithContentsOfFile: [appDir stringByAppendingPathComponent: @"Info.plist"]];
            NSString *appName = [infoPlist objectForKey: @"CFBundleDisplayName"];
            
            NSRange textRange;
            textRange = [[[[[files objectAtIndex: i] name] stringByAppendingFormat:appName] lowercaseString] rangeOfString: [bar.text lowercaseString]];
            NSRange textRange2 = [[[[files objectAtIndex: i] name] lowercaseString] rangeOfString: [bar.text lowercaseString]];
            if (textRange.location != NSNotFound || textRange2.location != NSNotFound) {
                [searchResult addObject: [files objectAtIndex: i]];
            }
        }
    } else {
        for (int i = 0; i < [files count]; i++) {
            NSRange textRange;
            textRange = [[[[files objectAtIndex: i] name] lowercaseString] rangeOfString: [bar.text lowercaseString]];
            if (textRange.location != NSNotFound) {
                [searchResult addObject: [files objectAtIndex: i]];
            }
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

// MFFileViewerControllerDelegate

- (void) fileViewerDidFinishViewing: (MFFileViewerController *) fileViewer {

	[self reloadDirectory];

}

// MFDetailsControllerDelegate

- (void) detailsControllerDidClose: (MFDetailsController *) detailsController {

	[self reloadDirectory];
	
}

- (void) settingsControllerDidClose:(MFSettingsController *)settingsController {
    
	[self reloadDirectory];
	
}

- (void) mailComposeController: (MFMailComposeViewController *) controller didFinishWithResult: (MFMailComposeResult) result error: (NSError *) error {
    
	[self dismissModalViewControllerAnimated: YES];
	
}

//////////////////////////////Enviar Por BT/////////////////////////////////////
- (void)sendBT{
    NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
    NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
    NSString *precontent = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if ([[NSString stringWithFormat:@" %@", precontent] isEqualToString:@" "]) {
        [recibBT showInView:self.view];
    } else{
        [enviarorecibBT showInView:self.view];
    }
    /*picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;      
    
    //[connect setHidden:YES];
    //[disconnect setHidden:NO];    
    [picker show]; */
    
}

/*- (void) mySendDataToPeers:(NSData *) data
{
    if (currentSession) 
        [self.currentSession sendDataToAllPeers:data 
                                   withDataMode:GKSendDataReliable 
                                          error:nil];    
}*/


- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session {
    self.currentSession = session;
    //self.currentSession.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    picker.delegate = self;
    
    [picker dismiss];
    [picker autorelease];
    
    NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
    NSString *filename2 = [NSString stringWithFormat:@"%@/bt", documentsDirectory];
    NSString *Bt = [[NSString alloc] initWithContentsOfFile:filename2 encoding:NSStringEncodingConversionAllowLossy error:nil];
    if([Bt isEqualToString:@"send"]){
        NSLog(@"Sending");
        NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
        NSString *selected = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
        selected = [selected stringByReplacingOccurrencesOfString:currentDirectory withString:@""];
        char *cmd = [[NSString stringWithFormat:@"cd '%@'; zip -r Bluetooth.zip %@", currentDirectory, selected] UTF8String];
        system(cmd);
        NSData* data;
        data = [NSData dataWithContentsOfFile: [NSString stringWithFormat:@"%@/Bluetooth.zip", currentDirectory]];
        [self mySendDataToPeers:data];
        [session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
        NSLog(@"Sent");
    } else{
        NSLog(@"Connected");
    }
    
//    [connect setHidden:NO];
//    [disconnect setHidden:YES];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    picker.delegate = nil;
    [picker autorelease];
    
//    [connect setHidden:NO];
//    [disconnect setHidden:YES];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state)
    {
        case GKPeerStateConnected:
            NSLog(@"connected");
            break;
        case GKPeerStateDisconnected:
            NSLog(@"disconnected");
            [self.currentSession release];
            currentSession = nil;
            
            //[connect setHidden:NO];
            //[disconnect setHidden:YES];
            break;
    }
}

/*-(void) sendBTa{
    NSString *documentsDirectory = @"/var/mobile/Library/iFinder";
    NSString *fileName = [NSString stringWithFormat:@"%@/stc", documentsDirectory];
    NSString *selected = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    char *cmd = [[NSString stringWithFormat:@"cd %@; zip -r Bluetooth.zip %@", currentDirectory, selected] UTF8String];
    system(cmd);
    NSData* data;
    data = [NSData dataWithContentsOfFile: [NSString stringWithFormat:@"%@/Bluetooth.zip", currentDirectory]];
    [self mySendDataToPeers:data];
}*/

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    NSLog(@"Received");
    //---convert the NSData to NSString---
    system("mkdir -p /var/mobile/Bluetooth");
    //NSString* str;
    //str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]; 
    NSData *reciev = data;
    [reciev writeToFile:@"/var/mobile/Bluetooth/Bluetooth.zip" atomically:NO];
    char *cmd2 = [[NSString stringWithFormat:@"cd /var/mobile/Bluetooth/; unzip Bluetooth.zip"] UTF8String];
    system(cmd2);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Data received", @"Data received") message:NSLocalizedString(@"Files Saved in /var/mobile/Bluetooth", @"Files Saved in /var/mobile/Bluetooth") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:NSLocalizedString(@"Open Folder",@"Open Folder"), nil];
    alert.tag = 9999;
    [alert show];
    [alert release];
    

    //Disconect
    [self.currentSession disconnectFromAllPeers];
    [self.currentSession release];
    currentSession = nil;
    

}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1 && actionSheet.tag==9999)
    {
        [self loadDirectory: @"/var/mobile/Bluetooth"];
    } else if (buttonIndex == 1  && !actionSheet.tag==9999){
        NSString *pasteb = [NSString stringWithContentsOfFile:@"/private/var/mobile/Library/iFinder/pasteboard" encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray *array2 = [[NSMutableArray alloc] initWithArray:[pasteb componentsSeparatedByString:@"' '"]];
        [array2 replaceObjectAtIndex:0 withObject:[[array2 objectAtIndex:0] stringByReplacingOccurrencesOfString:@"'" withString:@""]];
        NSString *conflictst = [[array2 objectAtIndex: actionSheet.tag] stringByReplacingOccurrencesOfString:@"'" withString:@""];

        NSRange range = {1,1};
        if ([[conflictst substringWithRange:range] isEqualToString:@"/"]) {
            conflictst = [conflictst substringFromIndex:1];
        }

        //[conflictst writeToFile:[NSString stringWithFormat:@"%@%i.txt", @"/a", actionSheet.tag] atomically:NO encoding:NSUTF8StringEncoding error:nil];
        if ([hacer isEqualToString:@"Cortar"]) {
            char *cmd = [[NSString stringWithFormat: @"mv -f '%@' '%@'", conflictst, currentDirectory] UTF8String];
            system (cmd);
        } else {
            char *cmd = [[NSString stringWithFormat: @"cp -r '%@' '%@'", conflictst, currentDirectory] UTF8String];
            system (cmd);
        }
        [self reloadDirectory];
    } else if (buttonIndex == 2 && !actionSheet.tag==9999){
//        NSMutableArray *array2 = [[NSMutableArray alloc] initWithArray:[[[[UIPasteboard generalPasteboard] strings] objectAtIndex:0] componentsSeparatedByString:@"' '"]];
        NSString *pasteb = [NSString stringWithContentsOfFile:@"/private/var/mobile/Library/iFinder/pasteboard" encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray *array2 = [[NSMutableArray alloc] initWithArray:[pasteb componentsSeparatedByString:@"' '"]];
        [array2 replaceObjectAtIndex:0 withObject:[[array2 objectAtIndex:0] stringByReplacingOccurrencesOfString:@"'" withString:@""]];
        NSString *conflictst = [array2 objectAtIndex: actionSheet.tag];
        NSString *renamestring = [[conflictst stringByReplacingOccurrencesOfString:@"'" withString:@""] lastPathComponent];
        NSString *renamestring2 = [[[[renamestring componentsSeparatedByString: @"."] lastObject] lowercaseString] copy];
        NSString *renamestring3;
        if ([renamestring rangeOfString:@"."].location != NSNotFound){
            renamestring3 = [renamestring stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", renamestring2] withString:[NSString stringWithFormat:@"(2).%@", renamestring2]];
        } else {
            renamestring3 = [renamestring stringByAppendingString:@"(2)"];
        }
        //[renamestring3 writeToFile:@"/a.text" atomically:NO encoding:NSUTF8StringEncoding error:nil];
        NSString *renamestring4 = [currentDirectory stringByAppendingFormat:@"/%@", renamestring3];
        renamestring4 = [renamestring4 stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
        //[[NSString stringWithFormat: @"cp -r '%@' '%@'", conflictst, renamestring4] writeToFile:@"/b.text" atomically:NO encoding:NSUTF8StringEncoding error:nil];
        if ([[conflictst substringToIndex:1] isEqualToString:@" "]){
            conflictst = [conflictst substringFromIndex:1];
        }
        
        if ([hacer isEqualToString:@"Cortar"]) {
            char *cmd = [[NSString stringWithFormat: @"mv -f '%@' '%@'", conflictst, renamestring4] UTF8String];
            system (cmd);
        } else {
            char *cmd = [[NSString stringWithFormat: @"cp -r '%@' '%@'", conflictst, renamestring4] UTF8String];
            system (cmd);
        }
        [self reloadDirectory];
    }
}

@end

