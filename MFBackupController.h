//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MFFile.h"
#import "MFFileType.h"
#import "MFFileManager.h"
#import "MFLoadingView.h"
#import "MFFileViewerController.h"
#import "MFThread.h"



@interface MFBackupController : MFModalController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UISearchBarDelegate, UIActionSheetDelegate, MFThreadDelegate, MFMailComposeViewControllerDelegate> {
	NSString *currentDirectory;
	NSMutableArray *files;
	NSMutableArray *searchResult;
	UITableView *tableView;
	UISearchBar *searchBar;
	UIToolbar *toolbar;
	MFFileManager *fileManager;
    MFLoadingView *loadingView;
	int fileIndex;
    UIActionSheet *restore;
    NSString *restorestring;
    MFThread *restorethread;
    UIActionSheet *share;
    MFMailComposeViewController *mailController;
    int mailme;
}

-(void) makebackup;
-(void) sharebackup;

@property (retain) MFFileManager *fileManager;

@end
