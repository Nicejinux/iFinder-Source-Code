//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFID3Tag.h"

@implementation MFID3Tag

// self

- (id) initWithFileName: (NSString *) fileName {
    
	self = [super init];
    
	if ((fileName != nil) && (![fileName isEqualToString: @""])) {
        
		file = id3_file_open ([fileName UTF8String], ID3_FILE_MODE_READWRITE);
        
	}
    
	if (file != NULL) {
        
		tag = id3_file_tag (file);
        
	}
    
	return self;
    
}

- (NSString *) frameDataForId: (char *) frameId {
    
	struct id3_frame *frm = id3_tag_findframe (tag, frameId, 0);
	if (frm == NULL) {
		return nil;
	}
    
	union id3_field *field = &frm->fields[1];
	int n = id3_field_getnstrings (field);
	if (n == 0) {
		return nil;
	}
    
	id3_ucs4_t *buf = id3_field_getstrings (field, 0);
	NSString *val = [NSString stringWithUTF8String: id3_ucs4_latin1duplicate (buf)];
    
	return val;
    
}

- (BOOL) setFrameData: (NSString *) value forId: (char *) frameId {
    
	if (value == nil) {
		return NO;
	}
    
	struct id3_frame *frm = id3_tag_findframe (tag, frameId, 0);
    
	BOOL frameIsNew = NO;
	if (frm == NULL) {
		frm = id3_frame_new (frameId);
		frameIsNew = YES;
	}
	if (frm == NULL ) {
		return NO;
	}
    
	id3_ucs4_t *ptr;
	ptr = id3_latin1_ucs4duplicate([value UTF8String]);
	if (id3_field_setstrings (&frm->fields[1], 1, &ptr) == -1) {
		return NO;
	}
    
	if (frameIsNew) {
		if (id3_tag_attachframe (tag, frm) == -1) {
			return NO;
		}
	}
    
	if (id3_file_update (file) == -1) {
		return NO;
	}
    
	return YES;
    
}

- (NSString *) songTitle {
    
	return [self frameDataForId: ID3_FRAME_TITLE];
    
}

- (BOOL) setSongTitle: (NSString *) data {
    
	return [self setFrameData: data forId: ID3_FRAME_TITLE];
    
}

- (NSString *) artist {
    
	return [self frameDataForId: ID3_FRAME_ARTIST];
    
}

- (BOOL) setArtist: (NSString *) data {
    
	return [self setFrameData: data forId: ID3_FRAME_ARTIST];
    
}

- (NSString *) album {
    
	return [self frameDataForId: ID3_FRAME_ALBUM];
    
}

- (BOOL) setAlbum: (NSString *) data {
    
	return [self setFrameData: data forId: ID3_FRAME_ALBUM];
    
}

- (NSString *) year {
    
	return [self frameDataForId: ID3_FRAME_YEAR];
    
}

- (BOOL) setYear: (NSString *) data {
    
	return [self setFrameData: data forId: ID3_FRAME_YEAR];
    
}

- (NSString *) genre {
    
	NSString *genre;
	NSString *numGenre = [self frameDataForId: ID3_FRAME_GENRE];
	if (numGenre == nil) {
		genre = nil;
	} else {
		NSArray *genres = [[NSArray alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"genres" ofType: @"plist"]];
		if ([numGenre intValue] >= [genres count]) {
			genre = nil;
		} else {
			genre = [[genres objectAtIndex: [numGenre intValue]] copy];
		}
		[genres release];
	}
    
	return genre;
    
}

- (BOOL) setGenre: (NSString *) data {
    
	NSString *genreId;
	BOOL genreIsValid = NO;
	NSArray *genres = [[NSArray alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"genres" ofType: @"plist"]];
	for (int i = 0; i < [genres count]; i++) {
		if ([[[genres objectAtIndex: i] lowercaseString] isEqualToString: [data lowercaseString]]) {
			genreId = [NSString stringWithFormat: @"%i", i];
			genreIsValid = YES;
			break;
		}
	}
	[genres release];
	if (!genreIsValid) {
		return NO;
	}
	return [self setFrameData: genreId forId: ID3_FRAME_GENRE];
    
}

- (NSString *) lyricist {
    
	return [self frameDataForId: "TEXT"];
    
}

- (BOOL) setLyricist: (NSString *) data {
    
	return [self setFrameData: data forId: "TEXT"];
    
}

- (NSString *) language {
    
	return [self frameDataForId: "TLAN"];
    
}

- (BOOL) setLanguage: (NSString *) data {
    
	return [self setFrameData: data forId: "TLAN"];
    
}

- (NSString *) comments {
    
	struct id3_frame *frm = id3_tag_findframe (tag, ID3_FRAME_COMMENT, 0);
	if (frm == NULL) {
		return nil;
	}
    
	union id3_field *field = &frm->fields[3];
    
	id3_ucs4_t *buf = id3_field_getfullstring (field);
	NSString *val = [NSString stringWithUTF8String: id3_ucs4_latin1duplicate (buf)];
    
	return val;
    
}

- (BOOL) setComments: (NSString *) data {
    
	if (data == nil) {
		return NO;
	}
    
	struct id3_frame *frm = id3_tag_findframe (tag, ID3_FRAME_COMMENT, 0);
    
	BOOL frameIsNew = NO;
	if (frm == NULL) {
		frm = id3_frame_new (ID3_FRAME_COMMENT);
		frameIsNew = YES;
	}
	if (frm == NULL ) {
		return NO;
	}
    
	id3_ucs4_t *ptr = id3_latin1_ucs4duplicate([data UTF8String]);
	if (id3_field_setfullstring (&frm->fields[3], ptr) == -1) {
		return NO;
	}
    
	if (frameIsNew) {
		if (id3_tag_attachframe (tag, frm) == -1) {
			return NO;
		}
	}
    
	if (id3_file_update (file) == -1) {
		return NO;
	}
    
	return YES;
    
}



// super

- (void) dealloc {
    
	id3_file_close (file);
    
	[super dealloc];
    
}

@end