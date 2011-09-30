#import "SQLiteManager.h"

@implementation SQLiteManager

- (id) initWithFile: (NSString *) path {

	self = [super init];
	
	file = [path retain];
	rows = [[NSMutableArray alloc] init];
	
	return self;
	
}

- (NSArray *) executeSQLQuery: (NSString *) query {

	sqlite3_open ([file UTF8String], &sql_db);
	sql_status = SQLITE_ROW;
	sql_statement = NULL;
	[rows removeAllObjects];
	sqlite3_prepare (sql_db, [query UTF8String], -1, &sql_statement, NULL);
	NSMutableArray *sql_row = [[NSMutableArray alloc] init];
	
	while (sql_status == SQLITE_ROW) {
	
		sql_status = sqlite3_step (sql_statement);
		int sql_columns = sqlite3_data_count (sql_statement);
		for (int i = 0; i < sql_columns; i++) {
			const unsigned char *sql_text = sqlite3_column_text (sql_statement, i);
			if (sql_text) {
				[sql_row addObject: [NSString stringWithUTF8String: (char *)sql_text]];
			}
		}
		
		[rows addObject: [sql_row copy]];
		[sql_row removeAllObjects];

	}
	
	[sql_row release];
	sqlite3_close (sql_db);
	sql_db = NULL;
	sql_statement = NULL;
	if ([rows count] > 0) {
		[rows removeLastObject];
	}
	
	return [rows copy];
	
}
	
- (void) dealloc {

	[rows release];
	rows = nil;
	
	[super dealloc];
	
}

@end

