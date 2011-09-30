//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>
#import "MFFile.h"
#import "MFFileType.h"
#import "MFFileManager.h"
#import "MFFileSharingController.h"
#import "MFFileViewerController.h"

#import "MFNewBookmark.h"


@interface MFBookmarksController: MFModalController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate, UISearchBarDelegate, MFFileViewerControllerDelegate> {
	NSString *currentDirectory;
	NSMutableArray *files;
	NSMutableArray *searchResult;
	UITableView *tableView;
	UISearchBar *searchBar;
	MFFileManager *fileManager;
	MFFileViewerController *fileViewerController;
	int fileIndex;
    NSMutableArray *bookmarks;
	UIActionSheet *deletefile;
	id mainController;
    
    MFNewBookmark *newbookmark;
    NSMutableArray *bookmarksnames;
}

@property (retain) MFFileManager *fileManager;
@property (retain) id mainController;

- (NSString *) currentDirectory; 
- (void) leftButtonPressed;
- (void) rightButtonPressed;
- (void) loadDirectory: (NSString *) directory;
- (void) reloadDirectory;
- (void) addBookmark;
- (void) reloadDataTable;

- (void) openfile: (NSString *) FilePath;

@end

