//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import <UIKit/UIKit.h>
#import "MFModalController.h"

@interface MFNewBookmark : MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    UITableView *tableView;
    UITextField *BookmarkName;
    UITextField *BookmarkPath;
    NSString *filename;
    NSString *filepath;
	id mainController;
    
}
@property (retain) id mainController;
- (id) initWithPath: (NSString *) Path;
- (void) saveButtonPressed;

@end
