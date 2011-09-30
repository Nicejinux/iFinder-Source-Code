//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "MFFile.h"
#import "MFSQLTablesController.h"

@interface MFSQLViewer: UIView <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
        MFFile *database;
        MFSQLTablesController *tablesController;
        SQLiteManager *sqlManager;
        UITableView *tableView;
        UISearchBar *sqlCommand;
        NSMutableArray *result;
        id mainViewController;
}

@property (retain) id mainViewController;

- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame;
- (void) showTables;

@end
