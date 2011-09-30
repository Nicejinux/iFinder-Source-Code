//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>
#import "MFCompressController.h"
#import "MFModalController.h"
#import "MFFile.h"

@interface MFPasteController: MFModalController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
	UIActionSheet *sheet;
	NSMutableArray *pasteQueue;
    id mainController;
}

@property (retain) id mainController;

- (void) addFile: (MFFile *) aFile;
- (void) showActions;

@end

