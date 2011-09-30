//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import <UIKit/UIKit.h>


@interface MFUIDSelect : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    UITableView *tableView;
    NSUInteger _selected;
    NSString *_changed;
    UITextField *_custom;
    NSString *selectu;
}

- (id) initWithUID: (NSString *) UID;

@property (nonatomic, readwrite) NSUInteger selected;
@property (nonatomic, retain) NSString *changed;
@property (nonatomic, retain) UITextField *custom;

@end
