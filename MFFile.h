//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <sys/types.h>
#import <Foundation/Foundation.h>

@interface MFFile: NSObject {
	NSString *name;
	NSString *path;
	NSString *type;
	NSString *mime;
	BOOL isDirectory;
	BOOL isSymlink;
	NSString *fsize;
	NSString *permissions;
	unsigned int owner;
	unsigned int group;
	unsigned int bytessize;
    NSString *lastaccess;
    NSString *createddate;
}

@property (copy) NSString *name;
@property (copy) NSString *path;
@property (copy) NSString *type;
@property (copy) NSString *mime;
@property BOOL isDirectory;
@property BOOL isSymlink;
@property (copy) NSString *fsize;
@property (copy) NSString *permissions;
@property unsigned int owner;
@property unsigned int group;
@property unsigned int bytessize;
@property (copy) NSString *lastaccess;
@property (copy) NSString *createddate;

- (NSString *) fullPath;

@end
