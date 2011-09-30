//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import "MFSortCriteria.h"


@implementation MFSortCriteria

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

- (void)viewDidLoad
{
    seteuid(501);
    selected = [[NSUserDefaults standardUserDefaults] integerForKey:@"SortCriteria"];
    seteuid(0);
    [super viewDidLoad];
}

- (id) init {
    self = [super init];
    self.title = NSLocalizedString(@"Sort Criteria", @"Sort Criteria");
    
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.scrollEnabled = YES;
	[self.view addSubview: tableView];
    
    return self;
}

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

- (int) numberOfSectionsInTableView: (UITableView *) theTableView {
    
	return 1;
	
}

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
	int nRows;
	
	if (section == 0) {
        
		nRows = 5;
		
	}
    
	return nRows;
    
}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {
    
	NSString *title;
    
	if (section == 0) {
		title = NSLocalizedString(@"Select Sort Criteria", @"Select Sort Criteria");
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
            
			cell.text = NSLocalizedString(@"Sort By Name", @"Sort By Name");
            if (selected == 0){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 1) {
            
			cell.text = NSLocalizedString(@"Sort by Type", @"Sort by Type");
            if (selected == 1){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 2) {
            
			cell.text = NSLocalizedString(@"Sort by Size", @"Sort by Size");
            if (selected == 2){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 3) {
            
			cell.text = NSLocalizedString(@"Sort by Creation Date", @"Sort by Creation Date");
            if (selected == 3){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
			
		} else if (indexPath.row == 4) {
            
			cell.text = NSLocalizedString(@"Sort by Last Modification Date", @"Sort by Last Modification Date");
            if (selected == 4){
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

    /*NSIndexPath *lastindex = [[NSIndexPath alloc] initWithIndex:selected];
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastindex]; 
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {   
        oldCell.accessoryType = UITableViewCellAccessoryNone;   
    }*/
    seteuid(501);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:indexPath.row forKey:@"SortCriteria"];
    [prefs synchronize];
    seteuid(0);
    
	/*if (indexPath.section == 0) {
		if (indexPath.row == 0) {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:0];     
            if (newCell.accessoryType == UITableViewCellAccessoryNone) 
            {   
                newCell.accessoryType = UITableViewCellAccessoryCheckmark;  
            }
		} else if (indexPath.row == 1) {
            
			
		} else if (indexPath.row == 2) {
            
			
		} else if (indexPath.row == 3) {
            
			
		} else if (indexPath.row == 4) {
            
			
		}
	}*/
    for (id algoPath in [tableView indexPathsForVisibleRows]){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:algoPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if(algoPath == indexPath){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    }
    
}

@end
