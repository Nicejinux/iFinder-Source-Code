//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFBookmarksController.h"

@implementation MFBookmarksController

@synthesize mainController = mainController;

// super

- (id) init {
    
	self = [super init];
	
	self.title = NSLocalizedString(@"Bookmarks", @"Bookmarks");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addBookmark)] autorelease];
	
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460)];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: tableView];
    
    bookmarks = [[NSMutableArray alloc] init];
    bookmarksnames = [[NSMutableArray alloc] init];
    
    [self reloadDataTable];
	
	return self;
	
}

- (void) reloadDataTable {
    [bookmarks removeAllObjects];
    [bookmarksnames removeAllObjects];
    seteuid(501);
	[bookmarks addObjectsFromArray: [[NSUserDefaults standardUserDefaults] arrayForKey: @"MFBookmarks"]];
    [bookmarksnames addObjectsFromArray: [[NSUserDefaults standardUserDefaults] arrayForKey: @"MFBookmarksName"]];
    seteuid(0);
    [tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated{
    [self reloadDataTable];
}

- (void) dealloc {
    
	[tableView release];
	tableView = nil;
    [bookmarks release];
    bookmarks = nil;
    [bookmarksnames release];
    bookmarksnames = nil;
	
	[super dealloc];
	
}
// self

- (void) addBookmark {
    newbookmark = [[MFNewBookmark alloc] initWithPath:[self.mainController currentDirectory]];
    [newbookmark presentFrom: self];
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[bookmarks objectAtIndex: indexPath.row]]) {
        UIAlertView *nofile = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"There is no file at this path", @"There is no file at this path") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [nofile show];
        [nofile release];
    } else {
        NSDictionary *Dict = [[NSFileManager defaultManager] fileAttributesAtPath:[bookmarks objectAtIndex: indexPath.row] traverseLink:NO];
        if ([[Dict objectForKey:NSFileType] isEqualToString: @"NSFileTypeDirectory"]){
            [self.mainController loadDirectory: [bookmarks objectAtIndex: indexPath.row]];
        } else {
            [self.mainController openfile:[bookmarks objectAtIndex: indexPath.row]];
        }
    }
    
	[self close];
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
	return [bookmarks count];
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"cell"];
	}

	cell.textLabel.text = [[bookmarks objectAtIndex: indexPath.row] lastPathComponent];
    cell.detailTextLabel.text = [bookmarks objectAtIndex: indexPath.row];
    
    for (int i = 0; i < [bookmarksnames count]; i++) {
        if ([[[[bookmarksnames objectAtIndex:i] componentsSeparatedByString:@";"] lastObject] isEqualToString:[bookmarks objectAtIndex: indexPath.row]]) {
            cell.textLabel.text = [[bookmarksnames objectAtIndex:i] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@";%@",[[[bookmarksnames objectAtIndex:i] componentsSeparatedByString:@";"] lastObject]] withString:@""];
        }
    }
	
	return cell;
	
}

- (void) tableView: (UITableView *) theTableView commitEditingStyle: (UITableViewCellEditingStyle) style forRowAtIndexPath: (NSIndexPath *) indexPath {

    for (int i = 0; i < [bookmarksnames count]; i++) {
        if ([[[[bookmarksnames objectAtIndex:i] componentsSeparatedByString:@";"] lastObject] isEqualToString:[bookmarks objectAtIndex: indexPath.row]]) {
            [bookmarksnames removeObjectAtIndex:i];
        }
    }
	[bookmarks removeObjectAtIndex: indexPath.row];
    
	[theTableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationRight];
    
    seteuid(501);
	[[NSUserDefaults standardUserDefaults] setObject: bookmarks forKey: @"MFBookmarks"];
    [[NSUserDefaults standardUserDefaults] setObject: bookmarksnames forKey: @"MFBookmarksNames"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    seteuid(0);
	
}

@end