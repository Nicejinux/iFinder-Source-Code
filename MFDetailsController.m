//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFDetailsController.h"
#import "MWPhotoBrowser.h"

@implementation MFDetailsController

@synthesize file = file;
@synthesize mainController = mainController;

// super

- (void) close {
    //modifyDate.changed = @"NO";
    //modifyTime.changed = @"NO";
    //selectuid.changed = @"NO";
    
	[self.mainController detailsControllerDidClose: self];
	
	[super close];
	
}

// self

- (id) initWithFile: (MFFile *) aFile {
    
	self = [super init];
    
	self.file = aFile;
	self.title = self.file.name;
    
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") style:UIBarButtonItemStyleDone target: self action: @selector(done)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Close", @"Close") style: UIBarButtonItemStylePlain target: self action: @selector(close)];
	self.navigationItem.leftBarButtonItem = leftButtonItem;
	[leftButtonItem release];
	
    modifyDate = [[MFModifyDate alloc] init];
    modifyTime = [[MFModifyTime alloc] init];
    selectuid = [MFUIDSelect alloc];
    selectgid = [MFGIDSelect alloc];
    modifyDate.changed = @"NO";
    modifyTime.changed = @"NO";
    selectuid.changed = @"NO";
    selectgid.changed = @"NO";
    
	fileQueueCount = 0;
    
	newName = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, 150, 30)];
	newName.placeholder = NSLocalizedString(@"Enter filename", @"Enter filename");
	newName.text = self.file.name;
    newName.textAlignment = UITextAlignmentRight;
	newName.delegate = self;
	newName.autocapitalizationType = UITextAutocapitalizationTypeNone;
	newName.autocorrectionType = UITextAutocorrectionTypeNo;
	newName.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if ([self.file.type isEqualToString:@"sound"]){
        id3tag = [[MFID3Tag alloc] initWithFileName: [self.file fullPath]];
        title = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
        title.delegate = self;
        title.text = [id3tag songTitle];
        title.textAlignment = UITextAlignmentRight;
    
        artist = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
        artist.delegate = self;
        artist.text = [id3tag artist];
        artist.textAlignment = UITextAlignmentRight;
    
        album = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
        album.delegate = self;
        album.text = [id3tag album];
        album.textAlignment = UITextAlignmentRight;
    
        year = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
        year.delegate = self;
        year.text = [id3tag year];
        year.textAlignment = UITextAlignmentRight;
    
        genre = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
        genre.delegate = self;
        genre.text = [id3tag genre];
        genre.textAlignment = UITextAlignmentRight;
    
        lyricist = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
        lyricist.delegate = self;
        lyricist.text = [id3tag lyricist];
        lyricist.textAlignment = UITextAlignmentRight;
    
        language = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
        language.delegate = self;
        language.text = [id3tag language];
        language.textAlignment = UITextAlignmentRight;
    
        comments = [[UITextField alloc] initWithFrame: CGRectMake (0, 0, 180, 30)];
        comments.delegate = self;
        comments.text = [id3tag comments];
        comments.textAlignment = UITextAlignmentRight;
    }
    
    if ([self.file isSymlink]) {
        char *buf = malloc (256 * sizeof (char));
        int bytes = readlink ([[self.file fullPath] UTF8String], buf, 255);
        buf[bytes] = '\0';
        target = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, 150, 30)];
        target.delegate = self;
        target.autocapitalizationType = UITextAutocapitalizationTypeNone;
        target.autocorrectionType = UITextAutocorrectionTypeNo;
        target.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        target.textAlignment = UITextAlignmentRight;
        if ([[[NSString stringWithUTF8String: buf] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]) {
            target.text = [NSString stringWithUTF8String: buf];
        }else{
            target.text = [NSString stringWithFormat:@"/%@", [NSString stringWithUTF8String: buf]];
        }
        free (buf);
    }
    
	newChmod = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, 150, 30)];
	newChmod.placeholder = NSLocalizedString(@"Enter file mode", @"Enter file mode");
	newChmod.text = self.file.permissions;
	newChmod.delegate = self;
    newChmod.textAlignment = UITextAlignmentRight;
	newChmod.autocapitalizationType = UITextAutocapitalizationTypeNone;
	newChmod.autocorrectionType = UITextAutocorrectionTypeNo;
	newChmod.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	newUID = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, 150, 30)];
	newUID.placeholder = NSLocalizedString(@"Enter user ID", @"Enter user ID");
    if (self.file.owner == -2) {
        newUID.text = @"nobody";
    } else if (self.file.owner == 0) {
        newUID.text = @"root";
    } else if (self.file.owner == 1) {
        newUID.text = @"daemon";
    } else if (self.file.owner == 25) {
        newUID.text = @"_wireless";
    } else if (self.file.owner == 64) {
        newUID.text = @"_securityd";
    } else if (self.file.owner == 65) {
        newUID.text = @"_mdnsresponder";
    } else if (self.file.owner == 75) {
        newUID.text = @"_sshd";
    } else if (self.file.owner == 99) {
        newUID.text = @"_unknown";
    } else if (self.file.owner == 501) {
        newUID.text = @"mobile";
    } else {
        newUID.text = [NSString stringWithFormat:@"%i", self.file.owner];
    }
    ownership = self.file.owner;
    
	newUID.delegate = self;
    newUID.textAlignment = UITextAlignmentRight;
	newUID.autocapitalizationType = UITextAutocapitalizationTypeNone;
	newUID.autocorrectionType = UITextAutocorrectionTypeNo;
	newUID.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	newGID = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, 150, 30)];
	newGID.placeholder = NSLocalizedString(@"Enter group ID", @"Enter group ID");
	//newGID.text = [NSString stringWithFormat: @"%i", self.file.group];
    if (self.file.group == -2) {
        newGID.text = @"nobody";
    } else if (self.file.group == -1) {
        newGID.text = @"nogroup";
    } else if (self.file.group == 0) {
        newGID.text = @"wheel";
    } else if (self.file.group == 1) {
        newGID.text = @"daemon";
    } else if (self.file.group == 2) {
        newGID.text = @"kmem";
    } else if (self.file.group == 3) {
        newGID.text = @"sys";
    } else if (self.file.group == 4) {
        newGID.text = @"tty";
    } else if (self.file.group == 5) {
        newGID.text = @"operator";
    } else if (self.file.group == 6) {
        newGID.text = @"mail";
    } else if (self.file.group == 7) {
        newGID.text = @"bin";
    } else if (self.file.group == 8) {
        newGID.text = @"procview";
    } else if (self.file.group == 9) {
        newGID.text = @"procmod";
    } else if (self.file.group == 10) {
        newGID.text = @"owner";
    } else if (self.file.group == 12) {
        newGID.text = @"everyone";
    } else if (self.file.group == 16) {
        newGID.text = @"group";
    } else if (self.file.group == 20) {
        newGID.text = @"staff";
    } else if (self.file.group == 25) {
        newGID.text = @"_wireless";
    } else if (self.file.group == 26) {
        newGID.text = @"_lp";
    } else if (self.file.group == 27) {
        newGID.text = @"_postfix";
    } else if (self.file.group == 28) {
        newGID.text = @"_postdrop";
    } else if (self.file.group == 29) {
        newGID.text = @"certusers";
    } else if (self.file.group == 30) {
        newGID.text = @"_keytabusers";
    } else if (self.file.group == 45) {
        newGID.text = @"utmp";
    } else if (self.file.group == 50) {
        newGID.text = @"authedusers";
    } else if (self.file.group == 51) {
        newGID.text = @"interactusers";
    } else if (self.file.group == 52) {
        newGID.text = @"netusers";
    } else if (self.file.group == 53) {
        newGID.text = @"consoleusers";
    } else if (self.file.group == 54) {
        newGID.text = @"_mcxalr";
    } else if (self.file.group == 55) {
        newGID.text = @"_pcastagent";
    } else if (self.file.group == 56) {
        newGID.text = @"_pcastserver";
    } else if (self.file.group == 58) {
        newGID.text = @"_serialnumberd";
    } else if (self.file.group == 59) {
        newGID.text = @"_devdocs";
    } else if (self.file.group == 60) {
        newGID.text = @"_sandbox";
    } else if (self.file.group == 61) {
        newGID.text = @"localaccounts";
    } else if (self.file.group == 62) {
        newGID.text = @"netaccounts";
    } else if (self.file.group == 64) {
        newGID.text = @"_securityd";
    } else if (self.file.group == 65) {
        newGID.text = @"_mdnsresponder";
    } else if (self.file.group == 66) {
        newGID.text = @"_uucp";
    } else if (self.file.group == 67) {
        newGID.text = @"_ard";
    } else if (self.file.group == 68) {
        newGID.text = @"dialer";
    } else if (self.file.group == 69) {
        newGID.text = @"network";
    } else if (self.file.group == 70) {
        newGID.text = @"_www";
    } else if (self.file.group == 72) {
        newGID.text = @"_cvs";
    } else if (self.file.group == 73) {
        newGID.text = @"_svn";
    } else if (self.file.group == 74) {
        newGID.text = @"_mysql";
    } else if (self.file.group == 75) {
        newGID.text = @"_sshd";
    } else if (self.file.group == 76) {
        newGID.text = @"_qtss";
    } else if (self.file.group == 78) {
        newGID.text = @"_mailman";
    } else if (self.file.group == 79) {
        newGID.text = @"_appserverusr";
    } else if (self.file.group == 80) {
        newGID.text = @"admin";
    } else if (self.file.group == 81) {
        newGID.text = @"_appserveradm";
    } else if (self.file.group == 82) {
        newGID.text = @"_clamav";
    } else if (self.file.group == 83) {
        newGID.text = @"_amavisd";
    } else if (self.file.group == 84) {
        newGID.text = @"_jabber";
    } else if (self.file.group == 85) {
        newGID.text = @"_xgridcontroller";
    } else if (self.file.group == 86) {
        newGID.text = @"_xgridagent";
    } else if (self.file.group == 87) {
        newGID.text = @"_appowner";
    } else if (self.file.group == 88) {
        newGID.text = @"_windowserver";
    } else if (self.file.group == 89) {
        newGID.text = @"_spotlight";
    } else if (self.file.group == 90) {
        newGID.text = @"accessibility";
    } else if (self.file.group == 91) {
        newGID.text = @"_tokend";
    } else if (self.file.group == 92) {
        newGID.text = @"_securityagent";
    } else if (self.file.group == 93) {
        newGID.text = @"_calendar";
    } else if (self.file.group == 94) {
        newGID.text = @"_teamsserver";
    } else if (self.file.group == 95) {
        newGID.text = @"_update_sharing";
    } else if (self.file.group == 96) {
        newGID.text = @"_installer";
    } else if (self.file.group == 97) {
        newGID.text = @"_atsserver";
    } else if (self.file.group == 98) {
        newGID.text = @"_lpadmin";
    } else if (self.file.group == 99) {
        newGID.text = @"_unknown";
    } else if (self.file.group == 501) {
        newGID.text = @"mobile";
    }
    groupship = self.file.group;
	newGID.delegate = self;
    newGID.textAlignment = UITextAlignmentRight;
	newGID.autocapitalizationType = UITextAutocapitalizationTypeNone;
	newGID.autocorrectionType = UITextAutocorrectionTypeNo;
	newGID.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	tableView = [[UITableView alloc] initWithFrame: UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [[UIScreen mainScreen] applicationFrame] : CGRectMake (0, 0, 320, 460) style: UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview: tableView];
    [tableView release];
	
	sections = [[NSMutableArray alloc] init];
	section0 = [[NSMutableArray alloc] init];
	tags = [[NSMutableArray alloc] init];
	section1 = [[NSMutableArray alloc] init];
	section2 = [[NSMutableArray alloc] init];
	section3 = [[NSMutableArray alloc] init];
    dates = [[NSMutableArray alloc] init];
    q = [[NSMutableArray alloc] init];
    createdd = [[NSMutableArray alloc] init];
    
	tempCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Permissions", @"Permissions");
	tempCell.accessoryView = newChmod;
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [newChmod release];
	[section0 addObject: tempCell];
	[tempCell release];
	
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = [NSString stringWithFormat: @"%@:", NSLocalizedString(@"Size", @"Size")];
    UITextField *size = [[UITextField alloc] initWithFrame: CGRectMake (0, 15, 150, 30)];
	size.text = [NSString stringWithFormat: @"%i Bytes", self.file.bytessize];
    size.textAlignment = UITextAlignmentRight;
	size.delegate = self;
    size.enabled = NO;
	size.autocapitalizationType = UITextAutocapitalizationTypeNone;
	size.autocorrectionType = UITextAutocorrectionTypeNo;
	size.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tempCell.accessoryView = size;
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
	[section0 addObject: tempCell];
	[tempCell release];
	
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Name", @"Name");
	tempCell.accessoryView = newName;
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [newName release];
	[section0 addObject: tempCell];
	[tempCell release];
    
    if ([self.file isSymlink]){
        tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
        tempCell.text = NSLocalizedString(@"Target Path", @"Target Path");
        tempCell.accessoryView = target;
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [target release];
        [section0 addObject: tempCell];
        [tempCell release];
    }
    
	tempCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"MFDCTempCell"];
	tempCell.textLabel.text = NSLocalizedString(@"User ID", @"User ID");
	tempCell.detailTextLabel.text = newUID.text;
    tempCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    tempCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [newUID release];
	[section0 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"MFDCTempCell"];
	tempCell.textLabel.text = NSLocalizedString(@"Group ID", @"Group ID");
	tempCell.detailTextLabel.text = newGID.text;
    tempCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    tempCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [newGID release];
	[section0 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"MFDCTempCell"];
	tempCell.textLabel.text = [NSString stringWithFormat: @"MIME %@:", NSLocalizedString(@"type", @"type")];
    tempCell.detailTextLabel.text = self.file.mime;
    tempCell.detailTextLabel.textAlignment = UITextAlignmentRight;
    tempCell.detailTextLabel.textColor = [UIColor blackColor];
    tempCell.detailTextLabel.numberOfLines = 2;
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
	[section0 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"MFDCTempCell"];
	tempCell.textLabel.text = NSLocalizedString(@"Calculating MD5...", @"Calculating MD5...");
    tempCell.detailTextLabel.textColor = [UIColor blackColor];
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
	[section0 addObject: tempCell];
	[tempCell release];
    
  /////////////////////
    if ([self.file.type isEqualToString:@"sound"]){
        tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
        tempCell.text = NSLocalizedString(@"Title", @"Title");
        tempCell.accessoryView = title;
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [title release];
        [tags addObject: tempCell];
        [tempCell release];
    
        tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
        tempCell.text = NSLocalizedString(@"Artist", @"Artist");
        tempCell.accessoryView = artist;
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [artist release];
        [tags addObject: tempCell];
        [tempCell release];
    
        tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
        tempCell.text = NSLocalizedString(@"Album", @"Album");
        tempCell.accessoryView = album;
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [album release];
        [tags addObject: tempCell];
		[tempCell release];
    
	    tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
		tempCell.text = NSLocalizedString(@"Year", @"Year");
		tempCell.accessoryView = year;
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    	[year release];
		[tags addObject: tempCell];
		[tempCell release];
    
	    tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
		tempCell.text = NSLocalizedString(@"Genre", @"Genre");
		tempCell.accessoryView = genre;
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    	[genre release];
		[tags addObject: tempCell];
		[tempCell release];
    
	    tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
		tempCell.text = NSLocalizedString(@"Lyricist", @"Lyricist");
		tempCell.accessoryView = lyricist;
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    	[lyricist release];
		[tags addObject: tempCell];
		[tempCell release];
    
	    tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
		tempCell.text = NSLocalizedString(@"Language", @"Language");
		tempCell.accessoryView = language;
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    	[language release];
		[tags addObject: tempCell];
		[tempCell release];
    
    	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
		tempCell.text = NSLocalizedString(@"Comments", @"Comments");
		tempCell.accessoryView = comments;
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
	    [comments release];
		[tags addObject: tempCell];
		[tempCell release];
    }
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Upload file to Dropbox", @"Upload file to Dropbox");
	[section1 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = @"Share on Facebook";
	[section1 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = @"Share on Twitter";
	[section1 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Web browser", @"Web browser");
	[section2 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Image viewer", @"Image viewer");
	[section2 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Audio player", @"Audio player");
	[section2 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Movie player", @"Movie player");
	[section2 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Text editor", @"Text editor");
	[section2 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Archive manager", @"Archive manager");
	[section2 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Property list viewer", @"Property list viewer");
	[section2 addObject: tempCell];
	[tempCell release];
    
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"SQL viewer", @"SQL viewer");
	[section2 addObject: tempCell];
	[tempCell release];
	
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Hex editor", @"Hex editor");
	[section2 addObject: tempCell];
	[tempCell release];
	
	tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Send by e-mail", @"Send by e-mail");
	[section2 addObject: tempCell];
	[tempCell release];
    
    if (![self.file isDirectory]) {
        tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
        tempCell.text = NSLocalizedString(@"Open In", @"Open In");
        [section3 addObject: tempCell];
        [tempCell release];
    }
    
    tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Compress", @"Compress");
	[section3 addObject: tempCell];
	[tempCell release];
    
    tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
	tempCell.text = NSLocalizedString(@"Bookmark File", @"Bookmark File");
	[section3 addObject: tempCell];
	[tempCell release];
    
    tempCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"MFDCTempCell"];
    myPath = [self.file fullPath];
    myManager = [NSFileManager defaultManager];
    myDict = [myManager attributesOfItemAtPath:myPath error:nil];
    myDate = [myDict objectForKey:@"NSFileModificationDate"];
    a = [NSString stringWithFormat:@"%@", myDate];
    [q setArray:[a componentsSeparatedByString:@" "]];
    moddate = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, 180, 20)];
    moddate.delegate = self;
    moddate.text = [q objectAtIndex:0];
    moddate.textAlignment = UITextAlignmentRight;
    moddate.enabled = NO;
    //[a writeToFile:@"/date.txt" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    //NSDate * myDate2 = [myDict objectForKey:@"NSFileCreationDate"];
    //NSString *a2 = [NSString stringWithFormat:@"%@", myDate2];
    //[a2 writeToFile:@"/date2.txt" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    tempCell.text = NSLocalizedString(@"Date", @"Date");
    //tempCell.accessoryView = created;
    tempCell.detailTextLabel.text = moddate.text;
    DateModified = moddate.text;
	[dates addObject: tempCell];
	[tempCell release];
    
    tempCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"MFDCTempCell"];
    myPath = [self.file fullPath];
    myManager = [NSFileManager defaultManager];
    myDict = [myManager attributesOfItemAtPath:myPath error:nil];
    myDate = [myDict objectForKey:@"NSFileModificationDate"];
    a = [NSString stringWithFormat:@"%@", myDate];
    [q setArray:[a componentsSeparatedByString:@" "]];
    created = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, 180, 20)];
    created.delegate = self;
    created.text = [q objectAtIndex:1];
    created.textAlignment = UITextAlignmentRight;
    created.enabled = NO;
    //[a writeToFile:@"/date.txt" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    //NSDate * myDate2 = [myDict objectForKey:@"NSFileCreationDate"];
    //NSString *a2 = [NSString stringWithFormat:@"%@", myDate2];
    //[a2 writeToFile:@"/date2.txt" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    tempCell.text = NSLocalizedString(@"Time", @"Time");
    tempCell.detailTextLabel.text = created.text;
    TimeModified = created.text;
    [created release];
	[dates addObject: tempCell];
	[tempCell release];
    
    tempCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"MFDCTempCell"];
    myPath = [self.file fullPath];
    myManager = [NSFileManager defaultManager];
    myDict = [myManager attributesOfItemAtPath:myPath error:nil];
    myDate = [myDict objectForKey:@"NSFileCreationDate"];
    a = [NSString stringWithFormat:@"%@", myDate];
    [q setArray:[a componentsSeparatedByString:@" "]];
    created = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, 180, 20)];
    created.delegate = self;
    created.text = [q objectAtIndex:0];
    created.textAlignment = UITextAlignmentRight;
    created.enabled = NO;
    //[a writeToFile:@"/date.txt" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    //NSDate * myDate2 = [myDict objectForKey:@"NSFileCreationDate"];
    //NSString *a2 = [NSString stringWithFormat:@"%@", myDate2];
    //[a2 writeToFile:@"/date2.txt" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    tempCell.text = NSLocalizedString(@"Date", @"Date");
    tempCell.detailTextLabel.text = created.text;
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [created release];
	[createdd addObject: tempCell];
	[tempCell release];
    
    tempCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"MFDCTempCell"];
    myPath = [self.file fullPath];
    myManager = [NSFileManager defaultManager];
    myDict = [myManager attributesOfItemAtPath:myPath error:nil];
    myDate = [myDict objectForKey:@"NSFileCreationDate"];
    a = [NSString stringWithFormat:@"%@", myDate];
    [q setArray:[a componentsSeparatedByString:@" "]];
    created = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, 180, 20)];
    created.delegate = self;
    created.text = [q objectAtIndex:1];
    created.textAlignment = UITextAlignmentRight;
    created.enabled = NO;
    //[a writeToFile:@"/date.txt" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    //NSDate * myDate2 = [myDict objectForKey:@"NSFileCreationDate"];
    //NSString *a2 = [NSString stringWithFormat:@"%@", myDate2];
    //[a2 writeToFile:@"/date2.txt" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    tempCell.text = NSLocalizedString(@"Time", @"Time");
    tempCell.detailTextLabel.text = created.text;
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [created release];
	[createdd addObject: tempCell];
	[tempCell release];
    [q release];
    
	[sections addObject: section0];
    //[section0 release];
    [sections addObject: tags];
    [tags release];
    [sections addObject: createdd];
    [createdd release];
    [sections addObject: dates];
    //[dates release];
	[sections addObject: section1];
    [section1 release];
	[sections addObject: section2];
    [section2 release];
	[sections addObject: section3];
    [section3 release];
	
	if (! self.file.isDirectory) {
		[self calculateMd5];
	}
    
	return self;
	
}

- (void) upload: (NSString *) path {

	if ([[[self mainController] fileManager] fileIsDirectory: path]) {
    seteuid(501);
		[[[self mainController] fileManager] dbCreateDirectory: [[[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"] stringByAppendingPathComponent: path]];
        seteuid(0);
		NSMutableArray *contents = [[[self mainController] fileManager] contentsOfDirectory: path];
		for (int i = 0; i < [contents count]; i++) {
		
			[self upload: [[[contents objectAtIndex: i] path] stringByAppendingPathComponent: [[contents objectAtIndex: i] name]]];
			
		}

	} else {
		if (fileQueueCount == 0) {
			loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeProgress];
			[loadingView show];
                        [loadingView release];
		}
		fileQueueCount++;
            seteuid(501);
		NSString *uploadPath = [[[self mainController] fileManager] fileIsDirectory: [self.file.path stringByAppendingPathComponent: self.file.name]] ? [[[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"] stringByAppendingPathComponent: [path stringByDeletingLastPathComponent]] : [[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"];
            seteuid(0);
		[[[self mainController] fileManager] dbUploadFile: path toPath: uploadPath];
	}

}

- (void) calculateMd5 {

	NSString *cmd = [NSString stringWithFormat: @"md5sum '%@' | cut -d ' ' -f 1 > /tmp/MFMD5Sum.txt", [self.file.path stringByAppendingPathComponent: self.file.name]];
	md5calc = [[[MFThread alloc] init] autorelease];
	md5calc.cmd = cmd;
	md5calc.delegate = self;
	[md5calc start];
	
}

- (void) done {
    
	if (![self.file.permissions isEqualToString: newChmod.text]) {
		[[[self mainController] fileManager] chmodFile: [self.file fullPath] permissions: newChmod.text];
	}
    
	if (![self.file.name isEqualToString: newName.text]) {	
		[[[self mainController] fileManager] moveFile: [self.file fullPath] toPath: [self.file.path stringByAppendingPathComponent: newName.text]];
	}
    
    if (self.file.owner != ownership || self.file.group != groupship) {
        //		char *ch = [[NSString stringWithFormat:@"chown %@:%@ '%@'", newUID.text, newGID.text, [self.file fullPath]]UTF8String];
        //        system(ch);
        //[[NSString stringWithFormat:@"%i", ownership] writeToFile:@"/a" atomically:NO encoding:NSUTF8StringEncoding error:nil];
        //[[[self mainController] fileManager] chownFile:[self.file fullPath] user:ownership group:[newGID.text intValue]];
        NSString *pathchwon = [self.file.path stringByAppendingPathComponent: newName.text];
//        [managerfile chownFile:pathchwon user:ownership group:[newGID.text intValue]];
        if (ownership == -2) {
            char *ch = [[NSString stringWithFormat:@"chown nobody:%i '%@'", groupship, pathchwon] UTF8String];
            system(ch);
        } else {
            char *ch = [[NSString stringWithFormat:@"chown %i:%i '%@'", ownership, groupship, pathchwon] UTF8String];
            system(ch);
        }
	}
    
    if([self.file.type isEqualToString:@"sound"]){
    ///////////Editar Audio Info//////////////////
        [id3tag setSongTitle: title.text];
        [id3tag setArtist: artist.text];
        [id3tag setAlbum: album.text];
        [id3tag setYear: year.text];
        [id3tag setGenre: genre.text];
        [id3tag setLyricist: lyricist.text];
        [id3tag setLanguage: language.text];
        [id3tag setComments: comments.text];
    }
    
    NSString *godate = [[[[dates objectAtIndex: 0] detailTextLabel] text] stringByReplacingOccurrencesOfString:@"" withString:@""];
    NSString *gotime = [[[[dates objectAtIndex: 1] detailTextLabel] text] stringByReplacingOccurrencesOfString:@"" withString:@""];
    
    NSString *godate3 = [NSString stringWithFormat:@"%@ %@", godate, gotime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeZone *local = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:local];
    NSDate *timeStamp = [dateFormatter dateFromString:godate3];
    
    /*NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *timeStamp = [dateFormatter dateFromString:godate3];*/
    [dateFormatter release];

    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.dateFormat = @"yyyyMMddHHmm.ss";
    //NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
//    [dateFormatter2 setTimeZone:gmt];
    NSString *save = [dateFormatter2 stringFromDate:timeStamp];
    [dateFormatter2 release];
    
    /*NSString *godate4 = [godate3 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    godate4 = [godate4 stringByReplacingOccurrencesOfString:@" " withString:@""];
    godate4 = [godate4 stringByReplacingOccurrencesOfString:@":" withString:@""];
    godate4 = [NSString stringWithFormat:@"%@.%@", [godate4 substringToIndex:12], [godate4 substringFromIndex:12]];*/
    
    /*gotime2 = [NSString stringWithFormat:@"%@%@.%@", [gotime2 substringToIndex:2], [[[[dates objectAtIndex: 1] detailTextLabel] text] substringWithRange:NSMakeRange(3, 2)], [[[[dates objectAtIndex: 1] detailTextLabel] text] substringFromIndex:6]];*/
    //[save writeToFile:@"/a" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    char *time = [[NSString stringWithFormat:@"touch -t %@ '%@'", save, [self.file.path stringByAppendingPathComponent: newName.text]] UTF8String];
    system(time);
    
	[self close];
}

// UITableViewDataSource

- (int) numberOfSectionsInTableView: (UITableView *) theTableView {

    //return self.file.isDirectory ? 5 : [self.file.type isEqualToString:@"sound"] ? 4 : 5;
    return self.file.isDirectory ? 7 : [self.file.type isEqualToString:@"sound"] ? 6 : 7;
	
}

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {
    
	int nRows;
	
	if (section == 0) {
        if ([self.file isSymlink]) {
            nRows = self.file.isDirectory ? 6 : 7;
        }else{
            nRows = self.file.isDirectory ? 5 : 7;
        }
    } else if (section == 1) {
        nRows = [self.file.type isEqualToString:@"sound"] ? 8 : 0;
    } else if (section == 2) {
		nRows = 2;
	} else if (section == 3) {
		nRows = 2;
	} else if (section == 4) {
		nRows = self.file.isDirectory ? 1 : 1;
	} else if (section == 5) {
		nRows = self.file.isDirectory ? 0 : 10;
	} else if (section == 6) {
		nRows = [[sections objectAtIndex: 6] count];
    }
	
	return nRows;
	
}

- (NSString *) tableView: (UITableView *) theTableView titleForHeaderInSection: (int) section {

	NSString *title;

	if (section == 0) {
		title = NSLocalizedString(@"General", @"General");
	} else if (section == 1) {
        title = self.file.isDirectory ? nil : [self.file.type isEqualToString:@"sound"] ? NSLocalizedString(@"Audio Info", @"Audio Info") : nil;
    } else if (section == 2) {
		title = NSLocalizedString(@"Created", @"Created");
	} else if (section == 3) {
		title = NSLocalizedString(@"Last Modified", @"Last Modified");
	} else if (section == 4) {
		title = self.file.isDirectory ? NSLocalizedString(@"Dropbox", @"Dropbox") : NSLocalizedString(@"Dropbox", @"Dropbox");
	} else if (section == 5) {
		title = self.file.isDirectory ? nil : NSLocalizedString(@"Open with...", @"Open with...");
	} else if (section == 6) {
		title = NSLocalizedString(@"Miscellaneous", @"Miscellaneous");
	}
	
	return title;
	
}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [[sections objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
	
	return cell;
	
}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];

	if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            if ([self.file isSymlink]){
            } else {
                /*NSString *o;
                if ([newUID.text isEqualToString:@"nobody"]) {
                    o = @"-2";
                } else if ([newUID.text isEqualToString:@"root"]) {
                    o = @"0";
                } else if ([newUID.text isEqualToString:@"daemon"]) {
                    o = @"1";
                } else if ([newUID.text isEqualToString:@"_wireless"]) {
                    o = @"25";
                } else if ([newUID.text isEqualToString:@"_securityd"]) {
                    o = @"64";
                } else if ([newUID.text isEqualToString:@"_mdnsresponder"]) {
                    o = @"65";
                } else if ([newUID.text isEqualToString:@"_sshd"]) {
                    o = @"75";
                } else if ([newUID.text isEqualToString:@"_unknown"]) {
                    o = @"99";
                } else if ([newUID.text isEqualToString:@"mobile"]) {
                    o = @"501";
                } else {
                    //newUID.text = [NSString stringWithFormat:@"%i", selectuid.custom.text];
                    o = newUID.text;
                }*/
                [selectuid initWithUID:[[[section0 objectAtIndex:3] detailTextLabel] text]];
                [self.navigationController pushViewController:selectuid animated:YES];
            }
        } else if (indexPath.row == 4) {
            if ([self.file isSymlink]){
                [selectuid initWithUID:[[[section0 objectAtIndex:4] detailTextLabel] text]];
                [self.navigationController pushViewController:selectuid animated:YES];
            } else {
                [selectgid initWithGID:[[[section0 objectAtIndex:4] detailTextLabel] text]];
                [self.navigationController pushViewController:selectgid animated:YES];
            }
        } else if (indexPath.row == 5) {
            if ([self.file isSymlink]){
                [selectgid initWithGID:[[[section0 objectAtIndex:5] detailTextLabel] text]];
                [self.navigationController pushViewController:selectgid animated:YES];
            }
        }
	} else if (indexPath.section == 1) {
    } else if (indexPath.section == 2) {
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormat dateFromString:DateModified];
            modifyDate.date = date;
            [self.navigationController pushViewController:modifyDate animated:YES];
		} else if (indexPath.row == 1) {
			NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
            [dateFormat2 setDateFormat:@"HH:mm:ss"];
            NSDate *date2 = [dateFormat2 dateFromString:TimeModified];
            modifyTime.date = date2;
            [self.navigationController pushViewController:modifyTime animated:YES];
		}
    } else if (indexPath.section == 4) {
	
		if (indexPath.row == 0) {
	
			[self upload: [self.file.path stringByAppendingPathComponent: self.file.name]];
			
		}
		
	} else if (indexPath.section == 5) {
	
		if (indexPath.row == 0) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"html"];
			
		} else if (indexPath.row == 1) {
		
			//fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"image"];
            NSMutableArray *photos = [[NSMutableArray alloc] init];
            [photos addObject: [MWPhoto photoWithFilePath:[self.file fullPath]]];
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
            [browser setInitialPageIndex:imagenabrir]; // Can be changed if desired
            [self.navigationController pushViewController:browser animated:YES];
            [browser release];
            [photos release];
			
		} else if (indexPath.row == 2) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"sound"];
			
		} else if (indexPath.row == 3) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"video"];
			
		} else if (indexPath.row == 4) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"text"];
		
		} else if (indexPath.row == 5) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"package"];
			
		} else if (indexPath.row == 6) {

			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"plist"];

		} else if (indexPath.row == 7) {

			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"database"];
			
		} else if (indexPath.row == 8) {
		
			fileViewerController = [[MFFileViewerController alloc] initWithFile: self.file type: @"binary"];

		} else if (indexPath.row == 9) {

                	mailController = [[MFMailComposeViewController alloc] init];

			NSData *attachment = [NSData dataWithContentsOfFile: [self.file.path stringByAppendingPathComponent: self.file.name]];

			[mailController setSubject: [NSString stringWithFormat: @"%@: %@ (%@, %@)", NSLocalizedString(@"[iFinder] Attachment", @"[iFinder] Attachment"),self.file.name, self.file.mime, self.file.fsize]];
			[mailController setMessageBody: NSLocalizedString(@"This mail was sent from an iDevice using iFinder.", @"This mail was sent from an iDevice using iFinder.") isHTML: NO];
			[mailController addAttachmentData: attachment mimeType: self.file.mime fileName: self.file.name];
			mailController.mailComposeDelegate = self;
			[self presentModalViewController: mailController animated: YES];
                        [mailController release];
			
			return;

		}
		
		[fileViewerController presentFrom: self];
                [fileViewerController release];
		
	} else if (indexPath.section == 6) {
	
        if ([self.file isDirectory]) {
            if (indexPath.row == 0) {
                /*compress = [[[MFThread alloc] init] autorelease];
                 compress.delegate = self;
                 compress.cmd = [NSString stringWithFormat: @"cd %@; tar -czvf %@.tar.gz %@", self.file.path, self.file.name, self.file.name];
                 loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
                 [loadingView show];
                 [loadingView release];
                 [compress start];*/
                MFCompressController *compressController = [[MFCompressController alloc] initWithFiles: [NSArray arrayWithObject: [self.file fullPath]]];
                compressController.mainController = self.mainController;
                [compressController presentFrom: self];
                [compressController release];
            } else if (indexPath.row == 1) {
                newBookmark = [[MFNewBookmark alloc] initWithPath:[self.file fullPath]];
                [newBookmark presentFrom:self];
            }
        } else {
            if (indexPath.row == 0) {
                NSURL *path = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/private/var/mobile/%@",[self.file name]]];
                UIDocumentInteractionController *docController = [UIDocumentInteractionController interactionControllerWithURL:path];
                [docController retain];
            
                docController.delegate = self;
                [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
            } else if (indexPath.row == 1) {
                /*compress = [[[MFThread alloc] init] autorelease];
                 compress.delegate = self;
                 compress.cmd = [NSString stringWithFormat: @"cd %@; tar -czvf %@.tar.gz %@", self.file.path, self.file.name, self.file.name];
                 loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
                 [loadingView show];
                 [loadingView release];
                 [compress start];*/
                MFCompressController *compressController = [[MFCompressController alloc] initWithFiles: [NSArray arrayWithObject: [self.file fullPath]]];
                compressController.mainController = self.mainController;
                [compressController presentFrom: self];
                [compressController release];
            } else if (indexPath.row == 2) {
                newBookmark = [[MFNewBookmark alloc] initWithPath:[self.file fullPath]];
                [newBookmark presentFrom:self];
            }
        }
		
	}
	
}

// MFFileManagerDelegate

- (void) fileManagerDBUploadedFile: (NSString *) path {
    seteuid(501);
	if ([[[NSUserDefaults standardUserDefaults] stringForKey: @"MFDropboxUploadPath"] rangeOfString:@"/Public"].location !=NSNotFound && (!self.file.isDirectory)) {
        NSURL *bitlyRequestUrl = [NSURL URLWithString: [NSString stringWithFormat: @"http://api.bitly.com/v3/shorten?login=itaybre&apiKey=R_8f979b70d02cd43deeb99bd71de172f9&longUrl=http://dl.dropbox.com/u/%@/%@&format=txt", [[[self mainController] fileManager] userID], [path substringFromIndex: 8]]];
        NSString *shortUrlString = [NSString stringWithContentsOfURL: bitlyRequestUrl];
        [[UIPasteboard generalPasteboard] setString: shortUrlString];
        [[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"File uploaded", @"File uploaded") message: NSLocalizedString(@"Public link was copied to the pasteboard.", @"Public link was copied to the pasteboard.") delegate: nil cancelButtonTitle: NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil] autorelease] show];
	} else if ([self.file isDirectory]){
        
    } else {
        [[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"File uploaded", @"File uploaded") message: nil delegate: nil cancelButtonTitle: NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil] autorelease] show];
    }
        seteuid(0);
	
	fileQueueCount--;
	if (fileQueueCount == 0) {
		[loadingView hide];
		loadingView = nil;
	}

}

- (void) fileManagerDBUploadFileFailed {

	[loadingView hide];
	loadingView = nil;
	[[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error uploading file", @"Error uploading file") message: NSLocalizedString(@"Please make sure that you're connected to the Internet, logged in to your Dropbox account and the specified file does not exist yet and try again.", @"Please make sure that you're connected to the Internet, logged in to your Dropbox account and the specified file does not exist yet and try again.") delegate: nil cancelButtonTitle: NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles: nil] autorelease] show];

	fileQueueCount--;
	if (fileQueueCount == 0) {
		[loadingView hide];
		loadingView = nil;
	}

}

- (void) fileManagerDBUploadProgress: (float) progress forFile: (NSString *) path {

	[loadingView setProgress: progress];
	[loadingView setTitle: [path lastPathComponent]];

}

- (void) fileManagerDBDeletedFile: (NSString *) path {
}

- (void) fileManagerDBDeleteFileFailed {
}

- (void) fileManagerDBCreatedDirectory: (NSString *) path {
}

- (void) fileManagerDBCreateDirectoryFailed {
}

// UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];

	return YES;

}

// MFThreadDelegate

- (void) threadEnded: (MFThread *) theThread {

	if (theThread == md5calc) {
		NSString *hash = [NSString stringWithContentsOfFile: @"/tmp/MFMD5Sum.txt" encoding: NSUTF8StringEncoding error: NULL];
		system ("rm /tmp/MFMD5Sum.txt");
		[[section0 objectAtIndex: 6] setText: [NSString stringWithFormat: @"MD5 hash:"]];
        [[[section0 objectAtIndex: 6] detailTextLabel] setText:hash];
        [[[section0 objectAtIndex: 6] detailTextLabel] setTextAlignment:UITextAlignmentRight];
        [[[section0 objectAtIndex: 6] detailTextLabel] setNumberOfLines:2];
		[tableView reloadData];
    }
	
}

// MFMailComposeViewControllerDelegate

- (void) mailComposeController: (MFMailComposeViewController *) controller didFinishWithResult: (MFMailComposeResult) result error: (NSError *) error {

	[self dismissModalViewControllerAnimated: YES];
	
}

- (void) dealloc {
    
	[sections release];
	sections = nil;
    [id3tag release];
	id3tag = nil;
/*    [myPath release];
    [myManager release];
    [myDict release];
    [myDate release];;
    [a release];*/
	
	[super dealloc];
	
}

-(void)viewWillAppear:(BOOL)animated{
    if ([modifyDate.changed isEqualToString:@"YES"]){
//        /*tempCell = [[UITableViewCell alloc] /*initWithStyle: 0*/ initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"MFDCTempCell"];
/*        created = [[UITextField alloc] initWithFrame: CGRectMake (0, 10, 180, 20)];
        created.delegate = self;
        created.text = modifyDate.dateshow;
        created.textAlignment = UITextAlignmentRight;
        created.enabled = NO;
        tempCell.text = NSLocalizedString(@"Date", @"Date");
        tempCell.accessoryView = created;
        DateModified = created.text;
        [created release];
        [dates replaceObjectAtIndex:0 withObject:tempCell];
        [tempCell release];*/
        
        /*NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:3];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:index];
        cell.detailTextLabel.text = modifyDate.dateshow;*/
        
//        moddate.text = [NSString stringWithContentsOfFile:@"/private/var/mobile/iFinder/qn" encoding:NSUTF8StringEncoding error:nil];
        NSString *ui = [NSString stringWithContentsOfFile:@"/private/var/mobile/Library/iFinder/qn" encoding:NSUTF8StringEncoding error:nil];
        //system ("rm /private/var/mobile/Library/iFinder/qn");
        DateModified = ui;
        [[[dates objectAtIndex: 0] detailTextLabel] setText:ui];
        [[[dates objectAtIndex: 1] detailTextLabel] setText:TimeModified];
    }
    
    if ([modifyTime.changed isEqualToString:@"YES"]){
        NSString *ui2 = [NSString stringWithContentsOfFile:@"/private/var/mobile/Library/iFinder/qnu" encoding:NSUTF8StringEncoding error:nil];
        //system ("/private/var/mobile/Library/iFinder/qnu");
        TimeModified = ui2;
        [[[dates objectAtIndex: 0] detailTextLabel] setText:DateModified];
        [[[dates objectAtIndex: 1] detailTextLabel] setText:ui2];
    }
    
    if ([selectuid.changed isEqualToString:@"YES"]){
        selec = [[NSString stringWithContentsOfFile:@"/private/var/mobile/Library/iFinder/qnua" encoding:NSUTF8StringEncoding error:nil] intValue];
        //system("rm /private/var/mobile/Library/iFinder/qnua");
        NSString *uidchang;
        if (selec == -2) {
            uidchang = @"nobody";
        } else if (selec == 0) {
            uidchang = @"root";
        } else if (selec == 1) {
            uidchang = @"daemon";
        } else if (selec == 25) {
            uidchang = @"_wireless";
        } else if (selec == 64) {
            uidchang = @"_securityd";
        } else if (selec == 65) {
            uidchang = @"_mdnsresponder";
        } else if (selec == 75) {
            uidchang = @"_sshd";
        } else if (selec == 99) {
            uidchang = @"_unknown";
        } else if (selec == 501) {
            uidchang = @"mobile";
        } else {
            //newUID.text = [NSString stringWithFormat:@"%i", selectuid.custom.text];
        }
        ownership = selec;
        if ([self.file isSymlink]){
            [[[section0 objectAtIndex:4] detailTextLabel] setText:uidchang];
            //[[[section0 objectAtIndex: 5] textLabel] setText:NSLocalizedString(@"Group ID", @"Group ID")];
        } else {
            [[[section0 objectAtIndex:3] detailTextLabel] setText:uidchang];
            //[[[section0 objectAtIndex: 4] textLabel] setText:NSLocalizedString(@"Group ID", @"Group ID")];
        }
    }
    /*if ([modifyDate.changed isEqualToString:@"YES"]||[modifyTime.changed isEqualToString:@"YES"]){
        [tableView reloadData];
    }*/
    if ([selectgid.changed isEqualToString:@"YES"]){
        selecgid = [[NSString stringWithContentsOfFile:@"/private/var/mobile/Library/iFinder/qnub" encoding:NSUTF8StringEncoding error:nil] intValue];
        //system("rm /private/var/mobile/Library/iFinder/qnua");
        NSString *gidchang;
        if (selecgid == -2) {
            gidchang = @"nobody";
        } else if (selecgid == -1) {
            gidchang = @"nogroup";
        } else if (selecgid == 0) {
            gidchang = @"wheel";
        } else if (selecgid == 1) {
            gidchang = @"daemon";
        } else if (selecgid == 2) {
            gidchang = @"kmem";
        } else if (selecgid == 3) {
            gidchang = @"sys";
        } else if (selecgid == 4) {
            gidchang = @"tty";
        } else if (selecgid == 5) {
            gidchang = @"operator";
        } else if (selecgid == 6) {
            gidchang = @"mail";
        } else if (selecgid == 7) {
            gidchang = @"bin";
        } else if (selecgid == 8) {
            gidchang = @"procview";
        } else if (selecgid == 9) {
            gidchang = @"procmod";
        } else if (selecgid == 10) {
            gidchang = @"owner";
        } else if (selecgid == 12) {
            gidchang = @"everyone";
        } else if (selecgid == 16) {
            gidchang = @"group";
        } else if (selecgid == 20) {
            gidchang = @"staff";
        } else if (selecgid == 25) {
            gidchang = @"_wireless";
        } else if (selecgid == 26) {
            gidchang = @"_lp";
        } else if (selecgid == 27) {
            gidchang = @"_postfix";
        } else if (selecgid == 28) {
            gidchang = @"_postdrop";
        } else if (selecgid == 29) {
            gidchang = @"certusers";
        } else if (selecgid == 30) {
            gidchang = @"_keytabusers";
        } else if (selecgid == 45) {
            gidchang = @"utmp";
        } else if (selecgid == 50) {
            gidchang = @"authedusers";
        } else if (selecgid == 51) {
            gidchang = @"interactusers";
        } else if (selecgid == 52) {
            gidchang = @"netusers";
        } else if (selecgid == 53) {
            gidchang = @"consoleusers";
        } else if (selecgid == 54) {
            gidchang = @"_mcxalr";
        } else if (selecgid == 55) {
            gidchang = @"_pcastagent";
        } else if (selecgid == 56) {
            gidchang = @"_pcastserver";
        } else if (selecgid == 58) {
            gidchang = @"_serialnumberd";
        } else if (selecgid == 59) {
            gidchang = @"_devdocs";
        } else if (selecgid == 60) {
            gidchang = @"_sandbox";
        } else if (selecgid == 61) {
            gidchang = @"localaccounts";
        } else if (selecgid == 62) {
            gidchang = @"netaccounts";
        } else if (selecgid == 64) {
            gidchang = @"_securityd";
        } else if (selecgid == 65) {
            gidchang = @"_mdnsresponder";
        } else if (selecgid == 66) {
            gidchang = @"_uucp";
        } else if (selecgid == 67) {
            gidchang = @"_ard";
        } else if (selecgid == 68) {
            gidchang = @"dialer";
        } else if (selecgid == 69) {
            gidchang = @"network";
        } else if (selecgid == 70) {
            gidchang = @"_www";
        } else if (selecgid == 72) {
            gidchang = @"_cvs";
        } else if (selecgid == 73) {
            gidchang = @"_svn";
        } else if (selecgid == 74) {
            gidchang = @"_mysql";
        } else if (selecgid == 75) {
            gidchang = @"_sshd";
        } else if (selecgid == 76) {
            gidchang = @"_qtss";
        } else if (selecgid == 78) {
            gidchang = @"_mailman";
        } else if (selecgid == 79) {
            gidchang = @"_appserverusr";
        } else if (selecgid == 80) {
            gidchang = @"admin";
        } else if (selecgid == 81) {
            gidchang = @"_appserveradm";
        } else if (selecgid == 82) {
            gidchang = @"_clamav";
        } else if (selecgid == 83) {
            gidchang = @"_amavisd";
        } else if (selecgid == 84) {
            gidchang = @"_jabber";
        } else if (selecgid == 85) {
            gidchang = @"_xgridcontroller";
        } else if (selecgid == 86) {
            gidchang = @"_xgridagent";
        } else if (selecgid == 87) {
            gidchang = @"_appowner";
        } else if (selecgid == 88) {
            gidchang = @"_windowserver";
        } else if (selecgid == 89) {
            gidchang = @"_spotlight";
        } else if (selecgid == 90) {
            gidchang = @"accessibility";
        } else if (selecgid == 91) {
            gidchang = @"_tokend";
        } else if (selecgid == 92) {
            gidchang = @"_securityagent";
        } else if (selecgid == 93) {
            gidchang = @"_calendar";
        } else if (selecgid == 94) {
            gidchang = @"_teamsserver";
        } else if (selecgid == 95) {
            gidchang = @"_update_sharing";
        } else if (selecgid == 96) {
            gidchang = @"_installer";
        } else if (selecgid == 97) {
            gidchang = @"_atsserver";
        } else if (selecgid == 98) {
            gidchang = @"_lpadmin";
        } else if (selecgid == 99) {
            gidchang = @"_unknown";
        } else if (selecgid == 501) {
            gidchang = @"mobile";
        }
        
        groupship = selecgid;
        
        if ([self.file isSymlink]){
            [[[section0 objectAtIndex:5] detailTextLabel] setText:gidchang];
            //[[[section0 objectAtIndex: 5] textLabel] setText:NSLocalizedString(@"Group ID", @"Group ID")];
        } else {
            [[[section0 objectAtIndex:4] detailTextLabel] setText:gidchang];
            //[[[section0 objectAtIndex: 4] textLabel] setText:NSLocalizedString(@"Group ID", @"Group ID")];
        }
    }
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

