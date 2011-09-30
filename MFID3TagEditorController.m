//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFID3TagEditorController.h"

@implementation MFID3TagEditorController

@synthesize mainController = mainController;

// self

- (id) initWithTag: (MFID3Tag *) aTag {
    
	self = [super init];
    
	self.navigationItem.title = @"Editing metadata";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)] autorelease];
	id3tag = [aTag retain];
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 416) style: UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview: tableView];
	[tableView release];
    
	title = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	title.delegate = self;
	title.text = [id3tag songTitle];
    
	artist = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	artist.delegate = self;
	artist.text = [id3tag artist];
    
	album = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	album.delegate = self;
	album.text = [id3tag album];
    
	year = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	year.delegate = self;
	year.text = [id3tag year];
    
	genre = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	genre.delegate = self;
	genre.text = [id3tag genre];
    
	lyricist = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	lyricist.delegate = self;
	lyricist.text = [id3tag lyricist];
    
	language = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	language.delegate = self;
	language.text = [id3tag language];
    
	comments = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
	comments.delegate = self;
	comments.text = [id3tag comments];
    
	return self;
    
}

- (void) done {
    
	[id3tag setSongTitle: title.text];
	[id3tag setArtist: artist.text];
	[id3tag setAlbum: album.text];
	[id3tag setYear: year.text];
	[id3tag setGenre: genre.text];
	[id3tag setLyricist: lyricist.text];
	[id3tag setLanguage: language.text];
	[id3tag setComments: comments.text];
    
	[self.mainController reloadAudioMetadata];
    
	[self close];
    
}


// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
    
}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
	return 8;
    
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"ID3Cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ID3Cell"];
	}
    
	int idx = indexPath.row;
    
	if (idx == 0) {
		cell.textLabel.text = @"Title";
		cell.accessoryView = title;
	} else if (idx == 1) {
		cell.textLabel.text = @"Artist";
		cell.accessoryView = artist;
	} else if (idx == 2) {
		cell.textLabel.text = @"Album";
		cell.accessoryView = album;
	} else if (idx == 3) {
		cell.textLabel.text = @"Year";
		cell.accessoryView = year;
	} else if (idx == 4) {
		cell.textLabel.text = @"Genre";
		cell.accessoryView = genre;
	} else if (idx == 5) {
		cell.textLabel.text = @"Lyricist";
		cell.accessoryView = lyricist;
	} else if (idx == 6) {
		cell.textLabel.text = @"Language";
		cell.accessoryView = language;
	} else if (idx == 7) {
		cell.textLabel.text = @"Comments";
		cell.accessoryView = comments;
	}
    
	return cell;
    
}


// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    
	[textField resignFirstResponder];
    
	return YES;
    
}

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {
    
	return UIInterfaceOrientationIsPortrait (orientation);
    
}

- (void) dealloc {
    
	[title release];
	title = nil;
	[artist release];
	artist = nil;
	[album release];
	album = nil;
	[year release];
	year = nil;
	[genre release];
	genre = nil;
	[lyricist release];
	lyricist = nil;
	[comments release];
	comments = nil;
	[language release];
	language = nil;
	[id3tag release];
	id3tag = nil;
    
	[super dealloc];
    
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"Registering for keyboard events");
    
	// Register for the events
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector (keyboardDidShow:)
     name: UIKeyboardDidShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector (keyboardDidHide:)
     name: UIKeyboardDidHideNotification
     object:nil];
    
	// Setup content size
	tableView.contentSize = CGSizeMake(320, 460);
    
	//Initially the keyboard is hidden
	keyboardVisible = NO;
}

-(void) keyboardDidShow: (NSNotification *)notif {
	NSLog(@"Keyboard is visible");
	// If keyboard is visible, return
	if (keyboardVisible) {
		NSLog(@"Keyboard is already visible. Ignore notification.");
		return;
	}
    tableView.scrollEnabled = YES;
    if([genre isFirstResponder]){ 
        // Get the size of the keyboard.
        NSDictionary* info = [notif userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        // Save the current location so we can restore
        // when keyboard is dismissed
        offset = tableView.contentOffset;
        
        // Resize the scroll view to make room for the keyboard
        CGRect viewFrame = CGRectMake (0, 0, 320, 460);
        viewFrame.size.height -= keyboardSize.height;
        tableView.frame = viewFrame;
        tableView.contentSize = CGSizeMake(320, 400);
        
//        CGRect textFieldRect = [uploadPath frame];
        CGRect rect = CGRectMake(0, 265, 320, 460);
        [tableView scrollRectToVisible:rect animated:YES];
    }else if([lyricist isFirstResponder]){ 
        // Get the size of the keyboard.
        NSDictionary* info = [notif userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        // Save the current location so we can restore
        // when keyboard is dismissed
        offset = tableView.contentOffset;
        
        // Resize the scroll view to make room for the keyboard
        CGRect viewFrame = CGRectMake (0, 0, 320, 460);
        viewFrame.size.height -= keyboardSize.height;
        tableView.frame = viewFrame;
        tableView.contentSize = CGSizeMake(320, 460);
        
        //        CGRect textFieldRect = [uploadPath frame];
        CGRect uploadrect = CGRectMake(0, 310, 320, 400);
        [tableView scrollRectToVisible:uploadrect animated:YES];
    }else if([language isFirstResponder]){ 
        // Get the size of the keyboard.
        NSDictionary* info = [notif userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        // Save the current location so we can restore
        // when keyboard is dismissed
        offset = tableView.contentOffset;
        
        // Resize the scroll view to make room for the keyboard
        CGRect viewFrame = CGRectMake (0, 0, 320, 460);
        viewFrame.size.height -= keyboardSize.height;
        tableView.frame = viewFrame;
        tableView.contentSize = CGSizeMake(320, 460);
        
        //        CGRect textFieldRect = [uploadPath frame];
        CGRect uploadrect = CGRectMake(0, 350, 320, 400);
        [tableView scrollRectToVisible:uploadrect animated:YES];
    }else if([comments isFirstResponder]){ 
        // Get the size of the keyboard.
        NSDictionary* info = [notif userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        // Save the current location so we can restore
        // when keyboard is dismissed
        offset = tableView.contentOffset;
        
        // Resize the scroll view to make room for the keyboard
        CGRect viewFrame = CGRectMake (0, 0, 320, 460);
        viewFrame.size.height -= keyboardSize.height;
        tableView.frame = viewFrame;
        tableView.contentSize = CGSizeMake(320, 460);
        
        //        CGRect textFieldRect = [uploadPath frame];
        CGRect uploadrect = CGRectMake(0, 350, 320, 400);
        [tableView scrollRectToVisible:uploadrect animated:YES];
    }else{
        NSDictionary* info = [notif userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        // Save the current location so we can restore
        // when keyboard is dismissed
        offset = tableView.contentOffset;
        
        // Resize the scroll view to make room for the keyboard
        CGRect viewFrame = CGRectMake (0, 0, 320, 460);
        viewFrame.size.height -= keyboardSize.height;
        tableView.frame = viewFrame;
        tableView.contentSize = CGSizeMake(320, 240);
    }
	NSLog(@"ao fim");
	// Keyboard is now visible
    keyboardVisible = YES;
    tableView.scrollEnabled = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
	// Is the keyboard already shown
	if (!keyboardVisible) {
		NSLog(@"Keyboard is already hidden. Ignore notification.");
		return;
	}
    
	// Reset the frame scroll view to its original value
	tableView.frame = CGRectMake(0, 0, 320, 460);
    
	// Reset the scrollview to previous location
	tableView.contentOffset = offset;
    
	// Keyboard is no longer visible
	keyboardVisible = NO;
    tableView.scrollEnabled = YES;
	tableView.contentSize = CGSizeMake(320, 460);
}


@end

