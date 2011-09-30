//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import <UIKit/UIKit.h>


@interface MFModifyDate : UIViewController <UIPickerViewDelegate> {
    UIDatePicker *picker;
    NSDate *date;
    NSString *dateshow;
    NSString *changed;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *dateshow;
@property (nonatomic, retain) NSString *changed;

@end
