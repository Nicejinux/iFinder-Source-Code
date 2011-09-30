//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFModalController.h"
#import "MFLoadingView.h"
#import "MFFileManager.h"
#import "DropboxSDK.h"

#import "MFFileViewerController.h"
#import "EGORefreshTableHeaderView.h"
//////////

@interface MFDropboxController: MFModalController <UITableViewDelegate, UITableViewDataSource, DBLoginControllerDelegate, MFFileManagerDelegate> {
	NSMutableArray *files;
	MFLoadingView *loadingView;
	UITableView *tableView;
	NSString *currentDirectory;
	DBLoginController *loginController;
	id mainController;
    
//    UITableViewCell *footer;
    
	EGORefreshTableHeaderView *refreshHeaderView;
	BOOL _reloading;
}

@property (retain) id mainController;

/////Pull to Refresh
@property(assign,getter=isReloading) BOOL reloading;
@property(nonatomic,readonly) EGORefreshTableHeaderView *refreshHeaderView;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading2;
- (void)stopLoading2;
- (void)refresh;
//////////////////////

- (void) showLoading;
- (void) hideLoading;

- (void) loadRoot;
- (void) loadMetadata: (NSString *) path;

- (void) downloadFile: (NSString *) path;
- (void) deleteFile: (NSString *) path;
- (void) createDirectory: (NSString *) path;

@end

