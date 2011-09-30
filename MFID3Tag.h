//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "id3tag.h"
#import <Foundation/Foundation.h>
#import "MFFile.h"

@interface MFID3Tag: NSObject {
	struct id3_file *file;
	struct id3_tag *tag;
}

- (id) initWithFileName: (NSString *) fileName;
- (NSString *) frameDataForId: (char *) frameId;
- (BOOL) setFrameData: (NSString *) value forId: (char *) frameId;

- (NSString *) songTitle;
- (BOOL) setSongTitle: (NSString *) data;
- (NSString *) artist;
- (BOOL) setArtist: (NSString *) data;
- (NSString *) album;
- (BOOL) setAlbum: (NSString *) data;
- (NSString *) year;
- (BOOL) setYear: (NSString *) data;
- (NSString *) genre;
- (BOOL) setGenre: (NSString *) data;
- (NSString *) lyricist;
- (BOOL) setLyricist: (NSString *) data;
- (NSString *) language;
- (BOOL) setLanguage: (NSString *) data;
- (NSString *) comments;
- (BOOL) setComments: (NSString *) data;

@end