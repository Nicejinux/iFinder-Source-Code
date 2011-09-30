#import <sqlite3.h>
#import <Foundation/Foundation.h>

@interface SQLiteManager: NSObject {
	sqlite3 	*sql_db;
	sqlite3_stmt	*sql_statement;
	int		sql_status;
	NSMutableArray	*rows;
	NSString	*file;
}

- (id) initWithFile: (NSString *) path;
- (NSArray *) executeSQLQuery: (NSString *) query;

@end

