//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <MediaPlayer/MediaPlayer.h>
#import "MFModalController.h"
#import "MFID3TagEditorController.h"
#import "MFFileType.h"
#import "MFFile.h"
#import "MFArchiveViewer.h"
#import "MFAudioPlayer.h"
#import "MFHexEditor.h"
#import "MFPlistViewer.h"
#import "MFSQLViewer.h"
#import "MFThread.h"
#import "MFLoadingView.h"

#import "MFNewBookmark.h"

@protocol MFFileViewerControllerDelegate;
	
@interface MFFileViewerController: MFModalController <UITextViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIPrintInteractionControllerDelegate, UISearchBarDelegate, MFThreadDelegate, UIDocumentInteractionControllerDelegate, UIAlertViewDelegate> {
	NSString *type;
	MFFile *file;
	MFArchiveViewer *archiveViewer;
	MFAudioPlayer *audioPlayer;
	MFHexEditor *hexEditor;
	MFPlistViewer *plistViewer;
	MFSQLViewer *sqlViewer;
//	MPMoviePlayerController *moviePlayer;
	UIWebView *webView;
	UITextView *textView;
	UIScrollView *scrollView;
	UIImageView *imageView;
	BOOL landscapeOnly;
	BOOL portraitOnly;
	id <MFFileViewerControllerDelegate> delegate;
    UIActionSheet *desconocido;
    UIActionSheet *plistfile;
    UISearchBar *search;
    CGPoint offset;
    int i;
    NSRange textRange;
    NSRange searchRange;
    NSMutableArray *array;
    UIActionSheet *imageoptions;
    UIImage *imagen;
    UIToolbar *toolbar;
    UIBarButtonItem *flexItem;
	UIBarButtonItem *toolbarItem_0;
	UIBarButtonItem *printdoc;
    UIBarButtonItem *printweb;
    UIBarButtonItem *toolbarItem_2;
    MFThread *restorethread;
    MFLoadingView *loadingView;
    UIActionSheet *restore;
    UIBarButtonItem *openin;
    UIBarButtonItem *bookmarfile;
    MFNewBookmark *newBookmark;
}

@property (retain) MFFile *file;
@property (retain) id <MFFileViewerControllerDelegate> delegate;
@property (retain) NSString *type;

- (id) initWithFile: (MFFile *) aFile;
- (id) initWithFile: (MFFile *) aFile type: (NSString *) theType;
- (void) save;
- (void) reloadAudioMetadata;
- (void) fit;
- (void) editId3Tags;
- (void) printdoc;
- (void) printweb;
- (void) selfdelete;
- (void) openother;

- (void) saveplist;
- (void) bookmark;

@end

@protocol MFFileViewerControllerDelegate

- (void) fileViewerDidFinishViewing: (MFFileViewerController *) fileViewer;

@end

