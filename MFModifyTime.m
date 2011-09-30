//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//

#import "MFModifyTime.h"


@implementation MFModifyTime

@synthesize date;
@synthesize dateshow = dateshow;
@synthesize changed;


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"HH:mm"];
    // Initialization code
	picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 325, 250)];
	picker.datePickerMode = UIDatePickerModeTime;
	picker.hidden = NO;
	picker.date = date;
	[picker addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:picker];
	[picker release];
}

- (void)changeDateInLabel:(id)sender{
	//Use NSDateFormatter to write out the date in a friendly format
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
	[df2 setDateFormat:@"HH:mm:ss"];
    dateshow = [df2 stringFromDate:picker.date]; 
    [dateshow writeToFile:@"/private/var/mobile/Library/iFinder/qnu" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    [dateshow release];
    [df2 release];
    
    changed = @"YES";
}

- (id) init {
    self.title = @"New Time";
    return self;
}


@end
