//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFModalController.h"

@interface MFSFTPUploadController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *tableView;
	UITextField *localFile;
	UITextField *remoteFile;
	id mainController;
}

@property (assign) id mainController;

- (void) done;

@end

