//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>
#import <GameKit/GKPeerPickerController.h>
#import "MFFile.h"
#import "MFFileType.h"
#import "MFFileManager.h"
#import "MFBookmarksController.h"
#import "MFDetailsController.h"
#import "MFDropboxController.h"
#import "MFFileSharingController.h"
#import "MFFileViewerController.h"
#import "MFNewFileController.h"
#import "MFPasteController.h"
#import "MFSettingsController.h"
#import "MFLoadingView.h"
#import "MFSFTPController.h"
#import "MFCompressMultipleController.h"
#import "MFBackupController.h"
#import "MWPhotoBrowser.h"
#import "MFCommandController.h"

#import "ReaderViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface MFMainController: UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate, UISearchBarDelegate, MFFileViewerControllerDelegate, MFDetailsControllerDelegate, MFMailComposeViewControllerDelegate, GKPeerPickerControllerDelegate, UIDocumentInteractionControllerDelegate, MFSettingsControllerDelegate> {
	NSString *currentDirectory;
	NSMutableArray *files;
	NSMutableArray *searchResult;
	UITableView *tableView;
	UIActionSheet *sheet;
	UIActionSheet *operations;
    UIActionSheet *operations2;
            UIActionSheet *sharing;
    UIActionSheet *deleteoptions;
        UIActionSheet *deletetrash;
        UIActionSheet *deleteborrar;
	UISearchBar *searchBar;
	UIToolbar *toolbar;
    UIToolbar *toolbar2;
    UIBarButtonItem *btoolbarItem_2;
	MFFileManager *fileManager;
	MFBookmarksController *bookmarksController;
	MFDetailsController *detailsController;
	MFDropboxController *dropboxController;
	MFFileSharingController *fileSharingController;
	MFFileViewerController *fileViewerController;
	MFNewFileController *newFileController;
	MFPasteController *pasteController;
        MFSFTPController *sftpController;
	MFSettingsController *settingsController;
    MFLoadingView *loadingView;
    MFCompressMultipleController *CompressMultiple;
    MFBackupController *backup;
	int fileIndex;
//    NSMutableArray *bookmarks;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *btoolbarItem_4;
    UIBarButtonItem *btoolbarItem_3;
    UIBarButtonItem *btoolbarItem_5;
    UIBarButtonItem *btoolbarItem_6;
    NSString *goingtodelete;
    MFMailComposeViewController *mailController;
    NSArray *mail;
    GKPeerPickerController *picker;
    GKSession *currentSession;
    UIBarButtonItem *sendBlue;
    UIActionSheet *recibBT;
    UIActionSheet *enviarorecibBT;
    UIActionSheet *more;
    int imagenabrir;
    UIActionSheet *desconocido;
    NSString *abrir;
    MFFile *abrirfile;
    UIActionSheet *deb;
    MFCommandController *execute;
    //UITextField *conflictstring;
    UIAlertView *conflict;
    NSMutableArray *CopyArray;
    UITableViewCell *footer;

    
	EGORefreshTableHeaderView *refreshHeaderView;
	BOOL _reloading;
    
    ////COPIAR PEGAR
    NSString *hacer;
    
    UIPasteboard *pasteboard;
    CGPoint pressLocation2;
}

@property (retain) MFFileManager *fileManager;

@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, retain) UITextField *txtMessage;
@property (nonatomic, retain) UIButton *connect;
@property (nonatomic, retain) UIButton *disconnect;

/////Pull to Refresh
@property(assign,getter=isReloading) BOOL reloading;
@property(nonatomic,readonly) EGORefreshTableHeaderView *refreshHeaderView;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
//////////////////////

- (NSString *) currentDirectory; 
- (void) leftButtonPressed;
- (void) rightButtonPressed;
- (void) loadDirectory: (NSString *) directory;
- (void) reloadDirectory;
- (void) createFile;
- (void) showAction;
- (void) showDropbox;
- (void) goHome;
- (void) edit;
- (void) showSettings;
- (void) showSharing;
- (void) showBookmarks;
- (void) pasteFile;
- (void) deletefiles;
- (void) compress;
- (void) actionsfile;
- (void) sendmail;
- (void) showtrash;
- (void) sendBT;

- (void) pdfoptions;
- (void) openfile: (NSString *) FilePath;

@end

