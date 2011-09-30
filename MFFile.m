//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFFile.h"

@implementation MFFile

@synthesize name = name;
@synthesize path = path;
@synthesize type = type;
@synthesize mime = mime;
@synthesize isDirectory = isDirectory;
@synthesize isSymlink = isSymlink;
@synthesize fsize = fsize;
@synthesize permissions = permissions;
@synthesize owner = owner;
@synthesize group = group;
@synthesize bytessize = bytessize;
@synthesize lastaccess = lastaccess;
@synthesize createddate = createddate;

- (NSString *) fullPath {
    
    return [self.path stringByAppendingPathComponent: self.name];
    
}

@end

