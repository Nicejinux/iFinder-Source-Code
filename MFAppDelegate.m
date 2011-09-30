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
    /*system("cp -r '/private/var/mobile/Library/Preferences/.GlobalPreferences.plist' '//private/var/root/Library/Preferences/.GlobalPreferences.plist'");
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    if ([locale rangeOfString:@"es"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/es.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else if ([locale rangeOfString:@"en"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/en-US.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else {
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/en-US.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    }*/
    /*NSString *finalPath = @"/private/var/mobile/Library/Preferences/.GlobalPreferences.plist";
    dictionary = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    NSString *locale = [[dictionary objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if ([locale rangeOfString:@"es"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/es.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else if ([locale rangeOfString:@"en"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/en-US.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else if ([locale rangeOfString:@"he"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/he.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else if ([locale rangeOfString:@"de"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/de.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else if ([locale rangeOfString:@"ko"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/ko.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else {
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/en-US.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    }*/
    
    /*NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *validating = [prefs stringForKey:@"MFValidated"];
    UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
    NSString *quinto = [deviceUDID substringToIndex:[deviceUDID length]-39];
    NSString *once = [deviceUDID substringWithRange:NSMakeRange(10, 1)];
    NSString *diez = [deviceUDID substringWithRange:NSMakeRange(25, 1)];
    NSString *uhuh = [deviceUDID substringWithRange:NSMakeRange(11, 7)];
    NSString *uji = [deviceUDID substringWithRange:NSMakeRange(1, 30)];
    NSString *ulio = [deviceUDID substringWithRange:NSMakeRange(35, 2)];
    NSString *acue = [deviceUDID substringWithRange:NSMakeRange(9, 19)];
    NSString *check = [NSString stringWithFormat:@"%@A%@U%@8%@faiaso%@28ds%@vayq%@%@",quinto,deviceUDID,once,diez, uhuh, uji, ulio, acue];
    if ([check isEqualToString:validating]) {
	} else {
        loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeValidating];
        [loadingView show];
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        NSString *sabelo = [NSString stringWithFormat:@"http://smsancel.host22.com/check.php?UDID=%@",deviceUDID];
        [request setURL:[NSURL URLWithString:sabelo]];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
        NSString *html = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];              
        NSScanner *scanner = [NSScanner scannerWithString:html];
        NSString *token = nil;
        [scanner scanString:@"<RESPONSE>" intoString:NULL];
        [scanner scanUpToString:@"</RESPONSE>" intoString:&token];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if ([token isEqualToString:@"success"]){
            [prefs setObject:check forKey:@"MFValidated"];
            [prefs synchronize];
            [loadingView hide];
            UIAlertView *alert2 = [[UIAlertView alloc]
                                   initWithTitle:@"App Validated!!"
                                   message:@"Thanks for buying iFinder"
                                   delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"OK", nil];
            [alert2 show];
            [alert2 release];
        } else {
            [loadingView hide];
            UIAlertView *alert2 = [[UIAlertView alloc]
                                   initWithTitle:@"iFinder!!"
                                   message:@"iFinder could not be validated, please purchase it from Cydia Store. If you think that this is a mistake, please contact developer."
                                   delegate:nil
                                   cancelButtonTitle:@"OK",
                                   otherButtonTitles:nil];
            alert2.tag = 7;
            [alert2 show];
            [alert2 release];
        }
        
    }*/
}

// UIApplicationDelegate
- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) options {    
    //system("cp -r '/private/var/mobile/Library/Preferences/.GlobalPreferences.plist' '//private/var/root/Library/Preferences/.GlobalPreferences.plist'");
    //[[NSUserDefaults standardUserDefaults] stringForKey: @"AppleLocale"];
    //NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    /*NSString *finalPath = @"/private/var/mobile/Library/Preferences/.GlobalPreferences.plist";
    dictionary = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    //NSString *locale = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    NSString *locale = [[dictionary objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if ([locale rangeOfString:@"es"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/es.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else if ([locale rangeOfString:@"en"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/en-US.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else if ([locale rangeOfString:@"he"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/he.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else if ([locale rangeOfString:@"de"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/de.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else if ([locale rangeOfString:@"ko"].location !=NSNotFound){
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/ko.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    } else {
        system("cp -r '/var/stash/Applications.pwn/iFinder.app/en-US.lproj/Localizable.strings' '/var/stash/Applications.pwn/iFinder.app/en.lproj/'");
    }*/
    
    
    /*system("dpkg --get-selections > /a");
    NSString *a = [NSString stringWithContentsOfFile:@"/a" encoding: NSUTF8StringEncoding error: NULL];
    if ([a rangeOfString:@"org.thebigboss.ifinder"].location == NSNotFound){
        system("rm -rf /a");
        [[UIApplication sharedApplication] terminate];
    } else{ 
        system("rm -rf /a");
    }*/
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
   
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *validating = [prefs stringForKey:@"MFValidated"];
    UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
    NSString *quinto = [deviceUDID substringToIndex:[deviceUDID length]-39];
    NSString *once = [deviceUDID substringWithRange:NSMakeRange(10, 1)];
    NSString *diez = [deviceUDID substringWithRange:NSMakeRange(25, 1)];
    NSString *uhuh = [deviceUDID substringWithRange:NSMakeRange(11, 7)];
    NSString *uji = [deviceUDID substringWithRange:NSMakeRange(1, 30)];
    NSString *ulio = [deviceUDID substringWithRange:NSMakeRange(35, 2)];
    NSString *acue = [deviceUDID substringWithRange:NSMakeRange(9, 19)];
    NSString *check = [NSString stringWithFormat:@"%@A%@U%@8%@faiaso%@28ds%@vayq%@%@",quinto,deviceUDID,once,diez, uhuh, uji, ulio, acue];
    if ([check isEqualToString:validating]) {
	} else {
        loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeValidating];
        [loadingView show];
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        NSString *sabelo = [NSString stringWithFormat:@"http://ifinder.itaysoft.com/verification.php?UDID=%@",deviceUDID];
        [request setURL:[NSURL URLWithString:sabelo]];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
        NSString *html = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];              
        NSScanner *scanner = [NSScanner scannerWithString:html];
        NSString *token = nil;
        [scanner scanString:@"<RESPONSE>" intoString:NULL];
        [scanner scanUpToString:@"</RESPONSE>" intoString:&token];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if ([token isEqualToString:@"success"]){
            [prefs setObject:check forKey:@"MFValidated"];
            [prefs synchronize];
            [loadingView hide];
            UIAlertView *alert2 = [[UIAlertView alloc]
                                   initWithTitle:NSLocalizedString(@"App Validated!!", @"App Validated!!")
                                   message:NSLocalizedString(@"Thanks for buying iFinder", @"Thanks for buying iFinder")
                                   delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
            [alert2 show];
            [alert2 release];
        } else {
            [loadingView hide];
            UIAlertView *alert2 = [[UIAlertView alloc]
                                   initWithTitle:NSLocalizedString(@"iFinder!!", @"iFinder!!")
                                   message:NSLocalizedString(@"iFinder could not be validated, please purchase it from Cydia Store. If you think that this is a mistake, please contact developer.", @"iFinder could not be validated, please purchase it from Cydia Store. If you think that this is a mistake, please contact developer.")
                                   delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
            alert2.tag = 7;
            [alert2 show];
            [alert2 release];
        }

    }

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
//	NSLocale* curentLocale = [NSLocale currentLocale];
    //BOOL retVal;
	//if ([[url scheme] isEqualToString: @"ifinder"] || [[url scheme] isEqualToString: @"if"]) {
        if (!url) {  return NO; }
		MFFile *file = [[MFFile alloc] init];
		//[[NSFileManager defaultManager] moveItemAtPath: [url path] toPath: [@"/private/var/mobile/Documents" stringByAppendingPathComponent: [[url path] lastPathComponent]] error: NULL];
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
		//retVal = YES;
		
	//}
	
//	return retVal;
    
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
