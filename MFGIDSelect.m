//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import "MFGIDSelect.h"


@implementation MFGIDSelect


@synthesize changed = _changed;
@synthesize custom = _custom;
@synthesize selected = _selected;

- (void)dealloc
{
    [tableView release];
	tableView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.scrollEnabled = YES;
    //tableView.contentSize = CGSizeMake(320, 500);
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 45)] autorelease];
	footer.backgroundColor = [UIColor clearColor];
	tableView.tableFooterView = footer;
	[self.view addSubview: tableView];
    
    /*custom = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, 150, 30)];
     custom.placeholder = NSLocalizedString(@"Enter file mode", @"Enter file mode");
     if (!selected == -2 && !selected == 0 && !selected == 1 && !selected == 25 && !selected == 64 && !selected == 65 && !selected == 75 && !selected == 99 && !selected == 501){
     custom.text = [NSString stringWithFormat:@"%i", selected];
     } else {
     custom.text = @"";
     }
     custom.delegate = self;
     custom.textAlignment = UITextAlignmentLeft;
     custom.autocapitalizationType = UITextAutocapitalizationTypeNone;
     custom.autocorrectionType = UITextAutocorrectionTypeNo;
     custom.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;*/
}

-(void) viewDidAppear:(BOOL)animated{
    //[tableView scrollToRowAtIndexPath:scroll atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (id) initWithGID:(NSString *) GID{
    selectu = GID;
    
    self = [super init];
    self.title = NSLocalizedString(@"Group ID", @"Group ID");
    
    scroll = [[NSIndexPath alloc] init];
    
    return self;
}

- (int) numberOfSectionsInTableView: (UITableView *) theTableView {
    
	return 1;
	
}

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
	return 70;
    
}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {
    
	NSString *title;
    
	if (section == 0) {
		title = nil;
	}
	
	return title;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MFSCCell"];
	if (cell == nil) {
		//cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MFSCCell"];
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"MFSCCell"] autorelease];
	}
	
	if (indexPath.section == 0) {
        
		if (indexPath.row == 0) {
            
			cell.text = @"nobody";
            if ([selectu isEqualToString:@"nobody"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 1) {
            
			cell.text = @"nogroup";
            if ([selectu isEqualToString:@"nogroup"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 2) {
            
			cell.text = @"wheel";
            if ([selectu isEqualToString:@"wheel"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 3) {
            
			cell.text = @"daemon";
            if ([selectu isEqualToString:@"daemon"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 4) {
            
			cell.text = @"kmem";
            if ([selectu isEqualToString:@"kmem"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 5) {
            
			cell.text = @"sys";
            if ([selectu isEqualToString:@"sys"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 6) {
            
			cell.text = @"tty";
            if ([selectu isEqualToString:@"tty"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 7) {
            
			cell.text = @"operator";
            if ([selectu isEqualToString:@"operator"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 8) {
            
			cell.text = @"mail";
            if ([selectu isEqualToString:@"mail"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 9) {
            
			cell.text = @"bin";
            if ([selectu isEqualToString:@"bin"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 10) {
            
			cell.text = @"procview";
            if ([selectu isEqualToString:@"procview"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 11) {
			cell.text = @"procmod";
            if ([selectu isEqualToString:@"procmod"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 12) {
        
			cell.text = @"owner";
            if ([selectu isEqualToString:@"owner"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 13) {
            
			cell.text = @"everyone";
            if ([selectu isEqualToString:@"everyone"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 14) {
            
			cell.text = @"group";
            if ([selectu isEqualToString:@"group"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 15) {
            
			cell.text = @"staff";
            if ([selectu isEqualToString:@"staff"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 16) {
            
			cell.text = @"_wireless";
            if ([selectu isEqualToString:@"_wireless"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 17) {
            
			cell.text = @"_lp";
            if ([selectu isEqualToString:@"_lp"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 18) {
            
			cell.text = @"_postfix";
            if ([selectu isEqualToString:@"_postfix"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 19) {
            
			cell.text = @"_postdrop";
            if ([selectu isEqualToString:@"_postdrop"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 20) {
            
			cell.text = @"certusers";
            if ([selectu isEqualToString:@"certusers"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 21) {
            
			cell.text = @"_keytabusers";
            if ([selectu isEqualToString:@"_keytabusers"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 22) {
            
			cell.text = @"utmp";
            if ([selectu isEqualToString:@"utmp"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 23) {
            
			cell.text = @"authedusers";
            if ([selectu isEqualToString:@"authedusers"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 24) {
            
			cell.text = @"interactusers";
            if ([selectu isEqualToString:@"interactusers"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 25) {
            
			cell.text = @"netusers";
            if ([selectu isEqualToString:@"netusers"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 26) {
            
			cell.text = @"consoleusers";
            if ([selectu isEqualToString:@"consoleusers"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 27) {
            
			cell.text = @"_mcxalr";
            if ([selectu isEqualToString:@"_mcxalr"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 28) {
            
			cell.text = @"_pcastagent";
            if ([selectu isEqualToString:@"_pcastagent"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 29) {
            
			cell.text = @"_pcastserver";
            if ([selectu isEqualToString:@"_pcastserver"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 30) {
            
			cell.text = @"_serialnumberd";
            if ([selectu isEqualToString:@"_serialnumberd"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 31) {
            
			cell.text = @"_devdocs";
            if ([selectu isEqualToString:@"_devdocs"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 32) {
            
			cell.text = @"_sandbox";
            if ([selectu isEqualToString:@"_sandbox"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 33) {
            
			cell.text = @"localaccounts";
            if ([selectu isEqualToString:@"localaccounts"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 34) {
            
			cell.text = @"netaccounts";
            if ([selectu isEqualToString:@"netaccounts"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 35) {
            
			cell.text = @"_securityd";
            if ([selectu isEqualToString:@"_securityd"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 36) {
            
			cell.text = @"_mdnsresponder";
            if ([selectu isEqualToString:@"_mdnsresponder"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 37) {
            
			cell.text = @"_uucp";
            if ([selectu isEqualToString:@"_uucp"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 38) {
            
			cell.text = @"_ard";
            if ([selectu isEqualToString:@"_ard"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 39) {
            
			cell.text = @"dialer";
            if ([selectu isEqualToString:@"dialer"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 40) {
            
			cell.text = @"network";
            if ([selectu isEqualToString:@"network"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 41) {
            
			cell.text = @"_www";
            if ([selectu isEqualToString:@"_www"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 42) {
            
			cell.text = @"_cvs";
            if ([selectu isEqualToString:@"_cvs"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 43) {
            
			cell.text = @"_svn";
            if ([selectu isEqualToString:@"_svn"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 44) {
            
			cell.text = @"_mysql";
            if ([selectu isEqualToString:@"_mysql"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 45) {
            
			cell.text = @"_sshd";
            if ([selectu isEqualToString:@"_sshd"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 46) {
            
			cell.text = @"_qtss";
            if ([selectu isEqualToString:@"_qtss"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 47) {
            
			cell.text = @"_mailman";
            if ([selectu isEqualToString:@"_mailman"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 48) {
            
			cell.text = @"_appserverusr";
            if ([selectu isEqualToString:@"_appserverusr"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 49) {
            
			cell.text = @"admin";
            if ([selectu isEqualToString:@"admin"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 50) {
            
			cell.text = @"_appserveradm";
            if ([selectu isEqualToString:@"_appserveradm"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 51) {
            
			cell.text = @"_clamav";
            if ([selectu isEqualToString:@"_clamav"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 52) {
            
			cell.text = @"_amavisd";
            if ([selectu isEqualToString:@"_amavisd"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 53) {
            
			cell.text = @"_jabber";
            if ([selectu isEqualToString:@"_jabber"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 54) {
            
			cell.text = @"_xgridcontroller";
            if ([selectu isEqualToString:@"_xgridcontroller"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 55) {
            
			cell.text = @"_xgridagent";
            if ([selectu isEqualToString:@"_xgridagent"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 56) {
            
			cell.text = @"_appowner";
            if ([selectu isEqualToString:@"_appowner"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 57) {
            
			cell.text = @"_windowserver";
            if ([selectu isEqualToString:@"_windowserver"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 58) {
            
			cell.text = @"_spotlight";
            if ([selectu isEqualToString:@"_spotlight"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 59) {
            
			cell.text = @"accessibility";
            if ([selectu isEqualToString:@"accessibility"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 60) {
            
			cell.text = @"_tokend";
            if ([selectu isEqualToString:@"_tokend"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 61) {
            
			cell.text = @"_securityagent";
            if ([selectu isEqualToString:@"_securityagent"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 62) {
            
			cell.text = @"_calendar";
            if ([selectu isEqualToString:@"_calendar"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 63) {
            
			cell.text = @"_teamsserver";
            if ([selectu isEqualToString:@"_teamsserver"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 64) {
            
			cell.text = @"_update_sharing";
            if ([selectu isEqualToString:@"_update_sharing"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 65) {
            
			cell.text = @"_installer";
            if ([selectu isEqualToString:@"_installer"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 66) {
            
			cell.text = @"_atsserver";
            if ([selectu isEqualToString:@"_atsserver"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 67) {
            
			cell.text = @"_lpadmin";
            if ([selectu isEqualToString:@"_lpadmin"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 68) {
            
			cell.text = @"_unknown";
            if ([selectu isEqualToString:@"_unknown"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 69) {
            
			cell.text = @"mobile";
            if ([selectu isEqualToString:@"mobile"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                scroll = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		}
        
    }
    return cell;
    
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if (indexPath.row == 0) {
        _selected = -2;
    } else if (indexPath.row == 1) {
        _selected = -1;
    } else if (indexPath.row == 2) {
        _selected = 0;
    } else if (indexPath.row == 3) {
        _selected = 1;
    } else if (indexPath.row == 4) {
        _selected = 2;
    } else if (indexPath.row == 5) {
        _selected = 3;
    } else if (indexPath.row == 6) {
        _selected = 4;
    } else if (indexPath.row == 7) {
        _selected = 5;
    } else if (indexPath.row == 8) {
        _selected = 6;
    } else if (indexPath.row == 9) {
        _selected = 7;
    } else if (indexPath.row == 10) {
        _selected = 8;
    } else if (indexPath.row == 11) {
        _selected = 9;
    } else if (indexPath.row == 12) {
        _selected = 10;
    } else if (indexPath.row == 13) {
        _selected = 12;
    } else if (indexPath.row == 14) {
        _selected = 16;
    } else if (indexPath.row == 15) {
        _selected = 20;
    } else if (indexPath.row == 16) {
        _selected = 25;
    } else if (indexPath.row == 17) {
        _selected = 26;
    } else if (indexPath.row == 18) {
        _selected = 27;
    } else if (indexPath.row == 19) {
        _selected = 28;
    } else if (indexPath.row == 20) {
        _selected = 29;
    } else if (indexPath.row == 21) {
        _selected = 30;
    } else if (indexPath.row == 22) {
        _selected = 45;
    } else if (indexPath.row == 23) {
        _selected = 50;
    } else if (indexPath.row == 24) {
        _selected = 51;
    } else if (indexPath.row == 25) {
        _selected = 52;
    } else if (indexPath.row == 26) {
        _selected = 53;
    } else if (indexPath.row == 27) {
        _selected = 54;
    } else if (indexPath.row == 28) {
        _selected = 55;
    } else if (indexPath.row == 29) {
        _selected = 56;
    } else if (indexPath.row == 30) {
        _selected = 58;
    } else if (indexPath.row == 31) {
        _selected = 59;
    } else if (indexPath.row == 32) {
        _selected = 60;
    } else if (indexPath.row == 33) {
        _selected = 61;
    } else if (indexPath.row == 34) {
        _selected = 62;
    } else if (indexPath.row == 35) {
        _selected = 64;
    } else if (indexPath.row == 36) {
        _selected = 65;
    } else if (indexPath.row == 37) {
        _selected = 66;
    } else if (indexPath.row == 38) {
        _selected = 67;
    } else if (indexPath.row == 39) {
        _selected = 68;
    } else if (indexPath.row == 40) {
        _selected = 69;
    } else if (indexPath.row == 41) {
        _selected = 70;
    } else if (indexPath.row == 42) {
        _selected = 72;
    } else if (indexPath.row == 43) {
        _selected = 73;
    } else if (indexPath.row == 44) {
        _selected = 74;
    } else if (indexPath.row == 45) {
        _selected = 75;
    } else if (indexPath.row == 46) {
        _selected = 76;
    } else if (indexPath.row == 47) {
        _selected = 78;
    } else if (indexPath.row == 48) {
        _selected = 79;
    } else if (indexPath.row == 49) {
        _selected = 80;
    } else if (indexPath.row == 50) {
        _selected = 81;
    } else if (indexPath.row == 51) {
        _selected = 82;
    } else if (indexPath.row == 52) {
        _selected = 83;
    } else if (indexPath.row == 53) {
        _selected = 84;
    } else if (indexPath.row == 54) {
        _selected = 85;
    } else if (indexPath.row == 55) {
        _selected = 86;
    } else if (indexPath.row == 56) {
        _selected = 87;
    } else if (indexPath.row == 57) {
        _selected = 88;
    } else if (indexPath.row == 58) {
        _selected = 89;
    } else if (indexPath.row == 59) {
        _selected = 90;
    } else if (indexPath.row == 60) {
        _selected = 91;
    } else if (indexPath.row == 61) {
        _selected = 92;
    } else if (indexPath.row == 62) {
        _selected = 93;
    } else if (indexPath.row == 63) {
        _selected = 94;
    } else if (indexPath.row == 64) {
        _selected = 95;
    } else if (indexPath.row == 65) {
        _selected = 96;
    } else if (indexPath.row == 66) {
        _selected = 97;
    } else if (indexPath.row == 67) {
        _selected = 98;
    } else if (indexPath.row == 68) {
        _selected = 99;
    } else if (indexPath.row == 69) {
        _selected = 501;
    } else {
        _selected = [_custom.text intValue];
    }
    
    NSString *u = [NSString stringWithFormat:@"%i", _selected];
    [u writeToFile:@"/private/var/mobile/Library/iFinder/qnub" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    _changed = @"YES";
    
    for (id algoPath in [tableView indexPathsForVisibleRows]){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:algoPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if(algoPath == indexPath){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
}


@end
