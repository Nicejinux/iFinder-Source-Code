//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFFileSharingController.h"

#import "HTTPServer.h"
#import "MyHTTPConnection.h"

@implementation MFFileSharingController

// super

- (id) init {

	self = [super init];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	//daemon = [[MongooseDaemon alloc] init];
	state = NO;
	self.title = NSLocalizedString(@"File Sharing", @"File Sharing");
	
	port = [[UITextField alloc] initWithFrame: CGRectMake (150, 30, 140, 30)];
    port.textAlignment = UITextAlignmentCenter;
    port.borderStyle = UITextBorderStyleRoundedRect;
	port.enabled = YES;
	port.delegate = self;
	port.text = @"8080";
	port.placeholder = NSLocalizedString(@"Type port number", @"Type port number");
	
	portLabel = [[UILabel alloc] initWithFrame: CGRectMake (40, 20, 120, 48)];
    portLabel.backgroundColor = [UIColor clearColor];
	portLabel.text = NSLocalizedString(@"Server port:", @"Server port:");
	portLabel.font = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
	[self.view addSubview: portLabel];
    [self.view addSubview: port];
    
	stateLabel = [[UILabel alloc] initWithFrame: CGRectMake (40, 120, 240, 48)];
    stateLabel.backgroundColor = [UIColor clearColor];
	stateLabel.text = NSLocalizedString(@"File Sharing is disabled", @"File Sharing is disabled");
	stateLabel.font = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
	[self.view addSubview: stateLabel];
	
	IPLabel = [[UILabel alloc] initWithFrame: CGRectMake (40, 220, 240, 48)];
    IPLabel.backgroundColor = [UIColor clearColor];
	IPLabel.text = nil;
	IPLabel.font = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
	[self.view addSubview: IPLabel];
	
	toggleStateButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	toggleStateButton.frame = CGRectMake (40, 320, 240, 48);
	[toggleStateButton addTarget: self action: @selector(toggleState) forControlEvents: UIControlEventTouchUpInside];
	[toggleStateButton setTitle: NSLocalizedString(@"Enable File Sharing", @"Enable File Sharing") forState: UIControlStateNormal];
	[self.view addSubview: toggleStateButton];
	
    NSString *root = @"/";
    httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
    
	return self;
	
}

- (void) dealloc {

	//[daemon release];
	//daemon = nil;
	[stateLabel release];
	stateLabel = nil;
	[portLabel release];
	portLabel = nil;
	[port release];
	port = nil;
	[IPLabel release];
	IPLabel = nil;
	[toggleStateButton release];
	toggleStateButton = nil;
    [httpServer release];
	
	[super dealloc];
	
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return UIInterfaceOrientationIsPortrait(orientation);
	
}

// self
-(NSString*)getAddress {
	char iphone_ip[255];
	strcpy(iphone_ip,"127.0.0.1"); // if everything fails
	NSHost* myhost =[NSHost currentHost];
	if (myhost)
	{
		NSArray *addresses = [[NSHost currentHost] addresses];
        
        for (NSString *anAddress in addresses) {
            if (![anAddress hasPrefix:@"127"] && [[anAddress componentsSeparatedByString:@"."] count] == 4) {
//                stringAddress = anAddress;
                strcpy(iphone_ip, [anAddress cStringUsingEncoding: NSISOLatin1StringEncoding]);
                break;
            } else {
                strcpy(iphone_ip, [@"IPv4 address not available" cStringUsingEncoding: NSISOLatin1StringEncoding]);
            }
        }
	}
	return [NSString stringWithFormat:@"%s",iphone_ip]; 
}

- (void) toggleState {

	if (port.text == nil || [port.text isEqualToString: @""]) {
	
		[[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", @"Error") message: NSLocalizedString(@"You must enter a valid port number", @"You must enter a valid port number") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];
		
		return;
		
	}

	state = !state;
	//port.enabled = !port.enabled;
	if (state) {
	
		//[daemon startMongooseDaemon: port.text];
        
        [httpServer setPort:[port.text intValue]];
        NSError *error;
		if(![httpServer start:&error])
		{
			NSLog(@"Error starting HTTP Server: %@", error);
		}
        
		stateLabel.text = [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"Serving on port", @"Serving on port"), port.text];
		IPLabel.text = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"IP address", @"IP address"), [self getAddress]];
        
		[toggleStateButton setTitle: NSLocalizedString(@"Stop server", @"Stop server") forState: UIControlStateNormal];
		
	} else {
	
		//[daemon stopMongooseDaemon];
        [httpServer stop];
        
		stateLabel.text = NSLocalizedString(@"Server is off", @"Server is off");
		IPLabel.text = nil;
		[toggleStateButton setTitle: NSLocalizedString(@"Start server", @"Start server") forState: UIControlStateNormal];
		
	}
	
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

	[textField resignFirstResponder];
	
	return YES;
	
}

@end

