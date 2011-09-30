//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFModalController.h"
#import "SQLiteManager.h"

@interface MFSQLTablesController: MFModalController <UITableViewDelegate, UITableViewDataSource> {
	SQLiteManager *manager;
	UITableView *tableView;
	NSArray *tables;
}

- (id) initWithSQLManager: (SQLiteManager *) sqlMgr;

@end

