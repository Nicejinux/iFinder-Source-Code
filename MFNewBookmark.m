//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import "MFNewBookmark.h"

@implementation MFNewBookmark

@synthesize mainController = mainController;

// self

- (id) initWithPath:(NSString *)Path{
    self = [super init];
	
	self.title = NSLocalizedString(@"New Bookmark", @"New Bookmark");
    
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
    
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.dataSource = self;
	tableView.delegate = self;
    tableView.scrollEnabled = NO;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: tableView];
    [tableView release];
    
	filename = [Path lastPathComponent];
    BookmarkName = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, 160, 30)];
    BookmarkName.text = filename;
    BookmarkName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    BookmarkName.placeholder = NSLocalizedString(@"Type name here", @"Type name here");
    BookmarkName.delegate = self;
    BookmarkName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    BookmarkName.autocorrectionType = UITextAutocorrectionTypeNo;
    BookmarkPath.enabled = YES;
    
    filepath = Path;
    BookmarkPath = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, 160, 30)];
    BookmarkPath.text = filepath;
    BookmarkPath.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    BookmarkPath.placeholder = NSLocalizedString(@"Destination", @"Destination");
    BookmarkPath.delegate = self;
    BookmarkPath.autocapitalizationType = UITextAutocapitalizationTypeNone;
    BookmarkPath.autocorrectionType = UITextAutocorrectionTypeNo;
    BookmarkPath.enabled = YES;
    
	return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) saveButtonPressed {
    seteuid(501);
    NSString *path;
    if (BookmarkPath.text == nil){
        path = filepath;
    } else {
        path = BookmarkPath.text;
    }
    
    NSString *name;
    if (BookmarkName.text == nil){
        name = [filename stringByAppendingFormat:@";%@", path];
    } else {
        name = [BookmarkName.text stringByAppendingFormat:@";%@", path];
    }
    
    NSMutableArray *bookmarks = [[NSMutableArray alloc] init];
	[bookmarks addObjectsFromArray: [[NSUserDefaults standardUserDefaults] arrayForKey: @"MFBookmarks"]];
	[bookmarks addObject: path];
	[[NSUserDefaults standardUserDefaults] setObject: bookmarks forKey: @"MFBookmarks"];
    
    NSMutableArray *bookmarksname = [[NSMutableArray alloc] init];
    [bookmarksname addObjectsFromArray: [[NSUserDefaults standardUserDefaults] arrayForKey: @"MFBookmarksName"]];
    [bookmarksname addObject:name];
	[[NSUserDefaults standardUserDefaults] setObject: bookmarksname forKey: @"MFBookmarksName"];
    
	[[NSUserDefaults standardUserDefaults] synchronize];
    seteuid(0);

	[self close];
    
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
        return 3;
    
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFNFCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFNFCell"];
	}
    
    if (indexPath.row == 0) {
            
        cell.text = NSLocalizedString(@"Name", @"Name");
        cell.accessoryView = BookmarkName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
    } else if (indexPath.row == 1) {
            
        cell.text = NSLocalizedString(@"Path", @"Path");
        cell.accessoryView = BookmarkPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
    } else if (indexPath.row == 2) {
            
        cell.text = NSLocalizedString(@"Create", @"Create");
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryView = nil;
        cell.textAlignment = UITextAlignmentCenter;
            
    }
    
	return cell;
    
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if (indexPath.row == 0) {
            
        [BookmarkName isFirstResponder];
            
    } else if (indexPath.row == 1) {
            
        [BookmarkPath isFirstResponder];
            
    } else if (indexPath.row == 2) {
            
        [self saveButtonPressed];
            
    }
    
}

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {
    
	[theTextField resignFirstResponder];
    
	return YES;
    
}

- (void) dealloc {
    [BookmarkName release];
    [BookmarkPath release];
    filename = nil;
    filepath = nil;
}

@end
