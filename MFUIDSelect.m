//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import "MFUIDSelect.h"


@implementation MFUIDSelect

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
    tableView.contentSize = CGSizeMake(320, 500);
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

- (id) initWithUID:(NSString *) UID{
    selectu = UID;
    
    self = [super init];
    self.title = NSLocalizedString(@"User ID", @"User ID");
    
    return self;
}

- (int) numberOfSectionsInTableView: (UITableView *) theTableView {
    
	return 1;
	
}

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
	int nRows;
	
	if (section == 0) {
        
		nRows = 9;
		
	}
    
	return nRows;
    
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
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MFSCCell"];
	}
	
	if (indexPath.section == 0) {
        
		if (indexPath.row == 0) {
            
			cell.text = @"nobody";
            if ([selectu isEqualToString:@"nobody"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 1) {
            
			cell.text = @"root";
            if ([selectu isEqualToString:@"root"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 2) {
            
			cell.text = @"daemon";
            if ([selectu isEqualToString:@"daemon"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 3) {
            
			cell.text = @"_wireless";
            if ([selectu isEqualToString:@"_wireless"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 4) {
            
			cell.text = @"_securityd";
            if ([selectu isEqualToString:@"_securityd"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 5) {
            
			cell.text = @"_mdnsresponder";
            if ([selectu isEqualToString:@"_mdnsresponder"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 6) {
            
			cell.text = @"_sshd";
            if ([selectu isEqualToString:@"_sshd"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 7) {
            
			cell.text = @"_unknown";
            if ([selectu isEqualToString:@"_unknown"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 8) {
            
			cell.text = @"mobile";
            if ([selectu isEqualToString:@"mobile"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		}/* else if (indexPath.row == 9) {
            
			cell.text = @"Custom";
            cell.accessoryView = custom;
            if (!selected == -2 && !selected == 0 && !selected == 1 && !selected == 25 && !selected == 64 && !selected == 65 && !selected == 75 && !selected == 99 && !selected == 501){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		}*/
        
    }
    return cell;
    
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if (indexPath.row == 0) {
        _selected = -2;
    } else if (indexPath.row == 1) {
        _selected = 0;
    } else if (indexPath.row == 2) {
        _selected = 1;
    } else if (indexPath.row == 3) {
        _selected = 25;
    } else if (indexPath.row == 4) {
        _selected = 64;
    } else if (indexPath.row == 5) {
        _selected = 65;
    } else if (indexPath.row == 6) {
        _selected = 75;
    } else if (indexPath.row == 7) {
        _selected = 99;
    } else if (indexPath.row == 8) {
        _selected = 501;
    } else {
        _selected = [_custom.text intValue];
    }
    
    NSString *u = [NSString stringWithFormat:@"%i", _selected];
    [u writeToFile:@"/private/var/mobile/Library/iFinder/qnua" atomically:NO encoding:NSUTF8StringEncoding error:nil];
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
