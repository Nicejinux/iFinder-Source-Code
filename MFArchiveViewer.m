//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFArchiveViewer.h"

@implementation MFArchiveViewer

@synthesize fileViewer = fileViewer;

// super

- (void) dealloc {

	[tableView release];
            tableView = nil;
	[files release];
        files = nil;
        [archive release];
	
	[super dealloc];
	
}

// self

- (void) extractFile: (NSString *) path {

	/*loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
	[loadingView show];*/

	NSString *cmd;

	if ([[[archive name] pathExtension] isEqualToString: @"tar"] || [[[archive name] pathExtension] isEqualToString: @"gz"] || [[[archive name] pathExtension] isEqualToString: @"tgz"] || [[[archive name] pathExtension] isEqualToString: @"bz2"]) {
		cmd = [NSString stringWithFormat: @"cd %@; tar --overwrite --preserve-permissions --same-owner -xzf '%@' '%@'", archive.path, [archive.path stringByAppendingPathComponent: archive.name], path];
    } else if ([[[archive name] pathExtension] isEqualToString: @"xar"]) {
        cmd = [NSString stringWithFormat: @"cd %@; xar -xf '%@' '%@'", archive.path, [archive.path stringByAppendingPathComponent: archive.name], path];
	} else if ([[[archive name] pathExtension] isEqualToString: @"rar"]) {
        cmd = [NSString stringWithFormat: @"cd %@; unrar x '%@' '%@'", archive.path, [archive.path stringByAppendingPathComponent: archive.name], path];
    } else {
		cmd = [NSString stringWithFormat: @"cd %@; unzip -o '%@' '%@'", archive.path, [archive.path stringByAppendingPathComponent: archive.name], path];
	}
	
	/*MFThread *unarchiver = [[[MFThread alloc] init] autorelease];
	unarchiver.cmd = cmd;
	unarchiver.delegate = self;
	[unarchiver start];*/
    
    commandexec = [[MFCommandController alloc] initWithCommand:cmd];
    [commandexec start];
    [commandexec presentFrom:[[self fileViewer ]self]];
    [commandexec release];

}

- (void) extractAll {

	/*loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
	[loadingView show];*/

	if ([[[archive name] pathExtension] isEqualToString: @"tar"] || [[[archive name] pathExtension] isEqualToString: @"gz"] || [[[archive name] pathExtension] isEqualToString: @"tgz"] || [[[archive name] pathExtension] isEqualToString: @"bz2"] ) {
		command = [NSString stringWithFormat: @"cd %@; tar --overwrite --preserve-permissions --same-owner -xzf '%@'", archive.path, [archive.path stringByAppendingPathComponent: archive.name]];
    } else if ([[[archive name] pathExtension] isEqualToString: @"xar"]) {
        command = [NSString stringWithFormat: @"cd %@; xar -xf '%@'", archive.path, [archive.path stringByAppendingPathComponent: archive.name]];
	} else if ([[[archive name] pathExtension] isEqualToString: @"rar"]) {
        command = [NSString stringWithFormat: @"cd %@; unrar x '%@'", archive.path, [archive.path stringByAppendingPathComponent: archive.name]];
    }else {
		command = [NSString stringWithFormat: @"cd %@; unzip -o '%@'", archive.path, [archive.path stringByAppendingPathComponent: archive.name]];
	}
	
	/*MFThread *unarchiver = [[[MFThread alloc] init] autorelease];
	unarchiver.cmd = command;
	unarchiver.delegate = self;
	[unarchiver start];*/
    
    commandexec = [[MFCommandController alloc] initWithCommand:command];
    [commandexec start];
    [commandexec presentFrom:[[self fileViewer ]self]];
    [commandexec release];            
	
}

- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame {

	self = [super initWithFrame: theFrame];
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	archive = [file retain];

	if ([[[archive name] pathExtension] isEqualToString: @"tar"] || [[[archive name] pathExtension] isEqualToString: @"gz"] || [[[archive name] pathExtension] isEqualToString: @"tgz"] || [[[archive name] pathExtension] isEqualToString: @"bz2"] || [[[archive name] pathExtension] isEqualToString: @"xar"]) {
	
		a = archive_read_new();
		files = [[NSMutableArray alloc] init];
		archive_read_support_compression_all(a);
		archive_read_support_format_all(a);
		archive_read_open_filename(a, [[archive.path stringByAppendingPathComponent: archive.name] UTF8String], 8192);
		while (archive_read_next_header(a, &entry) == ARCHIVE_OK) {
			[files addObject: [NSString stringWithUTF8String: archive_entry_pathname(entry)]];
		}
		archive_read_finish(a);

	} else if ([[[archive name] pathExtension] isEqualToString: @"zip"]) {
	
		zipfile = zip_open ([[archive.path stringByAppendingPathComponent: archive.name] UTF8String], 0, NULL);
		files = [[NSMutableArray alloc] init];
		int items = zip_get_num_entries (zipfile, 0);
		
		for (int i = 0; i < items; i++) {
			[files addObject: [[NSString stringWithUTF8String: zip_get_name (zipfile, i, 0)] retain]];
		}
		
		zip_close (zipfile);
		
	} else if ([[[archive name] pathExtension] isEqualToString: @"deb"]) {
		command = [[NSString alloc] initWithFormat: @"dpkg -i '%@'", [archive.path stringByAppendingPathComponent: archive.name]];
		files = [[NSMutableArray arrayWithObjects: NSLocalizedString(@"Install package", @"Install package"), NSLocalizedString(@"Extract Package", @"Extract Package"), nil] retain];
        command2 = [[NSString alloc] initWithFormat: @"/usr/bin/7z x -y -o'%@/%@' '%@'", archive.path, [archive.name stringByReplacingOccurrencesOfString:@".deb" withString:@""], [archive.path stringByAppendingPathComponent: archive.name]];
	} else if ([[[archive name] pathExtension] isEqualToString: @"rar"]){
        raralert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Rar File", @"Rar File") message:NSLocalizedString(@"Viewing the content of Rar files is still not supported, but you cant extract it", @"Viewing the content of Rar files is still not supported, but you cant extract it")
                                              delegate:self cancelButtonTitle:NSLocalizedString(@"No Thanks", @"No Thanks") otherButtonTitles:NSLocalizedString(@"Yes, Extract it", @"Yes, Extract it"), nil];
        raralert.tag = 2;
        [raralert show];
        [raralert release];
    }
	
	tableView = [[UITableView alloc] initWithFrame: theFrame];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self addSubview: tableView];
	
	return self;

}

// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return [files count];

}

- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFAVCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"MFAVCell"];
	}

	cell.text = [[files objectAtIndex: indexPath.row] retain];

	return cell;

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	if ([[[archive name] pathExtension] isEqualToString: @"deb"]) {
		if([[files objectAtIndex: indexPath.row] isEqualToString:NSLocalizedString(@"Install package", @"Install package")]){
            /*loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeInstalling];
            [loadingView show];
            MFThread *installer = [[[MFThread alloc] init] autorelease];
            installer.cmd = command;
            installer.delegate = self;
            [installer start];
            what = @"install";*/
            
            commandexec = [[MFCommandController alloc] initWithCommand:command];
            [commandexec start];
            [commandexec presentFrom:[[self fileViewer ]self]];
            [commandexec release];
        }else{
            /*loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
            [loadingView show];
            MFThread *installer = [[[MFThread alloc] init] autorelease];
            installer.cmd = command2;
            installer.delegate = self;
            [installer start];*/
            
            commandexec = [[MFCommandController alloc] initWithCommand:command2];
            [commandexec start];
            [commandexec presentFrom:[[self fileViewer ]self]];
            [commandexec release];            
            
            /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"File Extracted", @"File Extracted") message:[NSString stringWithFormat:@"%@ %@/%@", NSLocalizedString(@"Your Files were extracted to", @"Your Files were extracted to"), archive.path, [archive.name stringByReplacingOccurrencesOfString:@".deb" withString:@""]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil];
            [alert show];
            [alert release];*/
            what = @"extract";
        }
	} else {
		[self extractFile: [files objectAtIndex: indexPath.row]];
	}
	
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
}

// MFThreadDelegate

/*- (void) threadEnded: (MFThread *) thread {

	[loadingView hide];
	if (thread.exitCode != 0) {
	
		UIAlertView *av = [[UIAlertView alloc] init];
		av.title = NSLocalizedString(@"Error executing command", @"Error executing command");
		NSString *msgBody = [NSString stringWithFormat:	@"%@: %@\n"
								@"%@: %i\n"
								@"Thread: %@\n", NSLocalizedString(@"Failed command", @"Failed command"),
								thread.cmd, NSLocalizedString(@"Exit code", @"Exit code"), thread.exitCode, thread
		];
		av.message = msgBody;
		[av addButtonWithTitle: NSLocalizedString(@"Dismiss", @"Dismiss")];
		[av show];
		[av release];
	}else if ([[[archive name] pathExtension] isEqualToString: @"deb"] && [what isEqualToString:@"install"]) {
        respiring = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Installed Succesfully", @"Installed Succesfully") message:NSLocalizedString(@"Would you like to restart SpringBoard?", @"Would you like to restart SpringBoard?")
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"No") otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
        respiring.tag = 1;
        [respiring show];
        [respiring release];

    }

}*/

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1 & actionSheet.tag==1)
    {
        system("killall SpringBoard");
    }
    else if (buttonIndex == 0 & actionSheet.tag==2)
    {}
    else if (buttonIndex == 1 & actionSheet.tag==2)
    {
        /*loadingView = [[MFLoadingView alloc] initWithType: MFLoadingViewTypeTemporary];
        [loadingView show];*/
        NSString *cmd;
        NSString *folder = [archive.name stringByDeletingPathExtension];
        cmd = [NSString stringWithFormat: @"mkdir -p '%@/%@';cd %@; unrar x -y '%@' '%@/%@'", archive.path, folder, archive.path, [archive.path stringByAppendingPathComponent: archive.name], archive.path, folder];
        /*MFThread *unarchiver = [[[MFThread alloc] init] autorelease];
        unarchiver.cmd = cmd;
        unarchiver.delegate = self;
        [unarchiver start];*/
        
        commandexec = [[MFCommandController alloc] initWithCommand:cmd];
        [commandexec start];
        [commandexec presentFrom:[[self fileViewer ]self]];
        [commandexec release];
    }
}

@end

