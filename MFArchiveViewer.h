//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <stdlib.h>
#import <unistd.h>
#import <UIKit/UIKit.h>
#import "MFFile.h"
#import "MFLoadingView.h"
#import "MFThread.h"
#import "zip.h"
#import "archive.h"
#import "archive_entry.h"
#import "MFCommandController.h"

@interface MFArchiveViewer: UIView <UITableViewDelegate, UITableViewDataSource, MFThreadDelegate, UIAlertViewDelegate> {
	UITableView *tableView;
	NSMutableArray *files;
	NSString *command;
	NSString *command2;
	MFFile *archive;
	MFLoadingView *loadingView;
	struct zip *zipfile;
	struct archive *a;
	struct archive_entry *entry;
    UIAlertView *respiring;
    NSString *what;
    UIAlertView *raralert;
    MFCommandController *commandexec;
    id fileViewer;
}

@property (retain) id fileViewer;

- (void) extractFile: (NSString *) path;
- (void) extractAll;
- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame;

@end

