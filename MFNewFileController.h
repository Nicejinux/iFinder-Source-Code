//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFModalController.h"

@interface MFNewFileController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    UITableView *tableView;
    UISwitch *isDir;
    UITextField *fileName;
    NSString *path;
    id mainController;
    UISegmentedControl *type;
    UITextField *link;
    NSString *dest;
}

@property (retain) id mainController;
@property (retain) NSString *path;

- (void) doneButtonPressed;

@end

