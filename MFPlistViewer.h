//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import <UIKit/UIKit.h>
#import "MFFile.h"

enum MFPlistNodeType {
	MFPlistNodeTypeDictionary,
	MFPlistNodeTypeArray,
	MFPlistNodeTypeSimple,
    MFPlistNodeTypeInteger,
    MFPlistNodeTypeBool,
    MFPlistNodeTypeDate,
    MFPlistNodeTypeData,
    MFPlistNodeTypeString
};

typedef enum MFPlistNodeType MFPlistNodeType;

@interface MFPlistViewer: UIView <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	MFFile *plist;
	id root;
	UITableView *tableView;
	NSMutableArray *keys;
	NSMutableArray *values;
	NSMutableArray *types;
	MFPlistNodeType currentNodeType;
}

- (id) initWithFile: (MFFile *) file frame: (CGRect) theFrame;
- (void) loadRoot;
- (void) loadNode: (id) node;
- (void) loadDictionary: (NSDictionary *) dict;
- (void) loadArray: (NSArray *) array;
- (void) valuechangedbool:(id)sender;

@end

