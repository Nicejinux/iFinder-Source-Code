//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFPasteController.h"

@implementation MFPasteController

@synthesize mainController = mainController;

// super

- (id) init {
    
	self = [super init];
	
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460)];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.allowsSelection = NO;
	[self.view addSubview: tableView];
	
	self.title = @"Paste Queue";
    
	pasteQueue = [[NSMutableArray alloc] init];
	[pasteQueue addObjectsFromArray: [[NSUserDefaults standardUserDefaults] arrayForKey: @"MFPasteQueue"]];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: self action: @selector(showActions)] autorelease];
	
	sheet = [[UIActionSheet alloc] init];
	sheet.title = @"Manage items in queue";
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	sheet.delegate = self;
	sheet.cancelButtonIndex = 5;
	[sheet addButtonWithTitle: @"Copy"];
	[sheet addButtonWithTitle: @"Cut"];
	[sheet addButtonWithTitle: @"Symlink"];
	[sheet addButtonWithTitle: @"Compress"];
	[sheet addButtonWithTitle: @"Clear queue"];
	[sheet addButtonWithTitle: @"Cancel"];
    
	return self;
	
}

- (void) dealloc {
    
	[tableView release];
	tableView = nil;
	[pasteQueue release];
	pasteQueue = nil;
	[sheet release];
	sheet = nil;
	
	[super dealloc];
	
}

// self

- (void) addFile: (MFFile *) aFile {
    
	[pasteQueue addObject: [aFile fullPath]];
	[[NSUserDefaults standardUserDefaults] setObject: pasteQueue forKey: @"MFPasteQueue"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[tableView reloadData];
	
}

- (void) showActions {
    
	[sheet showInView: self.view];
	
}

// UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (int) index {
    
	if (index == 0) {
        
		[[UIPasteboard generalPasteboard] setStrings: pasteQueue];
		[[UIPasteboard pasteboardWithName: @"MFPasteboard" create: YES] setString: @"COPY"];
		
	} else if (index == 1) {
        
		[[UIPasteboard generalPasteboard] setStrings: pasteQueue];
		[[UIPasteboard pasteboardWithName: @"MFPasteboard" create: YES] setString: @"CUT"];
		
	} else if (index == 2) {
        
		[[UIPasteboard generalPasteboard] setStrings: pasteQueue];
		[[UIPasteboard pasteboardWithName: @"MFPasteboard" create: YES] setString: @"LINK"];
        
	} else if (index == 3) {
        
        MFCompressController *compressController = [[MFCompressController alloc] initWithFiles: pasteQueue];
        compressController.mainController = self.mainController;
        [compressController presentFrom: self];
        [compressController release];
        
	} else if (index == 4) {
        
		NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
		for (int i = 0; i < [pasteQueue count]; i++) {
			[indexPaths addObject: [NSIndexPath indexPathForRow: i inSection: 0]];
		}
		[pasteQueue removeAllObjects];
		[tableView deleteRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationRight];
		[indexPaths release];
		[[NSUserDefaults standardUserDefaults] setObject: pasteQueue forKey: @"MFPasteQueue"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else if (index == 5) {
        
		return;
		
	}
	
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
}

- (void) tableView: (UITableView *) theTableView commitEditingStyle: (UITableViewCellEditingStyle) style forRowAtIndexPath: (NSIndexPath *) indexPath {
    
	[pasteQueue removeObjectAtIndex: indexPath.row];
	[theTableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationRight];
	[[NSUserDefaults standardUserDefaults] setObject: pasteQueue forKey: @"MFPasteQueue"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
	return [pasteQueue count];
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
	
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"cell"];
	}
	cell.text = [pasteQueue objectAtIndex: indexPath.row];
	
	return cell;
	
}

@end

