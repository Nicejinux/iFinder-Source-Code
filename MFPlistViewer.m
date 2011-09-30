//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFPlistViewer.h"

@implementation MFPlistViewer

// self

- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame {
    
	self = [super initWithFrame: theFrame];
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	plist = [file retain];
	keys = [[NSMutableArray alloc] init];
	values = [[NSMutableArray alloc] init];
	types = [[NSMutableArray alloc] init];
    
	root = [[NSMutableDictionary alloc] initWithContentsOfFile: [plist fullPath]];
	if ([root count] == 0) {
		root = [[NSMutableArray alloc] initWithContentsOfFile: [plist fullPath]];
	}
	
	tableView = [[UITableView alloc] initWithFrame: theFrame];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizingMask = self.autoresizingMask;
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 45)] autorelease];
	footer.backgroundColor = [UIColor clearColor];
	tableView.tableFooterView = footer;
	[self addSubview: tableView];
	
	[self loadRoot];
    
	return self;
	
}

- (void) loadRoot {
    
	[self loadNode: root];
	
}

- (void) loadNode: (id) node {
    
 	if ([node isKindOfClass: [NSDictionary class]]) {
        
		[self loadDictionary: node];
        
	} else if ([node isKindOfClass: [NSArray class]]) {
        
		[self loadArray: node];
        
	}
    
}

- (void) loadDictionary: (NSDictionary *) dict {
    
	[keys removeAllObjects];
	[values removeAllObjects];
	[types removeAllObjects];
    
	[keys addObjectsFromArray: [dict allKeys]];
	for (int i = 0; i < [keys count]; i++) {
		[values addObject: [dict valueForKey:[keys objectAtIndex: i]]];
		if ([[dict valueForKey: [keys objectAtIndex: i]] isKindOfClass: [NSArray class]]) {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeArray]];
		} else if ([[dict valueForKey: [keys objectAtIndex: i]] isKindOfClass: [NSDictionary class]]) {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeDictionary]];
		} else if ([[dict valueForKey: [keys objectAtIndex: i]] isKindOfClass: [NSString class]]) {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeString]];
		} else if ([[dict valueForKey: [keys objectAtIndex: i]] isKindOfClass: [NSNumber class]]) {
            NSString *className = NSStringFromClass([[dict valueForKey: [keys objectAtIndex: i]] class]);
            if ([className isEqualToString:@"NSCFNumber"]) {
                [types addObject: [NSNumber numberWithInt: MFPlistNodeTypeInteger]];
            } else if  ([className isEqualToString:@"NSCFBoolean"]) {
                [types addObject: [NSNumber numberWithInt: MFPlistNodeTypeBool]];
            }                                        
//            [types addObject: [NSNumber numberWithInt: MFPlistNodeTypeInteger]];
		} else if ([[dict valueForKey: [keys objectAtIndex: i]] isKindOfClass: [NSDate class]]) {
            [types addObject: [NSNumber numberWithInt: MFPlistNodeTypeDate]];
        } else if ([[dict valueForKey: [keys objectAtIndex: i]] isKindOfClass: [NSData class]]) {
            [types addObject: [NSNumber numberWithInt: MFPlistNodeTypeData]];
        } else {
//            [types addObject: [NSNumber numberWithInt: MFPlistNodeTypeBool]];
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeSimple]];
        }
	}
	currentNodeType = MFPlistNodeTypeDictionary;
    
	[tableView reloadData];
    
}

- (void) loadArray: (NSArray *) array {
    
	[keys removeAllObjects];
	[values removeAllObjects];
	[types removeAllObjects];
    
	[values addObjectsFromArray: array];
	for (int i = 0; i < [values count]; i++) {
		[keys addObject: [NSString stringWithFormat: @"%i", i]];
		if ([[values objectAtIndex: i] isKindOfClass: [NSArray class]]) {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeArray]];
		} else if ([[values objectAtIndex: i] isKindOfClass: [NSDictionary class]]) {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeDictionary]];
		} else {
			[types addObject: [NSNumber numberWithInt: MFPlistNodeTypeSimple]];
		}
	}
	currentNodeType = MFPlistNodeTypeArray;
    
	[tableView reloadData];
    
}

// super

- (void) dealloc {
    
	[root release];
	root = nil;
	[tableView release];
	tableView = nil;
	[keys release];
	keys = nil;
	[values release];
	values = nil;
	[types release];
	types = nil;
    
	[super dealloc];
    
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
    
	if ([[types objectAtIndex: indexPath.row] intValue] == MFPlistNodeTypeArray) {
		[self loadArray: [values objectAtIndex: indexPath.row]];
	} else if ([[types objectAtIndex: indexPath.row] intValue] == MFPlistNodeTypeDictionary) {
		[self loadDictionary: [values objectAtIndex: indexPath.row]];
	}
    
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
	return [keys count];
    
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"PlistCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"PlistCell"];
	}
	
	NSString *node;
	NSString *key = [keys objectAtIndex: indexPath.row];
	id value = [values objectAtIndex: indexPath.row];
	MFPlistNodeType type = [[types objectAtIndex: indexPath.row] intValue];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
	if (type == MFPlistNodeTypeDictionary) {
		node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? @"%@" : @"%@."), key];
        cell.textLabel.text = node;
        cell.detailTextLabel.text = @"DICT";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if (type == MFPlistNodeTypeArray) {
		node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? @"%@" : @"%@."), key];
        cell.textLabel.text = node;
        cell.detailTextLabel.text = @"ARRAY";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if (type == MFPlistNodeTypeString) {
        node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? @"%@" : @"%@."), key];
        cell.textLabel.text = node;
        cell.detailTextLabel.text = [value description];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (type == MFPlistNodeTypeSimple) {
        node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? @"%@" : @"%@."), key];
        //if ([[value description] isKindOfClass:[_Bool Class]]) {
        UITextField *field = [UITextField alloc];
        field = [[UITextField alloc] initWithFrame: CGRectMake (0, 20, 150, 30)];
        field.text = [value description];
        field.delegate = self;
        field.textAlignment = UITextAlignmentRight;
        field.autocapitalizationType = UITextAutocapitalizationTypeNone;
        field.autocorrectionType = UITextAutocorrectionTypeNo;
        field.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.tag = indexPath.row;
        cell.accessoryView = field;
        cell.text = node;
        cell.accessoryType = UITableViewCellAccessoryNone;   
    } else if (type == MFPlistNodeTypeInteger) {
        node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? @"%@" : @"%@."), key];
        //if ([[value description] isKindOfClass:[_Bool Class]]) {
        UITextField *field = [UITextField alloc];
        field = [[UITextField alloc] initWithFrame: CGRectMake (0, 20, 150, 30)];
        field.text = [value description];
        field.delegate = self;
        field.textAlignment = UITextAlignmentRight;
        field.autocapitalizationType = UITextAutocapitalizationTypeNone;
        field.autocorrectionType = UITextAutocorrectionTypeNo;
        field.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.tag = indexPath.row;
            cell.accessoryView = field;
        /*} else {
            UISwitch *boolswitch = [[UISwitch alloc] init];
            boolswitch.on = [[value description] boolValue];
            cell.accessoryView = boolswitch;
        }*/
        cell.text = node;
        //cell.detailTextLabel.text = [value description];
        cell.accessoryType = UITableViewCellAccessoryNone;        
	} else if (type == MFPlistNodeTypeBool) {
        node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? @"%@" : @"%@."), key];
        UISwitch *boolswitch = [[UISwitch alloc] init];
        boolswitch.on = [[value description] boolValue];
        boolswitch.tag = indexPath.row;
        [boolswitch addTarget:self action:@selector(valuechangedbool:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = boolswitch;
        cell.text = node;
        //cell.detailTextLabel.text = [value description];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (type == MFPlistNodeTypeData) {
    } else if (type == MFPlistNodeTypeDate) {
        node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? @"%@" : @"%@."), key];
        cell.textLabel.text = node;
        //cell.detailTextLabel.text = [value description];
        cell.detailTextLabel.text = [value description];
        cell.accessoryType = UITableViewCellAccessoryNone;
	} /*else {
        node = [NSString stringWithFormat: (currentNodeType == MFPlistNodeTypeDictionary ? @"%@;" : @"%@."), key];
        cell.textLabel.text = node;
        cell.detailTextLabel.text = [value description];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }*/
//	cell.textLabel.font = [UIFont fontWithName: @"CourierNewPS-ItalicMT" size: 15.0];
    
	return cell;
    
}

-(void) valuechangedbool: (id)sender{
    if (![sender isKindOfClass: [UISwitch class]])
    {
        //error handling
        return;
    }
    UISwitch* theSwitch = (UISwitch*) sender;
    BOOL theSwitchIsOn = theSwitch.on;
    NSString *trash;
    if (theSwitch.on){
        trash = @"YES";
    } else {
        trash = @"NO";
    }

    NSString *a = [NSString stringWithFormat:@"%i %@", theSwitch.tag, trash];
    [a writeToFile:@"/var/root/af" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    [root replaceObjectAtIndex:theSwitch.tag withObject:theSwitch];
    [root writeToFile:@"/var/root/af2.plist" atomically:YES];
}

@end

