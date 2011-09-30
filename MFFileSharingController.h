//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>
//#import "MongooseDaemon.h"
#import "MFModalController.h"

@class   HTTPServer;

@interface MFFileSharingController: MFModalController <UITextFieldDelegate> {
//	MongooseDaemon *daemon;
	UILabel *stateLabel;
	UILabel *IPLabel;
	UITextField *port;
	UILabel *portLabel;
	UIButton *toggleStateButton;
	BOOL state;
    HTTPServer *httpServer;
    NSDictionary *addresses;
    NSString *localIP;
    NSString *externalIP;
}

- (void) toggleState;

@end

