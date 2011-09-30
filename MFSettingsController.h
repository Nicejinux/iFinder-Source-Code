//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>
#import "DBSession.h"
#import "DBLoginController.h"
#import "MFModalController.h"
#import "MFAboutController.h"
#import "MFSortCriteria.h"
#import "MFSortOrder.h"
#import "MFThemeSelect.h"
#import <MessageUI/MessageUI.h>

@protocol MFSettingsControllerDelegate;

@interface MFSettingsController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DBLoginControllerDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate> {
	UITableView *tableView;
	UISwitch *passwordEnabled;
	UITextField *passwordString;
	UITextField *homestring;
	UISwitch *usetrash;
	UITextField *fontSize;
	UITextField *uploadPath;
	MFAboutController *aboutController;
    MFSortCriteria *sortCriteria;
    MFSortOrder *sortOrder;
    MFThemeSelect *themeSelect;
    BOOL keyboardVisible;
    CGPoint offset;
    UITextField *activeField;
    UISegmentedControl *theme;
    UITextField *criteria;
    UITextField *order;
    id <MFSettingsControllerDelegate> mainController;
    UITextField *selectedtheme;
    
    MFMailComposeViewController *mailController;
}

- (void) done;
-(void) keyboardDidShow:(NSNotification *) notification;

@property (retain) id mainController;

@end

@protocol MFSettingsControllerDelegate

- (void) settingsControllerDidClose: (MFSettingsController *) settingsController;

@end
