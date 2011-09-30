//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import <UIKit/UIKit.h>


@interface MFSortOrder : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView;
    NSInteger selected;
}

@end
