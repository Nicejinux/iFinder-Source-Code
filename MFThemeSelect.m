//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import "MFThemeSelect.h"


@implementation MFThemeSelect

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
    selected = [[NSUserDefaults standardUserDefaults] integerForKey:@"MFTheme"];
}

- (id) init {
    self = [super init];
    self.title = NSLocalizedString(@"Theme", @"Theme");
    
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.scrollEnabled = YES;
	[self.view addSubview: tableView];
    
    return self;
}

- (int) numberOfSectionsInTableView: (UITableView *) theTableView {
    
	return 1;
	
}

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
	int nRows;
	
	if (section == 0) {
        
		nRows = 2;
		
	}
    
	return nRows;
    
}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {
    
	NSString *title;
    
	if (section == 0) {
		title = NSLocalizedString(@"Select Theme", @"Select Theme");
	}
	
	return title;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MFSCCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFSCCell"];
	}
	
	if (indexPath.section == 0) {
        
		if (indexPath.row == 0) {
            
			cell.text = @"Crystal";
            if (selected == 0){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 1) {
            
			cell.text = @"Metallen";
            if (selected == 1){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
    seteuid(501);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs initWithUser:@"mobile"];
    [prefs setInteger:indexPath.row forKey:@"MFTheme"];
    [prefs synchronize];
    seteuid(0);
    
    for (id algoPath in [tableView indexPathsForVisibleRows]){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:algoPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if(algoPath == indexPath){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
}


@end
