//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <stdlib.h>
#import <MessageUI/MessageUI.h>
#import "MFCompressController.h"
#import "MFModalController.h"
#import "MFFile.h"
#import "MFFileManager.h"
#import "MFLoadingView.h"
#import "MFThread.h"
#import "MFFileViewerController.h"
#import "MFAPIDefines.h"
#import "MFID3Tag.h"
#import "MFModifyDate.h"
#import "MFModifyTime.h"
#import "MWPhotoBrowser.h"
#import "MFUIDSelect.h"
#import "MFGIDSelect.h"

#import "MFNewBookmark.h"

@protocol MFDetailsControllerDelegate;

@interface MFDetailsController: MFModalController <UITableViewDelegate, UITableViewDataSource, MFFileManagerDelegate, UITextFieldDelegate, MFThreadDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate> {
	NSMutableArray *sections;
	NSMutableArray *section0;
	NSMutableArray *section1;
	NSMutableArray *section2;
	NSMutableArray *section3;
	UITableView *tableView;
	UITextField *newName;
	UITextField *newChmod;
	UITextField *newUID;
	UITextField *newGID;
    UITextField *target;
	UITableViewCell *tempCell;
	MFFile *file;
	MFThread *md5calc;
	MFLoadingView *loadingView;
	MFFileViewerController *fileViewerController;
	MFMailComposeViewController *mailController;
	id <MFDetailsControllerDelegate> mainController;
	int fileQueueCount;
    NSMutableArray *tags;
    MFID3Tag *id3tag;
    UITextField *title;
	UITextField *artist;
	UITextField *album;
	UITextField *year;
    UITextField *genre;
    UITextField *lyricist;
	UITextField *language;
	UITextField *comments;
    NSMutableArray *dates;
    UITextField *created;
    NSString *myPath;
    NSFileManager *myManager;
    NSDictionary *myDict;
    NSDate * myDate;
    NSString *a;
    NSMutableArray *q;
    NSMutableArray *createdd;
    NSString *DateModified;
    NSString *TimeModified;
    MFModifyDate *modifyDate;
    UITextField *modifydate;
    UITextField *modifytime;
    UITextField *moddate;
    UITextField *modtime;
    MFModifyTime *modifyTime;
    int imagenabrir;
    MFUIDSelect *selectuid;
    NSUInteger selec;
    int ownership;
    MFGIDSelect *selectgid;
    NSUInteger selecgid;
    int groupship;
    
    MFNewBookmark *newBookmark;
}

@property (retain) MFFile *file;
@property (retain) id mainController;

- (id) initWithFile: (MFFile *) aFile;
- (void) calculateMd5;
- (void) upload: (NSString *) path;
- (void) done;

@end

@protocol MFDetailsControllerDelegate

- (void) detailsControllerDidClose: (MFDetailsController *) detailsController;


@end

