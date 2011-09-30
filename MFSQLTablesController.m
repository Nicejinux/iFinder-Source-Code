//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFSQLTablesController.h"

@implementation MFSQLTablesController

// self

- (id) initWithSQLManager: (SQLiteManager *) sqlMgr {

	self = [super init];
	
	self.title = NSLocalizedString(@"Tables in database", @"Tables in database");
	manager = [sqlMgr retain];
	tables = [manager executeSQLQuery: @"SELECT name FROM sqlite_master WHERE type='table';"];
	tableView = [[UITableView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizingMask = self.view.autoresizingMask;
	[self.view addSubview: tableView];
	
	return self;
	
}

// super

- (void) dealloc {

	[manager release];
	manager = nil;
	[tableView release];
	tableView = nil;
	
	[super dealloc];
	
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
	NSArray *tmp1 = [manager executeSQLQuery: [NSString stringWithFormat: @"PRAGMA table_info(%@);", [[tables objectAtIndex: indexPath.row] objectAtIndex: 0]]];
	NSMutableArray *tmp2 = [[NSMutableArray alloc] init];
	for (int i = 0; i < [tmp1 count]; i++) {
		[tmp2 addObject: [[tmp1 objectAtIndex: i] objectAtIndex: 1]];
	}
	
	UIAlertView *av = [[UIAlertView alloc] init];
	av.title = NSLocalizedString(@"Columns of table", @"Columns of table");
	av.message = [tmp2 componentsJoinedByString: @"\n"];
	[tmp2 release];
	[av addButtonWithTitle: NSLocalizedString(@"Dismiss", @"Dismiss")];
	[av show];
	[av release];
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [tables count];
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"SQLTableCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"SQLTableCell"];
	}
	cell.text = [[tables objectAtIndex: indexPath.row] objectAtIndex: 0];
	
	return cell;
	
}

@end

