    //
//  DisplayViewController.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-7.
//  Copyright 2011 NUS. All rights reserved.
//

#import "DisplayViewController.h"
#import "ControllerConstant.h"

@implementation DisplayViewController
@synthesize slotViewControllers;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (id)init {
    self = [super init];
    if (self) 
	{
        slotViewControllers = [[NSMutableArray alloc]init];
		
		UIImageView* imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"timetable with days.png"]];
		imageView.frame =  CGRectMake(TIMETABLE_X,TIMETABLE_Y,TIMETABLE_W,TIMETABLE_H);
		self.view = imageView;
		[imageView release];
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
