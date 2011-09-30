//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import <UIKit/UIKit.h>
#import "MFFile.h"
#import "MFFileViewerController.h"
#import "MFMainController.h"
#import "MFPasswordController.h"
#import "MFLoadingView.h"

@interface MFAppDelegate: NSObject <UIApplicationDelegate, MFPasswordControllerDelegate, UIAlertViewDelegate> {
	UIWindow *mainWindow;
	MFMainController *mc;
	MFPasswordController *pc;
	UINavigationController *passwordController;
	UINavigationController *mainController;
        MFFileViewerController *fileViewerController;
    UIAlertView *passwordAlert;
    NSString *pasteboard;
    NSDictionary *dictionary;
    MFLoadingView *loadingView;
}

//@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

