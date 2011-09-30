//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>

typedef enum {
	MFLoadingViewTypeProgress = 0,
	MFLoadingViewTypeTemporary = 1,
    MFLoadingViewTypeCopying = 2,
    MFLoadingViewTypeMoving = 3,
    MFLoadingViewTypeCompressing = 4,
    MFLoadingViewTypeInstalling = 5,
    MFLoadingViewTypeBackuping = 6,
    MFLoadingViewTypeRestoring = 7,
    MFLoadingViewTypeValidating = 8
} MFLoadingViewType;

@interface MFLoadingView: UIView {
        UIImageView *background;
        UIProgressView *progressBar;
        UIActivityIndicatorView *spinwheel;
        UILabel *text;
}

- (id) initWithType: (MFLoadingViewType) type;
- (void) show;
- (void) hide;
- (void) setProgress: (float) progress;
- (void) setTitle: (NSString *) title;

@end
