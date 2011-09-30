//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFModalController.h"
#import "MFFile.h"
#import "MFID3Tag.h"

@interface MFID3TagEditorController: MFModalController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	MFID3Tag *id3tag;
	UITableView *tableView;
	UITextField *title;
	UITextField *artist;
	UITextField *album;
	UITextField *year;
	UITextField *genre;
	UITextField *lyricist;
	UITextField *language;
	UITextField *comments;
	id mainController;
    BOOL keyboardVisible;
    CGPoint offset;
}

@property (retain) id mainController;

- (id) initWithTag: (MFID3Tag *) aTag;
- (UIImage *) normalizedImage: (UIImage *) image;
- (void) done;
-(void) keyboardDidShow:(NSNotification *) notification;

@end
