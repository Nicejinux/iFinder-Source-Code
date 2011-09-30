//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>

@protocol MFPasswordControllerDelegate;

@interface MFPasswordController: UIViewController <UITableViewDataSource, UITextFieldDelegate> {
	id <MFPasswordControllerDelegate> delegate;
	UITableView *tableView;
	UITextField *textField;
	NSString *password;
}

@property (retain) id <MFPasswordControllerDelegate> delegate;

- (void) done;

@end

@protocol MFPasswordControllerDelegate

- (void) passwordControllerAcceptedPassword;

@end

