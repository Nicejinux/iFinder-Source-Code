//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>

@interface MFFileType: NSObject {
}

+ (NSString *) fileTypeForName: (NSString *) name;
+ (NSString *) mimeTypeForName: (NSString *) name;
+ (UIImage *) imageForType: (NSString *) type;
+ (UIImage *) imageForName: (NSString *) name;

@end

