//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFModalController.h"

@protocol MFSFTPHostControllerDelegate;

@interface MFSFTPHostController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *tableView;
	UITextField *hostName;
	UITextField *login;
	UITextField *password;
	id <MFSFTPHostControllerDelegate> delegate;
}

@property (retain) id <MFSFTPHostControllerDelegate> delegate;

@end


@protocol MFSFTPHostControllerDelegate <NSObject>

- (void) hostController: (MFSFTPHostController *) controller didReceiveHostInfo: (NSDictionary *) hostInfo;

@end

