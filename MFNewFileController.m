//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFNewFileController.h"

@implementation MFNewFileController

@synthesize mainController = mainController;
@synthesize path = path;

// self

- (id) init {

	self = [super init];
	
	self.title = NSLocalizedString(@"New", @"New");

	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") style:UIBarButtonItemStyleDone target: self action: @selector(doneButtonPressed)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];

	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.dataSource = self;
	tableView.delegate = self;
        tableView.scrollEnabled = NO;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: tableView];
        [tableView release];
       
	isDir = [[UISwitch alloc] initWithFrame: CGRectMake (0, 8, 100, 30)];
	isDir.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	isDir.on = NO;

	fileName = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, 160, 30)];
	fileName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	fileName.placeholder = NSLocalizedString(@"Type name here", @"Type name here");
	fileName.delegate = self;
    fileName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    fileName.autocorrectionType = UITextAutocorrectionTypeNo;
    
    type = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects: NSLocalizedString(@"File", @"File"), NSLocalizedString(@"Directory", @"Directory"), NSLocalizedString(@"Link", @"Link"), nil]];
    type.frame = CGRectMake (0, 0, 300, 45);
    type.selectedSegmentIndex = 1;
//    [type addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];
    [type addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview: type];
    
    link = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, 160, 30)];
    link.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    link.placeholder = NSLocalizedString(@"Destination", @"Destination");
    link.delegate = self;
    link.autocapitalizationType = UITextAutocapitalizationTypeNone;
    link.autocorrectionType = UITextAutocorrectionTypeNo;
    link.enabled = NO;
       
	return self;

}
/*- (void) setSelectedSegmentIndex:(NSInteger)toValue {
    if (type.selectedSegmentIndex == 0) {
        isDir.on = NO;
    } else if (type.selectedSegmentIndex == 1) {
        isDir.on = YES;
    } else if (type.selectedSegmentIndex == 2) {
        [super setSelectedSegmentIndex:toValue];        
    }
}*/

- (void) pickOne:(id)sender{
	if (type.selectedSegmentIndex == 0) {
        isDir.on = NO;
        dest = @"File";
        [tableView reloadData];
    } else if (type.selectedSegmentIndex == 1) {
        isDir.on = YES;
        dest = @"Folder";
        [tableView reloadData];
    } else if (type.selectedSegmentIndex == 2) {
        link.enabled = YES;
        dest = @"Link";
        [tableView reloadData];
    }
}

// self

- (void) doneButtonPressed {
    if (type.selectedSegmentIndex == 0) {
        [[[self mainController] fileManager] createFile: [self.path stringByAppendingPathComponent: fileName.text] isDirectory: NO];
    } else if (type.selectedSegmentIndex == 1) {
        [[[self mainController] fileManager] createFile: [self.path stringByAppendingPathComponent: fileName.text] isDirectory: YES];
    } else if (type.selectedSegmentIndex == 2) {
        NSString *to = [NSString stringWithFormat:@"%@/%@", self.path, [fileName text]];
        char *symb = [[NSString stringWithFormat: @"ln -s %@ %@", [link text], to] UTF8String];
        system (symb);
    }
	isDir.on = NO;
	fileName.text = nil;
    link.text = nil;
    dest = nil;
	[[self mainController] reloadDirectory];
	[self close];

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
    if ([dest isEqualToString:@"Link"]){
    	return 4;
    } else {
        return 3;
    }

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFNFCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFNFCell"];
	}

    if ([dest isEqualToString:@"Link"]){
    	if (indexPath.row == 0) {
            
            cell.text = NSLocalizedString(@"Name", @"Name");
            cell.accessoryView = fileName;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //[fileName release];
            
        } else if (indexPath.row == 1) {
            
            //		cell.text = type;
            [cell.contentView addSubview: type];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //[type release];
            
        } else if (indexPath.row == 2) {
            
            cell.text = NSLocalizedString(@"Path", @"Path");
            cell.accessoryView = link;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textAlignment = UITextAlignmentLeft;
            //[link release];
            
        } else if (indexPath.row == 3) {
            
            cell.text = NSLocalizedString(@"Create", @"Create");
            cell.textAlignment = UITextAlignmentCenter;
            
        }
    } else {
        if (indexPath.row == 0) {
            
            cell.text = NSLocalizedString(@"Name", @"Name");
            cell.accessoryView = fileName;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //[fileName release];
            
        } else if (indexPath.row == 1) {
            
            //		cell.text = type;
            cell.accessoryView = type;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //[type release];
            
        } else if (indexPath.row == 2) {
            
            cell.text = NSLocalizedString(@"Create", @"Create");
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryView = nil;
            cell.textAlignment = UITextAlignmentCenter;
            
        }
    }

	return cell;

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if ([dest isEqualToString:@"Link"]){
        if (indexPath.row == 0) {
        
            [fileName isFirstResponder];
        
        }else if (indexPath.row == 2) {
        
            [link isFirstResponder];
        
        } else if (indexPath.row == 3) {

            [self doneButtonPressed];

        }
    } else {
        if (indexPath.row == 0) {
            
            [fileName isFirstResponder];
            
        } else if (indexPath.row == 2) {
            
            [self doneButtonPressed];
            
        }
    }

}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];

	return YES;

}

- (void) dealloc {
    [fileName release];
    [type release];
    [link release];
    dest = nil;
}

@end

