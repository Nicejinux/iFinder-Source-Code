//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFFileViewerController.h"
#import "MWPhotoBrowser.h"
#import "ReaderViewController.h"

@implementation MFFileViewerController

@synthesize file = file;
@synthesize delegate = delegate;
@synthesize type = type;

- (void) viewDidLoad{
    desconocido = [[UIActionSheet alloc] init];
    desconocido.title = NSLocalizedString(@"Open With", @"Open With");
    desconocido.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    desconocido.delegate = self;
    desconocido.cancelButtonIndex = 9;
    [desconocido addButtonWithTitle: NSLocalizedString(@"Text Viewer", @"Text Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Archive Viewer", @"Archive Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Web Viewer", @"Web Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Image Viewer", @"Image Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Movie Player", @"Movie Player")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Audio Player", @"Audio Player")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Hex Editor", @"Hex Editor")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Plist Viewer", @"Plist Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"SQL Viewer", @"SQL Viewer")];
    [desconocido addButtonWithTitle: NSLocalizedString(@"Cancel", @"Cancel")];
    
    plistfile= [[UIActionSheet alloc] init];
    plistfile.title = NSLocalizedString(@"Open With", @"Open With");
    plistfile.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    plistfile.delegate = self;
    plistfile.cancelButtonIndex = 2;
    [plistfile addButtonWithTitle: NSLocalizedString(@"Plist Viewer", @"Plist Viewer")];
    [plistfile addButtonWithTitle: NSLocalizedString(@"Text Viewer", @"Text Viewer")];
    [plistfile addButtonWithTitle: NSLocalizedString(@"Cancel", @"Cancel")];
    
    imageoptions= [[UIActionSheet alloc] init];
    imageoptions.title = NSLocalizedString(@"Image Options", @"Image Options");
    imageoptions.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    imageoptions.delegate = self;
    imageoptions.cancelButtonIndex = 2;
    [imageoptions addButtonWithTitle: NSLocalizedString(@"Fit Screen", @"Fit Screen")];
    [imageoptions addButtonWithTitle: NSLocalizedString(@"Print Photo", @"Print Photo")];
    [imageoptions addButtonWithTitle: NSLocalizedString(@"Cancel", @"Cancel")];
    
    restore = [[UIActionSheet alloc] init];
    restore.title = NSLocalizedString(@"Are you sure you want to restore this backup?\nThis can't be undone.", @"Are you sure you want to restore this backup?\nThis can't be undone.");
    restore.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    restore.delegate = self;
    restore.destructiveButtonIndex = 0;
    restore.cancelButtonIndex = 1;
    [restore addButtonWithTitle: NSLocalizedString(@"Restore", @"Restore")];
    [restore addButtonWithTitle: NSLocalizedString(@"Cancel", @"Cancel")];
    
    toolbar = [[UIToolbar alloc] initWithFrame:UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake (0, 480, 320, 48) : CGRectMake (0, 412, 320, 48)];
	flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
    toolbarItem_0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    printdoc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Printer.png"] style:UIBarButtonItemStylePlain target: self action: @selector(printdoc)];
    printweb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Printer.png"] style:UIBarButtonItemStylePlain target: self action: @selector(printweb)];
    toolbarItem_2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(selfdelete)];
    openin = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openother)];
    bookmarfile = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmark)];
    //NSArray *toolbarItems = [NSArray arrayWithObjects: toolbarItem_0, flexItem, toolbarItem_1, nil];
	toolbar.barStyle = UIBarStyleBlack;
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    //[toolbar setItems: toolbarItems animated: YES];
	//[self.view addSubview: toolbar];
}
// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {
    
	BOOL result;
    
	if (landscapeOnly) {
        
		result = (orientation == UIInterfaceOrientationLandscapeRight) || (orientation == UIInterfaceOrientationLandscapeLeft);
        
	} else if (portraitOnly) {
        
		result = (orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown);
        
	} else {
        
		result = YES;
	}
    
	return result;
    
}

- (void) close {
    
	[audioPlayer stop];
//	[moviePlayer stop];
	[self.delegate fileViewerDidFinishViewing: self];
	[super close];
    
}

- (void) dealloc {
    
	[archiveViewer release];
	archiveViewer = nil;
	[audioPlayer release];
	audioPlayer = nil;
	[hexEditor release];
	hexEditor = nil;
	[plistViewer release];
	plistViewer = nil;
	[sqlViewer release];
	sqlViewer = nil;
//	[moviePlayer release];
//	moviePlayer = nil;
	[webView release];
	webView = nil;
	[textView release];
	textView = nil;
	[scrollView release];
	scrollView = nil;
	[imageView release];
	imageView = nil;
    
	[super dealloc];
    
}

// self

- (id) initWithFile: (MFFile *) aFile {
    
	self = [self initWithFile: aFile type: aFile.type];
    
	return self;
    
}

- (id) initWithFile: (MFFile *) aFile type: (NSString *) theType {

	self = [super init];
	
	self.file = aFile;
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = self.file.name;
	self.type = theType;

	if([[self.file fullPath] rangeOfString:@".plist"].location != NSNotFound || [[self.file fullPath] rangeOfString:@".strings"].location != NSNotFound){
        [plistfile showInView: self.view];
    }else{
        if ([self.type isEqualToString: @"text"]) {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(save)];
		rightButton.enabled = NO;
		self.navigationItem.rightBarButtonItem = rightButton;
		[rightButton release];
        
		textView = [[UITextView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 48, 320, 412)];
            seteuid(501);
		textView.font = [UIFont fontWithName: @"courier" size: [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] != 0 ? [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] : 12.0];
            seteuid(0);
		textView.autocorrectionType = UITextAutocorrectionTypeNo;
		textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		textView.delegate = self;
		/*if([[self.file fullPath] rangeOfString:@".plist"].location == NSNotFound){
            textView.text = [NSString stringWithContentsOfFile: [self.file fullPath] encoding: NSASCIIStringEncoding error: NULL];
        }*/ 
        /*if([[self.file fullPath] rangeOfString:@".plist"].location != NSNotFound){
            char *plist = [[NSString stringWithFormat: @"plutil -convert xml1 '%@'", [self.file fullPath]] UTF8String];
            system (plist);
            textView.text = [NSString stringWithContentsOfFile: [self.file fullPath] encoding:NSUTF8StringEncoding error: NULL];
        } else if([[self.file fullPath] rangeOfString:@".strings"].location != NSNotFound){
            char *plist = [[NSString stringWithFormat: @"plutil -convert xml1 '%@'", [self.file fullPath]] UTF8String];
            system (plist);
            textView.text = [NSString stringWithContentsOfFile: [self.file fullPath] encoding:NSUTF8StringEncoding error: NULL];
        } else {*/
            textView.text = [NSString stringWithContentsOfFile: [self.file fullPath] encoding:/*NSUTF8StringEncoding*/ NSASCIIStringEncoding error: NULL];
        //}
            //UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
            search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
            search.autoresizesSubviews = YES;
            search.tintColor = [UIColor colorWithRed: 0.65 green: 0.7 blue: 0.75 alpha: 1.0];
            search.placeholder = NSLocalizedString(@"Search Text", @"Search Text");
            search.showsCancelButton = NO;
            search.delegate = self;
            
            [self.view addSubview: textView];
            [self.view addSubview: search];
        
		landscapeOnly = NO;
		portraitOnly = YES;
        
	} else if ([self.type isEqualToString: @"image"]) {
        
		/*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Options", @"Options") style: UIBarButtonItemStylePlain target: self action: @selector(fit)];
		self.navigationItem.rightBarButtonItem = rightButton;
		[rightButton release];
		self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"imagebg.png"]];
        imagen = [UIImage imageWithContentsOfFile: [self.file fullPath]];
		imageView = [[UIImageView alloc] initWithImage: imagen];
		imageView.backgroundColor = [UIColor clearColor];
        
		scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		scrollView.autoresizingMask = self.view.autoresizingMask;
		scrollView.contentSize = imageView.image.size;
		scrollView.delegate = self;
		scrollView.maximumZoomScale = 6.0;
		scrollView.minimumZoomScale = 0.25;
		[scrollView addSubview: imageView];
		[self.view addSubview: scrollView];*/
        // Browser
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        [photos addObject:[MWPhoto photoWithFilePath:[self.file fullPath]]];
//        [photos addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo2l" ofType:@"jpg"]]];
//        [photos addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo3l" ofType:@"jpg"]]];
//        [photos addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo4l" ofType:@"jpg"]]];
        
        // Create browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
        //[self.view addSubview:browser.view];
        //[browser setInitialPageIndex:0]; // Can be changed if desired
        [self.navigationController pushViewController:browser animated:YES];
        [browser release];
        [photos release];

        
		landscapeOnly = NO;
		portraitOnly = NO;
        
	} else if ([self.type isEqualToString: @"sound"]) {
        
		audioPlayer = [[MFAudioPlayer alloc] initWithFile: self.file];
		audioPlayer.controller = self;
		[self.view addSubview: audioPlayer];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit target: self action: @selector(editId3Tags)] autorelease];
		landscapeOnly = NO;
		portraitOnly = YES;
        
	} else if ([self.type isEqualToString: @"video"]) {
		landscapeOnly = YES;
		portraitOnly = NO;
		MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL: [NSURL fileURLWithPath: [self.file fullPath]]];
        //		moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        moviePlayer.view.frame = CGRectMake (0, 0, 480, 320);
        [self presentMoviePlayerViewControllerAnimated:moviePlayer];
        //            [self.view addSubview: moviePlayer.view];
        //[self.navigationController pushViewController:moviePlayer animated:YES];
        //        moviePlayer.fullscreen = YES;
        moviePlayer.moviePlayer.shouldAutoplay = YES;
        [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        //        [moviePlayer setMovieControlMode:MPMovieControlModeHidden];
        [moviePlayer.moviePlayer setFullscreen: YES animated: YES];
        [moviePlayer.moviePlayer play];
        
	} else if ([self.type isEqualToString: @"package"]) {
        
		archiveViewer = [[MFArchiveViewer alloc] initWithFile: self.file frame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
        archiveViewer.fileViewer = self;
		[self.view addSubview: archiveViewer];
        
		if (! [[self.file.name pathExtension] isEqualToString: @"deb"]) {
			UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: archiveViewer action: @selector(extractAll)];
			self.navigationItem.rightBarButtonItem = rightButton;
			[rightButton release];
		}
        
	} else if ([self.type isEqualToString: @"database"]) {
        
		sqlViewer = [[MFSQLViewer alloc] initWithFile: self.file frame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
		sqlViewer.mainViewController = self;
		[self.view addSubview: sqlViewer];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize target: sqlViewer action: @selector(showTables)] autorelease];
        
		landscapeOnly = NO;
		portraitOnly = NO;
        
	} else if ([self.type isEqualToString: @"plist"]) {
        
		plistViewer = [[MFPlistViewer alloc] initWithFile: self.file frame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
		[self.view addSubview: plistViewer];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize target: plistViewer action: @selector(loadRoot)] autorelease];
        
		landscapeOnly = NO;
		portraitOnly = NO;
        
	} else if ([self.type isEqualToString: @"binary"]) {
        
		hexEditor = [[MFHexEditor alloc] initWithFile: self.file];
		[self.view addSubview: hexEditor];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") style:UIBarButtonItemStyleDone target: hexEditor action: @selector(save)] autorelease];
        
		landscapeOnly = YES;
		portraitOnly = NO;		
        
	} else if ([self.type isEqualToString: @"html"]){
        
		webView = [[UIWebView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake (0, 0, 320, 412) : CGRectMake (0, 0, 320, 420)];
		webView.scalesPageToFit = YES;
		webView.userInteractionEnabled = YES;
		webView.multipleTouchEnabled = YES;
		webView.autoresizingMask = self.view.autoresizingMask;
		[webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: [self.file fullPath]]]];
		[self.view addSubview: webView];
        NSArray *toolbarItems = [NSArray arrayWithObjects: printweb, flexItem, bookmarfile, flexItem, openin, flexItem, toolbarItem_2, nil];
        [toolbar setItems: toolbarItems animated: YES];
        [self.view addSubview: toolbar];
		
		landscapeOnly = NO;
		portraitOnly = YES;
        
	} else if ([self.type isEqualToString:@"pdf"]){
        ReaderDocument *document = [ReaderDocument unarchiveFromFileName:file.fullPath];
        
        if (document == nil) // Create a brand new ReaderDocument object the first time we run
        {
            
            document = [[[ReaderDocument alloc] initWithFilePath:file.fullPath password:nil] autorelease];
        }
        
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        /*readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
         [self presentModalViewController:readerViewController animated:YES];*/
        
        
        //            [options release];
        
        self.navigationController.title = file.name;
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController pushViewController:readerViewController animated:YES];
        [readerViewController release];
    } else if ([self.type isEqualToString: @"doc"] || [self.type isEqualToString: @"xls"] || [self.type isEqualToString: @"ppt"]){
        /*webView = [[UIWebView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
		webView.scalesPageToFit = YES;
		webView.userInteractionEnabled = YES;
		webView.multipleTouchEnabled = YES;
		webView.autoresizingMask = self.view.autoresizingMask;
		[webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: [self.file fullPath]]]];
		[self.view addSubview: webView];
        NSArray *toolbarItems = [NSArray arrayWithObjects: printweb, flexItem, toolbarItem_2, nil];
        [toolbar setItems: toolbarItems animated: YES];
        [self.view addSubview: toolbar];
		
		landscapeOnly = NO;
		portraitOnly = NO;*/
        webView = [[UIWebView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake (0, 0, 320, 412) : CGRectMake (0, 0, 320, 412)];
		webView.scalesPageToFit = YES;
		webView.userInteractionEnabled = YES;
		webView.multipleTouchEnabled = YES;
		webView.autoresizingMask = self.view.autoresizingMask;
		[webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: [self.file fullPath]]]];
		[self.view addSubview: webView];
        NSArray *toolbarItems = [NSArray arrayWithObjects: printweb, flexItem, bookmarfile, flexItem, openin, flexItem, toolbarItem_2, nil];
        [toolbar setItems: toolbarItems animated: YES];
        [self.view addSubview: toolbar];
		
		landscapeOnly = NO;
		portraitOnly = YES;
	} else if ([self.type isEqualToString: @"iFinderBackup"]){
        [restore showInView: self.view];
    }else {
        
		[desconocido showInView: self.view];
		
		landscapeOnly = NO;
		portraitOnly = NO;
    }
    }
    
	return self;
	
}

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (int) index {
    
	if (actionSheet == desconocido) {
        
		if (index == 0) {
            self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(save)];
            rightButton.enabled = NO;
            self.navigationItem.rightBarButtonItem = rightButton;
            [rightButton release];
            
            textView = [[UITextView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 48, 320, 412)];
            seteuid(501);
            textView.font = [UIFont fontWithName: @"courier" size: [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] != 0 ? [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] : 12.0];
            seteuid(0);
            textView.autocorrectionType = UITextAutocorrectionTypeNo;
            textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            textView.delegate = self;
            /*if([[self.file fullPath] rangeOfString:@".plist"].location == NSNotFound){
             textView.text = [NSString stringWithContentsOfFile: [self.file fullPath] encoding: NSASCIIStringEncoding error: NULL];
             }*/ 
            if([[self.file fullPath] rangeOfString:@".plist"].location != NSNotFound){
                char *plist = [[NSString stringWithFormat: @"plutil -convert xml1 '%@'", [self.file fullPath]] UTF8String];
                system (plist);
                textView.text = [NSString stringWithContentsOfFile: [self.file fullPath] encoding:/*NSUTF8StringEncoding*/ NSASCIIStringEncoding error: NULL];
            } else if([[self.file fullPath] rangeOfString:@".strings"].location != NSNotFound){
                char *plist = [[NSString stringWithFormat: @"plutil -convert xml1 '%@'", [self.file fullPath]] UTF8String];
                system (plist);
                textView.text = [NSString stringWithContentsOfFile: [self.file fullPath] encoding:/*NSUTF8StringEncoding*/ NSASCIIStringEncoding error: NULL];
            } else {
                textView.text = [NSString stringWithContentsOfFile: [self.file fullPath] encoding:/*NSUTF8StringEncoding*/ NSASCIIStringEncoding error: NULL];
            }
            //UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
            search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
            search.autoresizesSubviews = YES;
            search.tintColor = [UIColor colorWithRed: 0.65 green: 0.7 blue: 0.75 alpha: 1.0];
            search.placeholder = NSLocalizedString(@"Search Text", @"Search Text");
            search.showsCancelButton = NO;
            search.delegate = self;
            
            [self.view addSubview: textView];
            [self.view addSubview: search];
            
            landscapeOnly = NO;
            portraitOnly = YES;
            
        } else if (index == 1) {
            archiveViewer = [[MFArchiveViewer alloc] initWithFile: self.file frame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
            archiveViewer.fileViewer = self;
            [self.view addSubview: archiveViewer];
            
            if (! [[self.file.name pathExtension] isEqualToString: @"deb"]) {
                UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: archiveViewer action: @selector(extractAll)];
                self.navigationItem.rightBarButtonItem = rightButton;
                [rightButton release];
            }
        } else if (index == 2) {
            /*webView = [[UIWebView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 412)];
            webView.scalesPageToFit = YES;
            webView.userInteractionEnabled = YES;
            webView.multipleTouchEnabled = YES;
            webView.autoresizingMask = self.view.autoresizingMask;
            [webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: [self.file fullPath]]]];
            NSArray *toolbarItems = [NSArray arrayWithObjects: printweb, flexItem, toolbarItem_2, nil];
            [toolbar setItems: toolbarItems animated: YES];
            [self.view addSubview: toolbar];
            [self.view addSubview: webView];
            
            landscapeOnly = NO;
            portraitOnly = NO;*/
            webView = [[UIWebView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake (0, 0, 320, 412) : CGRectMake (0, 0, 320, 412)];
            webView.scalesPageToFit = YES;
            webView.userInteractionEnabled = YES;
            webView.multipleTouchEnabled = YES;
            webView.autoresizingMask = self.view.autoresizingMask;
            [webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: [self.file fullPath]]]];
            [self.view addSubview: webView];
            NSArray *toolbarItems = [NSArray arrayWithObjects: printweb, flexItem,bookmarfile, flexItem, openin, flexItem, toolbarItem_2, nil];
            [toolbar setItems: toolbarItems animated: YES];
            [self.view addSubview: toolbar];
            
            landscapeOnly = NO;
            portraitOnly = YES;
        } else if (index == 3) {
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle: @"Options" style: UIBarButtonItemStylePlain target: self action: @selector(fit)];
            self.navigationItem.rightBarButtonItem = rightButton;
            [rightButton release];
            self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"imagebg.png"]];
            imagen = [UIImage imageWithContentsOfFile: [self.file fullPath]];
            imageView = [[UIImageView alloc] initWithImage: imagen];
            imageView.backgroundColor = [UIColor clearColor];
            
            scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            scrollView.autoresizingMask = self.view.autoresizingMask;
            scrollView.contentSize = imageView.image.size;
            scrollView.delegate = self;
            scrollView.maximumZoomScale = 6.0;
            scrollView.minimumZoomScale = 0.25;
            [scrollView addSubview: imageView];
            [self.view addSubview: scrollView];
            
            landscapeOnly = NO;
            portraitOnly = NO;
        } else if (index == 4) {
            landscapeOnly = YES;
            portraitOnly = NO;
            MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL: [NSURL fileURLWithPath: [self.file fullPath]]];
            //		moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
            moviePlayer.view.frame = CGRectMake (0, 0, 480, 320);
            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
            //            [self.view addSubview: moviePlayer.view];
            //[self.navigationController pushViewController:moviePlayer animated:YES];
            //        moviePlayer.fullscreen = YES;
            moviePlayer.moviePlayer.shouldAutoplay = YES;
            [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
            //        [moviePlayer setMovieControlMode:MPMovieControlModeHidden];
            [moviePlayer.moviePlayer setFullscreen: YES animated: YES];
            [moviePlayer.moviePlayer play];
            [moviePlayer release];
        } else if (index == 5) {
            audioPlayer = [[MFAudioPlayer alloc] initWithFile: self.file];
            audioPlayer.controller = self;
            [self.view addSubview: audioPlayer];
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit target: self action: @selector(editId3Tags)] autorelease];
            landscapeOnly = NO;
            portraitOnly = YES;
        } else if (index == 6) {
            hexEditor = [[MFHexEditor alloc] initWithFile: self.file];
            [self.view addSubview: hexEditor];
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") style:UIBarButtonItemStyleDone target: hexEditor action: @selector(save)] autorelease];
            
            landscapeOnly = YES;
            portraitOnly = NO;
        } else if (index == 7) {
            plistViewer = [[MFPlistViewer alloc] initWithFile: self.file frame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
            [self.view addSubview: plistViewer];
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize target: plistViewer action: @selector(loadRoot)] autorelease];
            
            landscapeOnly = NO;
            portraitOnly = NO;
        } else if (index == 8) {
            sqlViewer = [[MFSQLViewer alloc] initWithFile: self.file frame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
            sqlViewer.mainViewController = self;
            [self.view addSubview: sqlViewer];
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize target: sqlViewer action: @selector(showTables)] autorelease];
            
            landscapeOnly = NO;
            portraitOnly = NO;
        } else{
            [mc dismissModalViewControllerAnimated: NO];
        }
    } else{ if (actionSheet == plistfile) {
        
		if (index == 0) {
            plistViewer = [[MFPlistViewer alloc] initWithFile: self.file frame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460)];
            [self.view addSubview: plistViewer];
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize target: plistViewer action: @selector(loadRoot)] autorelease];
            
            landscapeOnly = NO;
            portraitOnly = NO;
        } else if (index == 1) {
            self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(saveplist)];
            rightButton.enabled = NO;
            self.navigationItem.rightBarButtonItem = rightButton;
            [rightButton release];
            
            textView = [[UITextView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 48, 320, 412)];
            seteuid(501);
            textView.font = [UIFont fontWithName: @"courier" size: [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] != 0 ? [[NSUserDefaults standardUserDefaults] floatForKey: @"MFFontSize"] : 12.0];
            seteuid(0);
            textView.autocorrectionType = UITextAutocorrectionTypeNo;
            textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            textView.delegate = self;
            /*if([[self.file fullPath] rangeOfString:@".plist"].location == NSNotFound){
             textView.text = [NSString stringWithContentsOfFile: [self.file fullPath] encoding: NSASCIIStringEncoding error: NULL];
             }*/ 
            char *plist = [[NSString stringWithFormat: @"plutil -convert xml1 '%@'", [self.file fullPath]] UTF8String];
                system (plist);
            NSString *textplist = [NSString stringWithContentsOfFile: [self.file fullPath] encoding:NSUTF8StringEncoding error: NULL];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
            //textplist = [textplist stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
            //textplist = [textplist stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;?xml" withString:@"<?xml"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"?&gt;" withString:@"?>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;!DOCTYPE" withString:@"<!DOCTYPE"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"\"&gt;" withString:@"\">"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;plist" withString:@"<plist"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;string&gt;" withString:@"<string>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;/string&gt;" withString:@"</string>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;key&gt;" withString:@"<key>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;/key&gt;" withString:@"</key>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;dict&gt;" withString:@"<dict>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;/dict&gt;" withString:@"</dict>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;array&gt;" withString:@"<array>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;/array&gt;" withString:@"</array>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;/plist&gt;" withString:@"</plist>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;real&gt;" withString:@"<real>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;/real&gt;" withString:@"</real>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;integer&gt;" withString:@"<integer>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;/integer&gt;" withString:@"</integer>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;true/&gt;" withString:@"<true/>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;false/&gt;" withString:@"<false/>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;date&gt;" withString:@"<date>"];
            textplist = [textplist stringByReplacingOccurrencesOfString:@"&lt;/date&gt;" withString:@"</date>"];
            textView.text = textplist;
            //UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
            search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
            search.autoresizesSubviews = YES;
            search.tintColor = [UIColor colorWithRed: 0.65 green: 0.7 blue: 0.75 alpha: 1.0];
            search.placeholder = NSLocalizedString(@"Search Text", @"Search Text");
            search.showsCancelButton = NO;
            search.delegate = self;
            
            [self.view addSubview: textView];
            [self.view addSubview: search];
            
            landscapeOnly = NO;
            portraitOnly = YES;
        } else{
            [mc dismissModalViewControllerAnimated: NO];
        }
    }
        if (actionSheet == imageoptions) {
            
            if (index == 0) {
                [scrollView zoomToRect: CGRectMake (0, 0, imageView.image.size.width, imageView.image.size.height) animated: YES];
            } else if (index == 1){
                UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
                UIPrintInfo *printInfo = [UIPrintInfo printInfo];
                printInfo.outputType = UIPrintInfoOutputPhoto;
                pic.printInfo = printInfo;
                pic.printFormatter = [imageView viewPrintFormatter];
                pic.showsPageRange = YES;
                void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
                ^(UIPrintInteractionController *printController, BOOL completed, NSError *error)
                {
                    if (!completed && error)
                    {
                        NSLog(@"Printing could not complete because of error: %@", error);
                    }
                };
                [pic presentAnimated:YES completionHandler:completionHandler];
            } else {
                return;
            }
        }
        if (actionSheet == restore) {
            if (index == 0) {
                loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeRestoring];
                [loadingView show];   
                restorethread = [[[MFThread alloc] init] autorelease];
                restorethread.cmd = [NSString stringWithFormat:@"cd /private/var/mobile/Library/Preferences/iFinderBackup/; unzip '%@'; mv /private/var/mobile/Library/Preferences/iFinderBackup/cydia.list /etc/apt/sources.list.d/cydia.list; apt-get update; dpkg --set-selections < /private/var/mobile/Library/Preferences/iFinderBackup/installed-apps; apt-get -y dselect-upgrade; apt-get --fix-missing -y dselect-upgrade; rm /private/var/mobile/Library/Preferences/iFinderBackup/installed-apps;rm /var/mobile/Library/iFinder/restore", [self.file fullPath]];
                restorethread.delegate = self;
                [restorethread start];
            } else {
                return;
            }
        }
                
}
}

- (void) save {
    
	[textView resignFirstResponder];
	textView.frame = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake(0, 0, 480, 206) : CGRectMake (0, 48, 320, 412);
    char *move = [[NSString stringWithFormat:@"mv -f '%@' '%@.bkp'", [self.file fullPath], [self.file fullPath]] UTF8String];
    system(move);
	[textView.text writeToFile: [self.file fullPath] atomically: NO encoding: NSUTF8StringEncoding error: NULL];
	self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

- (void) saveplist {
    
	[textView resignFirstResponder];
	textView.frame = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake(0, 0, 480, 206) : CGRectMake (0, 48, 320, 412);
    char *move = [[NSString stringWithFormat:@"mv -f '%@' '%@.bkp'", [self.file fullPath], [self.file fullPath]] UTF8String];
    system(move);
	[textView.text writeToFile: [self.file fullPath] atomically:NO encoding: NSUTF8StringEncoding error: NULL];
	self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

- (void) reloadAudioMetadata {
    
	[audioPlayer reloadMetadata];
    
}

- (void) fit {
    [imageoptions showInView:self.view];
	//[scrollView zoomToRect: CGRectMake (0, 0, imageView.image.size.width, imageView.image.size.height) animated: YES];
    
}

- (void) editId3Tags {
    
	MFID3TagEditorController *tagEditor = [[MFID3TagEditorController alloc] initWithTag: audioPlayer.id3tag];
	tagEditor.mainController = self;
	[tagEditor presentFrom: self];
	[tagEditor release];
    
}

// UIScrollViewDelegate

- (UIView *) viewForZoomingInScrollView: (UIScrollView *) theScrollView {
    
	return imageView;
    
}

// UITextViewDelegate

- (void) textViewDidBeginEditing: (UITextView *) theTextView {
    
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.3];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	theTextView.frame = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake (0, 0, 480, 106) : CGRectMake (0, 48, 320, 152);
	[UIView commitAnimations];
	self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

- (void) textViewDidEndEditing:(UITextView *) theTextView{
    [UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.3];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	theTextView.frame = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake (0, 0, 480, 206) : CGRectMake (0, 48, 320, 412);
	[UIView commitAnimations];
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText {
    [UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.3];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	textView.frame = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake (0, 0, 480, 106) : CGRectMake (0, 48, 320, 152);
	[UIView commitAnimations];
    [search setShowsCancelButton:YES animated:YES];
    /*NSString *string = textView.text;
    if ([searchText isEqualToString:@""]){
    } 
    else if ([string rangeOfString:searchText options:NSCaseInsensitiveSearch].location == NSNotFound) {
            search.tintColor = [UIColor redColor];
    } else {
        [textView scrollRangeToVisible:[string rangeOfString:search.text options:NSCaseInsensitiveSearch]];
        search.tintColor = [UIColor colorWithRed: 0.65 green: 0.7 blue: 0.75 alpha: 1.0];
    }*/
    if ([search.text isEqualToString:@""]){
        
    } else{
    searchRange = NSMakeRange(0, [textView.text length]);
    
    textRange = [textView.text rangeOfString:search.text 
                                     options:NSCaseInsensitiveSearch 
                                       range:searchRange];
    
    if ( textRange.location == NSNotFound ) {
        search.tintColor = [UIColor redColor];
    } else {
        textView.selectedRange = textRange;
        [textView scrollRangeToVisible:textRange];
        search.tintColor = [UIColor colorWithRed: 0.65 green: 0.7 blue: 0.75 alpha: 1.0];
    }
    }
}

- (void) searchBarSearchButtonClicked: (UISearchBar *) bar {
    [UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.3];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	textView.frame = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? CGRectMake (0, 0, 480, 106) : CGRectMake (0, 48, 320, 152);
	[UIView commitAnimations];
    /*NSMutableArray *array = [NSArray alloc];
    NSArray *u = [textView.text componentsSeparatedByString:search.text];
    NSString *string = textView.text;
    for (i = 0; i <= [array count]; i++){
        NSString *o = [NSString stringWithFormat:@"%@%@", [u objectAtIndex:i], search.text];
        NSRange p = [o rangeOfString:search.text options:NSCaseInsensitiveSearch];
        [array addObject:[NSValue valueWithRange:p]];
    }
    NSString *searchString = @"iFinder";
    NSRange thisCharRange, searchCharRange;
    searchCharRange = NSMakeRange(670, [string length]);
    thisCharRange = [string rangeOfString:searchString options:NSCaseInsensitiveSearch range:searchCharRange];

    if ([array count] == 0){
            search.tintColor = [UIColor redColor];
    } else {
        [textView scrollRangeToVisible: [[array objectAtIndex:0] rangeValue]];
    }*/
    if ( textRange.location + textRange.length <= [textView.text length] ) {
        searchRange.location = textRange.location + textRange.length;
        searchRange.length = [textView.text length] - searchRange.location;
        
        textRange = [textView.text rangeOfString:search.text 
                                         options:NSCaseInsensitiveSearch 
                                           range:searchRange];
        
        /* Validate search result & highlight the text */
    } else {
        searchRange = NSMakeRange(0, [textView.text length]);
        
        textRange = [textView.text rangeOfString:search.text 
                                         options:NSCaseInsensitiveSearch 
                                           range:searchRange];
    }
    if ( textRange.location == NSNotFound ) {
        search.tintColor = [UIColor redColor];
    } else {
        textView.selectedRange = textRange;
        [textView scrollRangeToVisible:textRange];
        search.tintColor = [UIColor colorWithRed: 0.65 green: 0.7 blue: 0.75 alpha: 1.0];
    }

}

- (void) searchBarCancelButtonClicked: (UISearchBar *) bar {
    
	[bar resignFirstResponder];
    textView.frame = CGRectMake (0, 48, 320, 412);
	[search setShowsCancelButton:NO animated:YES];
    search.tintColor = [UIColor colorWithRed: 0.65 green: 0.7 blue: 0.75 alpha: 1.0];
}

-(void)printdoc
{
    NSMutableString *printBody = [NSMutableString stringWithFormat:@"%@",textView.text];
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = file.name;
    pic.printInfo = printInfo;
    
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:printBody];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
    textFormatter.maximumContentWidth = 6 * 72.0;
    pic.printFormatter = textFormatter;
    [textFormatter release];
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    
    [pic presentFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES completionHandler:completionHandler];
    
}
-(void)printweb
{
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    pic.printInfo = printInfo;
    pic.printFormatter = [webView viewPrintFormatter];
    pic.showsPageRange = YES;
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error)
    {
        if (!completed && error)
        {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    [pic presentAnimated:YES completionHandler:completionHandler];
}

-(void)selfdelete{
    char *delete = [[NSString stringWithFormat: @"rm -rf '%@'", [self.file fullPath]] UTF8String];
    system(delete);
    [self close];
}

- (void) threadEnded: (MFThread *) thread {
    
	[loadingView hide];
	//if (thread.exitCode != 0) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restore Done", @"Restore Done") message:NSLocalizedString(@"You should reboot your device.\n Do you want to reboot now?", @"You should reboot your device.\n Do you want to reboot now?") delegate:self cancelButtonTitle:NSLocalizedString(@"No, Thanks", @"No, Thanks") otherButtonTitles:NSLocalizedString(@"Yes, Please", @"Yes, Please"), nil];
    alert.tag = 9;
    [alert show];
    [alert release];
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 & actionSheet.tag==9)
    {
        system("reboot");
    }
}

-(void) openother {
    NSURL *path = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/private/var/mobile/%@",[self.file name]]];
    UIDocumentInteractionController *docController = [UIDocumentInteractionController interactionControllerWithURL:path];
    [docController retain];
    
    docController.delegate = self;
    [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (void) bookmark {
    newBookmark = [[MFNewBookmark alloc] initWithPath: [file fullPath]];
    [newBookmark presentFrom:self];
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    char *copy = [[NSString stringWithFormat:@"cp -r '%@' /private/var/mobile/", [self.file fullPath]] UTF8String];
    system(copy);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    
}

-(void) documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller{
    [controller autorelease];
}

@end

