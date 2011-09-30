//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFAppDelegate.h"
#include <dlfcn.h>

@implementation MFAppDelegate
-(void)applicationDidBecomeActive:(UIApplication *)application{

}

// UIApplicationDelegate
- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) options {    

    mainWindow = [[UIWindow alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
	[mainWindow makeKeyAndVisible];

	mc = [[MFMainController alloc] init];
	mainController = [[UINavigationController alloc] initWithRootViewController: mc];
	mainController.navigationBar.barStyle = UIBarStyleBlack;
	seteuid(501);
	if ([[NSUserDefaults standardUserDefaults] boolForKey: @"MFPasswordEnabled"]) {

	        pc = [[MFPasswordController alloc] init];
	        pc.delegate = self;
	//passwordController = [[UINavigationController alloc] initWithRootViewController: pc];

        UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"App Locked", @"App Locked") message:@"\n\n\n"
                                                       delegate:self cancelButtonTitle: NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
        passwordAlert.tag = 1;

        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,45,260,25)];
        passwordLabel.font = [UIFont systemFontOfSize:16];
        passwordLabel.textColor = [UIColor whiteColor];
        passwordLabel.backgroundColor = [UIColor clearColor];
        passwordLabel.shadowColor = [UIColor blackColor];
        passwordLabel.shadowOffset = CGSizeMake(0,-1);
        passwordLabel.textAlignment = UITextAlignmentCenter;
        passwordLabel.text = NSLocalizedString(@"Password required", @"Password required");
        [passwordAlert addSubview:passwordLabel];

        /*UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"passwordfield" ofType:@"png"]]];
 passwordImage.frame = CGRectMake(11,79,262,31);
 [passwordAlert addSubview:passwordImage];*/

        UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,25)];
        passwordField.font = [UIFont systemFontOfSize:18];
        //passwordField.backgroundColor = [UIColor whiteColor];
        passwordField.secureTextEntry = YES;
        passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
        passwordField.delegate = self;
        [passwordField setTag:10250];
        [passwordField becomeFirstResponder];
        [passwordAlert addSubview:passwordField];

//[passwordAlert setTransform:CGAffineTransformMakeTranslation(0,109)];
        passwordField.borderStyle = UITextBorderStyleRoundedRect;
        [passwordAlert show];
        [passwordAlert release];
        [passwordField release];
        //[passwordImage release];
        [passwordLabel release];
    
    } else {
	
        [mainWindow addSubview: mainController.view];
    
    }

    [UIPasteboard pasteboardWithName: @"MFPasteboard" create: YES];

    //Dropbox Upload Path
    //NSString *upload = @"/Public/iFinder";
    //[[NSUserDefaults standardUserDefaults] setObject: upload forKey: @"MFDropboxUploadPath"];
    seteuid(0);
    return YES;

}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1 & actionSheet.tag==1)
    {
        UITextField *pass = (UITextField*)[actionSheet viewWithTag:10250];
        NSString *text2 = [NSString stringWithFormat:(@"%@", [pass text])];
        if([text2 isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey: @"MFPasswordString"]]){
            [mainWindow addSubview: mainController.view];
        }
        else{
            UIAlertView *wrong = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Wrong Password", @"Wrong Password") message:NSLocalizedString(@"The password you entered is wrong", @"The password you entered is wrong")
                                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"Try Again", @"Try Again") otherButtonTitles:NSLocalizedString(@"Exit", @"Exit"),nil];
            wrong.tag = 2;
            [wrong show];
            [wrong release];
        }
    }
    if (buttonIndex == 0 & actionSheet.tag==2)
    {
        UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"App Locked", @"App Locked") message:@"\n\n\n"
                                                               delegate:self cancelButtonTitle: NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
        passwordAlert.tag = 1;

        
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,45,260,25)];
        passwordLabel.font = [UIFont systemFontOfSize:16];
        passwordLabel.textColor = [UIColor whiteColor];
        passwordLabel.backgroundColor = [UIColor clearColor];
        passwordLabel.shadowColor = [UIColor blackColor];
        passwordLabel.shadowOffset = CGSizeMake(0,-1);
        passwordLabel.textAlignment = UITextAlignmentCenter;
        passwordLabel.text = @"Password required";
        [passwordAlert addSubview:passwordLabel];
        
        UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,25)];
        passwordField.font = [UIFont systemFontOfSize:18];
        passwordField.secureTextEntry = YES;
        passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
        passwordField.delegate = self;
        [passwordField setTag:10250];
        [passwordField becomeFirstResponder];
        [passwordAlert addSubview:passwordField];
        
        passwordField.borderStyle = UITextBorderStyleRoundedRect;
        [passwordAlert show];
        [passwordAlert release];
        [passwordField release];
        [passwordLabel release];
    }
    if (buttonIndex == 1 & actionSheet.tag==2)
    {
        [[UIApplication sharedApplication] terminate];
    }
    if (buttonIndex == 0 & actionSheet.tag==1)
    {
        [[UIApplication sharedApplication] terminate];
    }
    if (buttonIndex == 0 & actionSheet.tag==7) {
        [[UIApplication sharedApplication] terminate];
    }
    if (buttonIndex == 1 & actionSheet.tag==7) {
        [[UIApplication sharedApplication] terminate];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
        if (!url) {  return NO; }
		MFFile *file = [[MFFile alloc] init];
        char *cmd = [[NSString stringWithFormat:@"cp -r '%@' '/private/var/mobile/Documents'", [url path]] UTF8String];
        system(cmd);
		file.path = @"/private/var/mobile/Documents";
		file.name = [[url path] lastPathComponent];
		file.type = [MFFileType fileTypeForName: file.name];
        [mc loadDirectory: @"/private/var/mobile/Documents"];
		fileViewerController = [[MFFileViewerController alloc] initWithFile: file];
		[file release];
    seteuid(501);
		[fileViewerController presentFrom: [[NSUserDefaults standardUserDefaults] boolForKey: @"MFPasswordEnabled"] ? passwordController : mainController];
    seteuid(0);
        return YES;
    
}


- (void) applicationDidEnterBackground: (id) sender {

	//exit (0);
    [@"" writeToFile:@"/var/mobile/Library/iFinder/stc/" atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
	
}

-(void) applicationWillTerminate:(UIApplication *)application{
    [@"" writeToFile:@"/var/mobile/Library/iFinder/stc/" atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

// MFPasswordControllerDelegate

- (void) passwordControllerAcceptedPassword {

	[passwordController presentModalViewController: mainController animated: YES];
	
}

// super

- (void) dealloc {

	[mainController release];
	mainController = nil;
	[mainWindow release];
	mainWindow = nil;
        [fileViewerController release];
        fileViewerController = nil;

	[super dealloc];

}

@end
