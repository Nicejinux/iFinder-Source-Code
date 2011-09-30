//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFModalController.h"
#import "MFLoadingView.h"
#import "MFThread.h"

@interface MFCompressMultipleController: MFModalController <UITextFieldDelegate, MFThreadDelegate> {
        NSMutableArray *files;
        NSArray *compressCommands;
        MFLoadingView *loadingView;
        MFThread *thread;
        UITextField *fileName;
        UISegmentedControl *type;
        UIButton *doCompress;
        id mainController;
}

@property (retain) id mainController;

- (id) init;
- (void) compress;

@end
