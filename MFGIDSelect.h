//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import <UIKit/UIKit.h>


@interface MFGIDSelect :UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    UITableView *tableView;
    NSUInteger _selected;
    NSString *_changed;
    UITextField *_custom;
    NSString *selectu;
    NSIndexPath *scroll;
}

- (id) initWithGID: (NSString *) GID;

@property (nonatomic, readwrite) NSUInteger selected;
@property (nonatomic, retain) NSString *changed;
@property (nonatomic, retain) UITextField *custom;

@end
