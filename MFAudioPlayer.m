//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import "MFAudioPlayer.h"

@implementation MFAudioPlayer

@synthesize id3tag = id3tag;
@synthesize controller = controller;

// self

- (id) initWithFile: (MFFile *) aFile {

	self = [super initWithFrame: CGRectMake (0, 0, 320, 460)];
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	file = [aFile retain];
	
	NSURL *url = [NSURL fileURLWithPath: [file fullPath]];
	id3tag = [[MFID3Tag alloc] initWithFileName: [file fullPath]];
	musicControls = [[NSMutableArray alloc] init];
	playMode = MFAudioPlayerPlayModeContinuous;
	playModeTitles = [[NSArray alloc] initWithObjects: NSLocalizedString(@"Play once", @"Play once"), NSLocalizedString(@"Repeat", @"Repeat"), NSLocalizedString(@"Continuous", @"Continuous"), NSLocalizedString(@"Shuffle", @"Shuffle"), nil];
       	srandom (time (NULL));

	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];


	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: NULL];
	audioPlayer.delegate = self;
	audioPlayer.volume = 0.5;
	audioPlayer.numberOfLoops = 0;
	[audioPlayer play];
	
	topBar = [[UIView alloc] initWithFrame: CGRectMake (0, 0, 320, 80)];
	topBar.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.9];
	[self addSubview: topBar];
	[topBar release];
	bottomBar = [[UIToolbar alloc] initWithFrame: CGRectMake (0, 332, 320, 52)];
	bottomBar.barStyle = UIBarStyleBlack;
	[self addSubview: bottomBar];
	[bottomBar release];
	bottomView = [[UIView alloc] initWithFrame: CGRectMake (0, 384, 320, 32)];
	bottomView.backgroundColor = [UIColor blackColor];
	[self addSubview: bottomView];
	[bottomView release];
	
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 80, 320, 252)];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self addSubview: tableView];
	[tableView release];

	timeLabel = [[UILabel alloc] initWithFrame: CGRectMake (20, 40, 80, 30)];
	timeLabel.backgroundColor = [UIColor clearColor];
	timeLabel.textColor = [UIColor whiteColor];
	timeLabel.font = [UIFont boldSystemFontOfSize: 12.0];

	timeSlider = [[UISlider alloc] initWithFrame: CGRectMake (20, 0, 280, 40)];
	timeSlider.backgroundColor = [UIColor clearColor];
	[timeSlider addTarget: self action: @selector(seekMusic) forControlEvents: UIControlEventValueChanged];
	volumeSlider = [[UISlider alloc] initWithFrame: CGRectMake (20, 0, 280, 30)];
	volumeSlider.value = 0.5;
    volumeSlider.maximumValue = 1;
    volumeSlider.minimumValue = 0;
	volumeSlider.backgroundColor = [UIColor clearColor];
	[volumeSlider addTarget: self action: @selector(changeVolume) forControlEvents: UIControlEventValueChanged];
	
	[topBar addSubview: timeLabel];
	[topBar addSubview: timeSlider];
	[bottomView addSubview: volumeSlider];
	
	rew = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRewind target: self action: @selector(rewind)];
	fwd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFastForward target: self action: @selector(forward)];
	play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemPlay target: self action: @selector(play)];
	pause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemPause target: self action: @selector(pause)];
	flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
	[musicControls removeAllObjects];
	[musicControls addObjectsFromArray: [NSArray arrayWithObjects: rew, flex, pause, flex, fwd, nil]];
	[bottomBar setItems: musicControls animated: NO];

	[self changeVolume];

	timer = [NSTimer scheduledTimerWithTimeInterval: 0.04 target: self selector: @selector (updateTime) userInfo: nil repeats: YES];
	
	UIButton *btn = [UIButton buttonWithType: 0];
	btn.frame = CGRectMake (220, 40, 80, 30);
	btn.titleLabel.font = [UIFont boldSystemFontOfSize: 12.0];
	btn.titleLabel.textAlignment = UITextAlignmentRight;
	[btn setTitle: [playModeTitles objectAtIndex: playMode] forState: UIControlStateNormal];
	[btn addTarget: self action: @selector(changePlayMode:) forControlEvents: UIControlEventTouchUpInside];
	[topBar addSubview: btn];

	return self;

}

- (void) setFile: (NSString *) aFile {

	[file release];
	file = [[MFFile alloc] init];
	file.path = [aFile stringByDeletingLastPathComponent];
	file.name = [aFile lastPathComponent];
	[[self controller] setTitle: file.name];
	
	NSURL *url = [NSURL fileURLWithPath: [file fullPath]];
	
	[id3tag release];
	id3tag = [[MFID3Tag alloc] initWithFileName: [file fullPath]];
	
	[tableView reloadData];

	[audioPlayer release];
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: NULL];
	audioPlayer.delegate = self;
	audioPlayer.volume = 0.5;
	audioPlayer.numberOfLoops = 0;
	[audioPlayer play];

	
}

- (void) changePlayMode: (UIButton *) sender {

	playMode += 1;
	if (playMode > 3) { playMode = 0; }
	[sender setTitle: [playModeTitles objectAtIndex: playMode] forState: UIControlStateNormal];
	
}

- (void) updateTime {

	timeSlider.value = audioPlayer.currentTime / audioPlayer.duration;
	int now = (int) audioPlayer.currentTime;
	int max = (int) audioPlayer.duration;
	int nowMin = now / 60;
	int nowSec = now % 60;
	char nowLead = (nowSec < 10 ? '0' : NULL);
	int maxMin = max / 60;
	int maxSec = max % 60;
	char maxLead = (maxSec < 10 ? '0' : NULL);
	NSString *timeFormat = [[NSString alloc] initWithFormat: @"%i:%c%i of %i:%c%i", nowMin, nowLead, nowSec, maxMin, maxLead, maxSec];
	timeLabel.text = timeFormat;
	[timeFormat release];

}

- (void) seekMusic {

	audioPlayer.currentTime = timeSlider.value * audioPlayer.duration;

}

- (void) changeVolume {

	audioPlayer.volume = volumeSlider.value / 2;

}

- (void) play {

	[audioPlayer play];
	[musicControls removeAllObjects];
	[musicControls addObjectsFromArray: [NSArray arrayWithObjects: rew, flex, pause, flex, fwd, nil]];
	[bottomBar setItems: musicControls animated: YES];

}

- (void) pause {

	[audioPlayer pause];
	[musicControls removeAllObjects];
	[musicControls addObjectsFromArray: [NSArray arrayWithObjects: rew, flex, play, flex, fwd, nil]];
	[bottomBar setItems: musicControls animated: YES];

}

- (void) stop {

	[audioPlayer stop];

}

- (void) rewind {

	audioPlayer.currentTime = 0.0;
	
}

- (void) forward {

	audioPlayer.currentTime = audioPlayer.duration;
	
}

- (NSString *) nextFile {

	NSMutableArray *files = [[NSMutableArray alloc] init];
	NSMutableArray *soundFiles = [[NSMutableArray alloc] init];
	[files addObjectsFromArray: [[[[self controller] delegate] fileManager] contentsOfDirectory: file.path]];
	for (int i = 0; i < [files count]; i++) {
		if ([[[files objectAtIndex: i] type] isEqualToString: @"sound"]) {
			[soundFiles addObject: [files objectAtIndex: i]];
		}
	}
	[files release];
	int nextFilePosition = -1;
	for (int i = 0; i < [soundFiles count]; i++) {
		if ([[[soundFiles objectAtIndex: i] name] isEqualToString: file.name]) {
			nextFilePosition = i + 1;
			break;
		}
	}
	NSString *ret;
	if (nextFilePosition >= [soundFiles count]) {
		ret = nil;
	} else {
		ret = [[soundFiles objectAtIndex: nextFilePosition] fullPath];
	}
	[soundFiles release];
	
	return ret;
	
}

- (NSString *) randomFile {

	NSMutableArray *files = [[NSMutableArray alloc] init];
	NSMutableArray *soundFiles = [[NSMutableArray alloc] init];
	[files addObjectsFromArray: [[[[self controller] delegate] fileManager] contentsOfDirectory: file.path]];
	for (int i = 0; i < [files count]; i++) {
		if ([[[files objectAtIndex: i] type] isEqualToString: @"sound"]) {
			[soundFiles addObject: [files objectAtIndex: i]];
		}
	}
	[files release];

	int nextFilePosition = (random () % [soundFiles count]);
	NSString *ret = [[soundFiles objectAtIndex: nextFilePosition] fullPath];
	[soundFiles release];
	
	return ret;
	
}

- (void) reloadMetadata {

	[id3tag release];
	id3tag = [[MFID3Tag alloc] initWithFileName: [file fullPath]];
	[tableView reloadData];
	
}

// super

- (void) dealloc {

	[file release];
	file = nil;
	[audioPlayer release];
	audioPlayer = nil;
	[timeLabel release];
	timeLabel = nil;
	[timeSlider release];
	timeSlider = nil;
	[volumeSlider release];
	volumeSlider = nil;
	[rew release];
	rew = nil;
	[fwd release];
	fwd = nil;
	[play release];
	play = nil;
	[pause release];
	pause = nil;
	[musicControls release];
	musicControls = nil;
	[flex release];
	flex = nil;
	[id3tag release];
	id3tag = nil;
	[playModeTitles release];
	playModeTitles = nil;

	[super dealloc];

}

// AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully: (BOOL) successFlag {

	if (playMode == MFAudioPlayerPlayModeOnce) {
		[self.controller close];
	} else if (playMode == MFAudioPlayerPlayModeRepeat) {
		audioPlayer.currentTime = 0.0;
		[audioPlayer play];
	} else if (playMode == MFAudioPlayerPlayModeContinuous) {
		if ([self nextFile] != nil) {
			[self setFile: [self nextFile]];
		} else {
			[self.controller close];
		}
	} else if (playMode == MFAudioPlayerPlayModeShuffle) {
		[self setFile: [self randomFile]];
	}

}

// UITableViewDelegate

- (void) tableView: (UITableView *) theTableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
}


// UITableViewDataSource

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return 8;
	
}

- (UITableViewCell *)  tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"MFAudioCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"MFAudioCell"];
	}
	
	cell.contentView.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.667];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor colorWithRed: 0.0 green: 0.4 blue: 1.0 alpha: 1.0];
	
	int row = indexPath.row;
	
	if (row == 0) {
	
		cell.textLabel.text = NSLocalizedString(@"Title", @"Title");
		cell.detailTextLabel.text = [id3tag songTitle];
		
	} else if (row == 1) {
	
		cell.textLabel.text = NSLocalizedString(@"Artist", @"Artist");
		cell.detailTextLabel.text = [id3tag artist];
		
	} else if (row == 2) {
	
		cell.textLabel.text = NSLocalizedString(@"Album", @"Album");
		cell.detailTextLabel.text = [id3tag album];
	
	} else if (row == 3) {
	
		cell.textLabel.text = NSLocalizedString(@"Year", @"Year");
		cell.detailTextLabel.text = [id3tag year];
	
	} else if (row == 4) {
	
		cell.textLabel.text = NSLocalizedString(@"Genre", @"Genre");
		cell.detailTextLabel.text = [id3tag genre];
	
	} else if (row == 5) {
	
		cell.textLabel.text = NSLocalizedString(@"Lyricist", @"Lyricist");
		cell.detailTextLabel.text = [id3tag lyricist];
	
	} else if (row == 6) {
	
		cell.textLabel.text = NSLocalizedString(@"Language", @"Language");
		cell.detailTextLabel.text = [id3tag language];
	
	} else if (row == 7) {
	
		cell.textLabel.text = NSLocalizedString(@"Comments", @"Comments");
		cell.detailTextLabel.text = [id3tag comments];
		
	} else if (row == 8) {

	}
	
	return cell;
	
}

@end

