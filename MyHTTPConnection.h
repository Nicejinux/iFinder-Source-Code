//
//  This class was created by Nonnus,
//  who graciously decided to share it with the CocoaHTTPServer community.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"
#import "MFFile.h"


@interface MyHTTPConnection : HTTPConnection
{
    int dataStartIndex;
    NSMutableArray* multipartData;
    BOOL postHeaderOK;
    MFFile *mffile;
}

- (BOOL)isBrowseable:(NSString *)path;
- (NSString *)createBrowseableIndex:(NSString *)path;

@end