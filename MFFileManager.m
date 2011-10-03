//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFFileManager.h"

@implementation MFFileManager

@synthesize delegate = delegate;
@synthesize userID = userID;

// super

- (id) init {

	self = [super init];
	
	fileManager = [[NSFileManager alloc] init];
	session = [[DBSession alloc] initWithConsumerKey: DROPBOXCONSUMERKEY consumerSecret: DROPBOXCONSUMERSECRET];
	[DBSession setSharedSession: session];
	[session release];
	restClient = [[DBRestClient alloc] initWithSession: [DBSession sharedSession]];
	restClient.delegate = self;

	return self;

}

// self

- (NSMutableArray *) contentsOfDirectory: (NSString *) path {

	BOOL isDir;
	struct stat attributes;
	float fs;
	char prefix;
	NSArray *cnt = [fileManager contentsOfDirectoryAtPath: path error: NULL];
	NSMutableArray *contents = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < [cnt count]; i++) {

		NSString *fileName = [path stringByAppendingPathComponent: [cnt objectAtIndex: i]];
		isDir = [self fileIsDirectory: fileName];
		stat ([fileName UTF8String], &attributes);

		MFFile *file = [[MFFile alloc] init];
		file.path = path;
		file.name = [cnt objectAtIndex: i];
		file.type = [MFFileType fileTypeForName: [cnt objectAtIndex: i]];
		file.mime = [MFFileType mimeTypeForName: [cnt objectAtIndex: i]];
		file.isDirectory = isDir;
        file.isSymlink = (readlink([fileName UTF8String], NULL, 0) != -1);
		if (attributes.st_size > 1024 * 1024 * 1024) {
			fs = (float)attributes.st_size / (1024.0 * 1024.0 * 1024.0);
			prefix = 'G';
		} else if (attributes.st_size > 1024 * 1024) {
			fs = (float)attributes.st_size / (1024.0 * 1024.0);
			prefix = 'M';
		} else if (attributes.st_size > 1024) {
			fs = (float)attributes.st_size / 1024.0;
			prefix = 'k';
		} else {
			fs = (float)attributes.st_size;
			prefix = NULL;
		}
		file.fsize = [NSString stringWithFormat: @"%.2f %cB", fs, prefix];
		file.bytessize = attributes.st_size;
		file.permissions = [NSString stringWithFormat: @"%04o", attributes.st_mode & 07777];
		file.owner = attributes.st_uid;
		file.group = attributes.st_gid;
        //file.lastaccess = [NSString stringWithFormat:@"%", attributes.st_mtimespec];
        file.lastaccess = [NSString stringWithFormat:@"%04o",attributes.st_ctimespec];
        file.createddate = [NSString stringWithFormat:@"%04o",attributes.st_birthtimespec];
		[contents addObject: file];
		[file release];

	}
	
	NSMutableArray *dirs = [[NSMutableArray alloc] init];
	NSMutableArray *files = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [contents count]; i++) {
	
		if ([[contents objectAtIndex: i] isDirectory]) {
		
			[dirs addObject: [contents objectAtIndex: i]];
			
		} else {
		
			[files addObject: [contents objectAtIndex: i]];
			
		}
		
	}
	
	[contents removeAllObjects];
	
	for (int i = 0; i < [dirs count]; i++) {
	
		for (int j = 0; j < i; j++) {
		
			if ([[[dirs objectAtIndex: i] name] compare: [[dirs objectAtIndex: j] name] options: NSCaseInsensitiveSearch] == NSOrderedAscending) {
			
				[dirs exchangeObjectAtIndex: i withObjectAtIndex: j];
				
			}
			
		}
		
	}

	for (int i = 0; i < [files count]; i++) {
	
		for (int j = 0; j < i; j++) {
		
			if ([[[files objectAtIndex: i] name] compare: [[files objectAtIndex: j] name] options: NSCaseInsensitiveSearch] == NSOrderedAscending) {
			
				[files exchangeObjectAtIndex: i withObjectAtIndex: j];
				
			}
			
		}
		
	}

	[contents addObjectsFromArray: dirs];
	//[contents addObjectsFromArray: files];

    /*NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) {
        if ([[obj1 fsize] integerValue] > [[obj2 fsize] integerValue]) { 
            return (NSComparisonResult)NSOrderedDescending;
        } else if ([[obj1 fsize] integerValue] < [[obj2 fsize] integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    };*/
    seteuid(501);
    SortOrder = [[NSUserDefaults standardUserDefaults] integerForKey:@"SortOrder"];
    seteuid(0);
    
    ////////Ordenar Por Tipo
    if (SortOrder == 0) {
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
    } else if (SortOrder == 1) {
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:NO];
    } else {
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
    }
    
    ////////Ordenar Por Tamaño
    if (SortOrder == 0) {
        descriptor2 = [[NSSortDescriptor alloc] initWithKey:@"bytessize" ascending:YES];
    } else if (SortOrder == 1) {
        descriptor2 = [[NSSortDescriptor alloc] initWithKey:@"bytessize" ascending:NO];
    } else {
        descriptor2 = [[NSSortDescriptor alloc] initWithKey:@"bytessize" ascending:YES];
    }
    
    ////////Ordenar Por Modificado
    if (SortOrder == 0) {
        descriptor3 = [[NSSortDescriptor alloc] initWithKey:@"lastaccess" ascending:YES];
    } else if (SortOrder == 1) {
        descriptor3 = [[NSSortDescriptor alloc] initWithKey:@"lastaccess" ascending:NO];
    } else {
        descriptor3 = [[NSSortDescriptor alloc] initWithKey:@"lastaccess" ascending:YES];
    }
    
    ////////Ordenar Por Creacion
    if (SortOrder == 0) {
        descriptor4 = [[NSSortDescriptor alloc] initWithKey:@"createddate" ascending:YES];
    } else if (SortOrder == 1) {
        descriptor4 = [[NSSortDescriptor alloc] initWithKey:@"createddate" ascending:NO];
    } else {
        descriptor4 = [[NSSortDescriptor alloc] initWithKey:@"createddate" ascending:YES];
    }
    
    /////////Ordenar Por Nombre
    if (SortOrder == 0) {
        descriptor5 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    } else if (SortOrder == 1) {
        descriptor5 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    } else {
        descriptor5 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    }

    NSMutableArray *sorted =[[NSMutableArray alloc] init];
    //[sorted addObjectsFromArray: [files sortedArrayUsingComparator:sortBlock]]
    
    seteuid(501);
    SortCriteria = [[NSUserDefaults standardUserDefaults] integerForKey:@"SortCriteria"];
    SortOrder = [[NSUserDefaults standardUserDefaults] integerForKey:@"SortOrder"];
    seteuid(0);
    
    if (SortCriteria == 0) {
        if (SortOrder == 0) {
            [sorted addObjectsFromArray:dirs];
            [sorted addObjectsFromArray:files];
        } else if (SortOrder == 1) {
            [sorted addObjectsFromArray:[[dirs reverseObjectEnumerator] allObjects]];
            [sorted addObjectsFromArray:[[files reverseObjectEnumerator] allObjects]];
        } else {
            [sorted addObjectsFromArray:dirs];
            [sorted addObjectsFromArray:files];
        }
        [contents removeAllObjects];
        [contents addObjectsFromArray:sorted];
    } else if (SortCriteria == 1) {
        [sorted addObjectsFromArray: [files sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor]]];
        [contents addObjectsFromArray: sorted];
    } else if (SortCriteria == 2) {
        [sorted addObjectsFromArray: [files sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor2]]];
        [contents addObjectsFromArray: sorted];
    } else if (SortCriteria == 3) {
        [sorted addObjectsFromArray: [files sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor4]]];
        [contents addObjectsFromArray: sorted];
    } else if (SortCriteria == 4) {
        [sorted addObjectsFromArray: [files sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor3]]];
        [contents addObjectsFromArray: sorted];
    } else {
        if (SortOrder == 0) {
            [sorted addObjectsFromArray:dirs];
            [sorted addObjectsFromArray:files];
        } else if (SortOrder == 1) {
            [sorted addObjectsFromArray:[[dirs reverseObjectEnumerator] allObjects]];
            [sorted addObjectsFromArray:[[files reverseObjectEnumerator] allObjects]];
        } else {
            [sorted addObjectsFromArray:dirs];
            [sorted addObjectsFromArray:files];
        }
        [contents removeAllObjects];
        [contents addObjectsFromArray:sorted];
    }
    //[contents removeAllObjects];
    [sorted release];
    sorted = nil;
	[dirs release];
	dirs = nil;
	[files release];
	files = nil;

	return contents;

}

NSInteger compareInfo(id aInfo1, id aInfo2, void *context){
    NSDate* info1 = [aInfo1 objectAtIndex:2];
    NSDate* info2 = [aInfo2 objectAtIndex:2];
    return [info1 compare:info2];
}

- (BOOL) fileIsDirectory: (NSString *) path {

	BOOL isDirectory;
	[fileManager fileExistsAtPath: path isDirectory: &isDirectory];
	
	return isDirectory;
	
}

- (void) createFile: (NSString *) path isDirectory: (BOOL) dir {

	if (dir) {
		[fileManager createDirectoryAtPath: path withIntermediateDirectories: YES attributes: nil error: NULL];
	} else {
		[fileManager createFileAtPath: path contents: nil attributes: nil];
	}

}

- (void) deleteFile: (NSString *) path {

	char *cmd = [[NSString stringWithFormat: @"rm -rf %@", path] UTF8String];
	system (cmd);

}

- (void) copyFile: (NSString *) path1 toPath:  (NSString *) path2 {

	[fileManager copyItemAtPath: path1 toPath: path2 error: NULL];

}

- (void) moveFile: (NSString *) path1 toPath: (NSString *) path2 {

	[fileManager moveItemAtPath: path1 toPath: path2 error: NULL];

}

- (void) chmodFile: (NSString *) path permissions: (NSString *) permissions {

	if ([permissions length] == 4) {

		int permissionsOctal = 0;
		for (int i = 0; i < 4; i++) {

			char c = [permissions characterAtIndex: i];
			permissionsOctal += atoi(&c) * pow(8, 3 - i);
		
		}
	
		chmod ([path UTF8String], permissionsOctal);
		
	}
		
}
	
- (void) chownFile: (NSString *) file user: (int) user group: (int) group {


	chown([file UTF8String], user, group);

}


- (void) dbLoadMetadata: (NSString *) path {

	[restClient loadMetadata: path];
	
}

- (void) dbLoadUserInfo {

	[restClient loadAccountInfo];
	
}

- (void) dbDownloadFile: (NSString *) path {

	[restClient loadFile: path intoPath: [@"/var/mobile/Documents" stringByAppendingPathComponent: [path lastPathComponent]]];
	
}

- (void) dbUploadFile: (NSString *) path1 toPath: (NSString *) path2 {

	[restClient loadAccountInfo];
	[restClient uploadFile: [path1 lastPathComponent] toPath: path2 fromPath: path1];
		
}

- (void) dbCreateDirectory: (NSString *) path {

	[restClient createFolder: path];
	
}

- (void) dbDeleteFile: (NSString *) path {

	[restClient deletePath: path];
	
}

// DBRestClientDelegate

- (void) restClient: (DBRestClient *) client loadedMetadata: (DBMetadata *) metadata {

	[self.delegate fileManagerDBLoadedMetadata: metadata];
	
}

- (void) restClient: (DBRestClient *) client loadMetadataFailedWithError: (NSError *) error {

	[self.delegate fileManagerDBLoadMetadataFailed];
	
}

- (void) restClient: (DBRestClient *) client loadedAccountInfo: (DBAccountInfo *) accountInfo {

	self.userID = accountInfo.userId;
	
}

- (void) restClient: (DBRestClient *) client loadAccountInfoFailedWithError: (NSError * )error {

	self.userID = nil;
	
}

- (void) restClient: (DBRestClient *) client loadedFile: (NSString *) path {

	[self.delegate fileManagerDBDownloadedFile: path];
	
}

- (void) restClient: (DBRestClient *) client loadProgress: (CGFloat) progress forFile: (NSString *) path {

	[self.delegate fileManagerDBDownloadProgress: progress forFile: path];
	
}

- (void) restClient: (DBRestClient *) client loadFileFailedWithError: (NSError *) error {

	[self.delegate fileManagerDBDownloadFileFailed];
	
}

- (void) restClient: (DBRestClient *) client uploadedFile: (NSString *) destPath from: (NSString *) srcPath {

	[self.delegate fileManagerDBUploadedFile: destPath];
	
}

- (void) restClient: (DBRestClient *) client uploadProgress: (CGFloat) progress forFile: (NSString *) destPath from: (NSString *) srcPath {

	[self.delegate fileManagerDBUploadProgress: progress forFile: destPath];
	
}

- (void) restClient: (DBRestClient *) client uploadFileFailedWithError: (NSError *) error {

	[self.delegate fileManagerDBUploadFileFailed];
	
}

- (void) restClient: (DBRestClient*) client createdFolder: (DBMetadata*) folder {

	[self.delegate fileManagerDBCreatedDirectory: folder.path];
	
}

- (void) restClient: (DBRestClient *) client createFolderFailedWithError: (NSError *) error {

	[self.delegate fileManagerDBCreateDirectoryFailed];
	
}

- (void) restClient: (DBRestClient *) client deletedPath: (NSString *) path {

	[self.delegate fileManagerDBDeletedFile: path];
	
}

- (void) restClient: (DBRestClient *) client deletePathFailedWithError: (NSError*) error {

	[self.delegate fileManagerDBDeleteFileFailed];
	
}

@end


