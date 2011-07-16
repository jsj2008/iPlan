//
//  SharedAppDataObject.m
//  iPlan
//
//  Created by HQ on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedAppDataObject.h"

@implementation SharedAppDataObject

#pragma mark -
#pragma mark synthesize

@synthesize settingsIdentity;
@synthesize moduleCode;
@synthesize requestedToken;
@synthesize basket;
@synthesize activeModules;
@synthesize requirements;
@synthesize zoomed;
@synthesize moduleCells;
@synthesize removedCells;
@synthesize selectSlot;
@synthesize slotViewControllers;
@synthesize needUpdate;
@synthesize continueToCalendar;
@synthesize tableChoices;
@synthesize availableSlots;
@synthesize table;
@synthesize image;
@synthesize requirementEnabled;

#pragma mark -
#pragma mark -Memory management

-(id) init {
	if ([super init]){
		basket = [[NSMutableArray alloc] init];
		activeModules = [[NSMutableArray alloc] init];
		requirements = [[NSMutableArray alloc] init];
		moduleCells = [[NSMutableDictionary alloc] init];
		removedCells = [[NSMutableDictionary alloc] init];
		slotViewControllers =[[NSMutableArray alloc]init];
		tableChoices = [[NSMutableArray alloc]init];
		availableSlots = [[NSMutableArray alloc]init];
		zoomed = NO;
		selectSlot = nil;
		needUpdate = NO;
		continueToCalendar = NO;
		requirementEnabled = NO;
	}
	return self;
}

- (void)dealloc
{

	[settingsIdentity release];
	[moduleCode release];
	[requestedToken release];
	[basket release];
	[activeModules release];
	[requirements release];
	[moduleCells release];
	[removedCells release];
	[slotViewControllers release];
	[requirements release];
	[selectSlot release];
	[super dealloc];
}

@end
