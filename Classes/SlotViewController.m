    //
//  SlotViewController.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-2.
//  Copyright 2011 NUS. All rights reserved.
//

#import "SlotViewController.h"
#import "ControllerConstant.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"
#import <QuartzCore/QuartzCore.h>
#import "ControllerConstant.h"

@implementation SlotViewController

@synthesize moduleCode;
@synthesize venue;
@synthesize startTime;
@synthesize endTime;
@synthesize classGroupName;
@synthesize	moduleColor;
@synthesize dayNumber;
@synthesize displayProperty;
@synthesize classTypeName;
@synthesize available;
@synthesize frequency;

- (SharedAppDataObject*) theAppDataObject
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

-(CGRect)calculateDisplayProperty
{
	float x,y,w,h;
	int dayNumberNumber = [dayNumber intValue];
	float startTimeNumber = [startTime intValue];
	int endTimeNumber = [endTime intValue];
	if(dayNumberNumber==1)
	{
		x = SLOT_FIRST_CELL_WIDTH;
		w = SLOT_MON_CELL_WIDTH;
	}
	else if(dayNumberNumber==2)
	{
		w = SLOT_TUE_CELL_WIDTH;
		x = SLOT_TUE_CELL_X;
	}
	else if(dayNumberNumber==3)
	{
		w = SLOT_WED_CELL_WIDTH;
		x = SLOT_WED_CELL_X;
	}
	else if(dayNumberNumber == 4)
	{
		w = SLOT_THU_CELL_WIDTH;
		x = SLOT_THU_CELL_X;
	}
	else if(dayNumberNumber == 5)
	{
		w = SLOT_FRI_CELL_WIDTH;
		x = SLOT_FRI_CELL_X;
	}
	y = SLOT_FIRST_CELL_HEIGHT+(startTimeNumber/100-8)*SLOT_NORMAL_CELL_HEIGHT;
	if(endTimeNumber%100==30)
		endTimeNumber = endTimeNumber+20;
	h = SLOT_NORMAL_CELL_HEIGHT*(endTimeNumber-startTimeNumber)/100;
	if(dayNumberNumber ==5)
	{
		w = w-6;
		x = x-2;
	}
	return CGRectMake(x,y,w,h);
}

- initWithModuleCode:(NSString *)code 
		   WithVenue:(NSString*)place
	   WithStartTime:(NSNumber*)start
		 WithEndTime:(NSNumber*)end
			 WithDay:(NSNumber*)date
  WithClassGroupName:(NSString*)name
	 WithModuleColor:(UIColor*)color
   WithClassTypeName:(NSString*)classtype
	   WithFrequency:(NSNumber*)freq

					
{
    self = [super init];
    if (self) 
	{
		self.moduleCode = code;
		self.venue = place;
		self.startTime = start;
		self.endTime = end;
		self.classGroupName = name;
		self.moduleColor = color;    
		self.dayNumber = date;
		self.classTypeName = classtype;
		self.view.multipleTouchEnabled = YES;
		self.view.userInteractionEnabled = YES;
		self.available = NO;
		self.frequency = freq;
		printf("slot view controller %d\n",[frequency intValue]);
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		[self.view addGestureRecognizer:tap];
		[tap release];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];	
	self.view.layer.cornerRadius = 7.5;
	self.view.alpha = 0.7;
}

- (void)setBackGroundColorWithCondition:(NSString*)condition
{
	if([condition isEqualToString:CLASH])
	{
		self.view.backgroundColor = [UIColor darkGrayColor];
		self.view.layer.borderColor = [UIColor redColor].CGColor;
		self.view.layer.borderWidth = 3.0f;
	}
	else if([condition isEqualToString:NORMAL])
	{
		self.view.backgroundColor = [self moduleColor];
		self.view.layer.borderColor = [UIColor clearColor].CGColor;
		self.view.layer.borderWidth = 0.0f;
	}
	else if([condition isEqualToString:AVAILABLE])
	{
		self.view.backgroundColor = [UIColor darkGrayColor];
		self.view.layer.borderColor = [UIColor clearColor].CGColor;
		self.view.layer.borderWidth = 0.0f;
	}
}

- (void)setLabelContentWithCondition:(NSString*)condition
{
	CGRect frame = [self calculateDisplayProperty];
	if([condition isEqualToString:CLASH])
	{
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,frame.size.width	,frame.size.height )];
		label.text = @"CLASH";
		label.backgroundColor = [UIColor clearColor];
		label.layer.cornerRadius = 3.5;
		[self.view addSubview:label];
	}
	else if([condition isEqualToString:NORMAL])
	{
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,frame.size.width	,frame.size.height )];
		label.text = classGroupName;
		label.backgroundColor = [UIColor clearColor];
		label.layer.cornerRadius = 3.5;
		[self.view addSubview:label];
	}
	else 
	{
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,frame.size.width	,frame.size.height )];
		label.text = @"Several modules";
		label.backgroundColor = [UIColor clearColor];
		label.layer.cornerRadius = 3.5;
		[self.view addSubview:label];
	}
		
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer 
{
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	NSMutableArray* slotViewControllers = theDataObject.slotViewControllers;
	SlotViewController* slot = [theDataObject selectSlot];
	
	//clear all the availableSlots display
	for (SlotViewController* slot in theDataObject.availableSlots)
	{
		[slot.view removeFromSuperview];
	}
	
	//recover selection
	if ([slot.moduleCode isEqual:moduleCode]&&[slot.classTypeName isEqual:classTypeName]&&[slot.classGroupName isEqual:classGroupName]) 
	{
		
		for(SlotViewController* slot in slotViewControllers)
		{
			slot.view.layer.borderColor = [UIColor clearColor].CGColor;
			slot.view.layer.borderWidth = 0.0f;
		}
		theDataObject.selectSlot = nil;
		[theDataObject.tableChoices removeAllObjects];
		[theDataObject.availableSlots removeAllObjects];
		
	}
	
	//selection start
	else
	{
		
		
		[theDataObject.tableChoices removeAllObjects];
		
		//check for clashes
		for (int i=0;i<[slotViewControllers count];i++) 
		{
			SlotViewController* slot = [slotViewControllers objectAtIndex:i];
			if ([slot.dayNumber intValue]==[self.dayNumber intValue]&&slot!=self) 
			{
				if([slot.startTime intValue]>=[self.endTime intValue]||[slot.endTime intValue]<=[self.startTime intValue]);
				else 
				{
					NSString* displayInfo = [NSString stringWithString:[slot moduleCode]];
					displayInfo = [displayInfo stringByAppendingString:@" "];
					
					if([[slot dayNumber]intValue]==1)
						displayInfo = [displayInfo stringByAppendingString:@"MON"];
					else if([[slot dayNumber]intValue]==2)
						displayInfo = [displayInfo stringByAppendingString:@"TUE"];
					else if([[slot dayNumber]intValue]==3)
						displayInfo = [displayInfo stringByAppendingString:@"WED"];
					else if([[slot dayNumber]intValue]==4)
						displayInfo = [displayInfo stringByAppendingString:@"THU"];
					else if([[slot dayNumber]intValue]==5)
						displayInfo = [displayInfo stringByAppendingString:@"FRI"];
					
					displayInfo = [displayInfo stringByAppendingString:@" "];
					displayInfo = [displayInfo stringByAppendingString:[[slot startTime]stringValue]];
					displayInfo = [displayInfo stringByAppendingString:@"-"];
					displayInfo = [displayInfo stringByAppendingString:[[slot endTime]stringValue]];
					
					displayInfo = [displayInfo stringByAppendingString:@"%%%"];
					printf("after aaa");
					NSLog(@"%@",displayInfo);
					displayInfo = [displayInfo stringByAppendingString:slot.classTypeName];
					displayInfo = [displayInfo stringByAppendingString:@" "];
					displayInfo = [displayInfo stringByAppendingString:slot.venue];
					NSLog(@"%@",displayInfo);
					[theDataObject.tableChoices addObject:displayInfo];
				}

			}
		}
		
		[theDataObject.availableSlots removeAllObjects];

		//if there is clash
		if([theDataObject.tableChoices count]>0)
		{
			NSString* displayInfo = [NSString stringWithString:[self moduleCode]];
			displayInfo = [displayInfo stringByAppendingString:@" "];
			
			if([[self dayNumber]intValue]==1)
				displayInfo = [displayInfo stringByAppendingString:@"MON"];
			else if([[self dayNumber]intValue]==2)
				displayInfo = [displayInfo stringByAppendingString:@"TUE"];
			else if([[self dayNumber]intValue]==3)
				displayInfo = [displayInfo stringByAppendingString:@"WED"];
			else if([[self dayNumber]intValue]==4)
				displayInfo = [displayInfo stringByAppendingString:@"THU"];
			else if([[self dayNumber]intValue]==5)
				displayInfo = [displayInfo stringByAppendingString:@"FRI"];
			
			displayInfo = [displayInfo stringByAppendingString:@" "];
			displayInfo = [displayInfo stringByAppendingString:[[self startTime]stringValue]];
			displayInfo = [displayInfo stringByAppendingString:@"-"];
			displayInfo = [displayInfo stringByAppendingString:[[self endTime]stringValue]];
			
			displayInfo = [displayInfo stringByAppendingString:@"%%%"];
			printf("after aaa");
			NSLog(@"%@",displayInfo);
			displayInfo = [displayInfo stringByAppendingString:self.classTypeName];
			displayInfo = [displayInfo stringByAppendingString:@" "];
			displayInfo = [displayInfo stringByAppendingString:self.venue];
			NSLog(@"%@",displayInfo);
			[theDataObject.tableChoices addObject:displayInfo];
			[theDataObject.tableChoices addObject:CLASH];
		}
		
		//no clash
		else 
		{
			//call Model Logic

			
			NSMutableArray* availableAnswer = [[ModelLogic modelLogic] getOtherAvailableGroupsWithModuleCode:[self moduleCode]
																						  WithClassTypeIndex:[self classTypeName]
																							   WithGroupName:[self classGroupName]];
		
			for (NSDictionary* dict in availableAnswer) 
			{
				NSString* code = [dict objectForKey:@"moduleCode"];
				UIColor* color = [dict objectForKey:@"color"];
				NSString* typeName = [dict objectForKey:@"classTypeName"];
				NSString* groupName = [dict objectForKey:@"classGroupName"];
				NSMutableArray* slots = [dict objectForKey:@"slots"];
				printf("available slots %d\n",[slots count]);
				
				for(NSDictionary* dictInner in slots)
				{
					
					SlotViewController* slot = [[SlotViewController alloc]initWithModuleCode:code 
																				   WithVenue:[dictInner objectForKey:@"venue"]
																			   WithStartTime:[dictInner objectForKey:@"startTime"]
																				 WithEndTime:[dictInner objectForKey:@"endTime"]
																					 WithDay:[dictInner objectForKey:@"day"]
																		  WithClassGroupName:groupName 
																			 WithModuleColor:color
																		   WithClassTypeName:typeName
																			   WithFrequency:[dictInner objectForKey:@"frequency"]];
					slot.available = YES;
					printf("slot view get other available slot %d\n",[[slot frequency]intValue]);

					[theDataObject.availableSlots addObject:slot ];
				}
				
			}
			
			
			
			for(int i=0;i<[theDataObject.availableSlots count];i++)
			{
				
				SlotViewController* slot = [theDataObject.availableSlots objectAtIndex:i];
				NSString* displayInfo = [NSString stringWithString:[slot moduleCode]];
				displayInfo = [displayInfo stringByAppendingString:@" "];
				
				if([[slot dayNumber]intValue]==1)
					displayInfo = [displayInfo stringByAppendingString:@"MON"];
				else if([[slot dayNumber]intValue]==2)
					displayInfo = [displayInfo stringByAppendingString:@"TUE"];
				else if([[slot dayNumber]intValue]==3)
					displayInfo = [displayInfo stringByAppendingString:@"WED"];
				else if([[slot dayNumber]intValue]==4)
					displayInfo = [displayInfo stringByAppendingString:@"THU"];
				else if([[slot dayNumber]intValue]==5)
					displayInfo = [displayInfo stringByAppendingString:@"FRI"];
				
				displayInfo = [displayInfo stringByAppendingString:@" "];
				displayInfo = [displayInfo stringByAppendingString:[[slot startTime]stringValue]];
				displayInfo = [displayInfo stringByAppendingString:@"-"];
				displayInfo = [displayInfo stringByAppendingString:[[slot endTime]stringValue]];
				
				displayInfo = [displayInfo stringByAppendingString:@"%%%"];
				printf("after aaa");
				NSLog(@"%@",displayInfo);
				displayInfo = [displayInfo stringByAppendingString:slot.classTypeName];
				displayInfo = [displayInfo stringByAppendingString:@" "];
				displayInfo = [displayInfo stringByAppendingString:slot.venue];
				NSLog(@"%@",displayInfo);
				[theDataObject.tableChoices addObject:displayInfo];
			}
			
			if([theDataObject.tableChoices count]!=0)
				[theDataObject.tableChoices addObject:SLOTS];
			
		}

		theDataObject.selectSlot = self;
		
		//handle display
		for (int i=0;i<[theDataObject.slotViewControllers count];i++ ) 
		{
			SlotViewController* slot1 = [theDataObject.slotViewControllers objectAtIndex:i];
			BOOL clash = NO;
			BOOL manyModule = NO;
			[slot1.view removeFromSuperview];
			[theDataObject.image addSubview:slot1.view];
			slot1.view.multipleTouchEnabled = YES;
			slot1.view.userInteractionEnabled = YES;
			[slot1.view setFrame:[slot1 calculateDisplayProperty]];
			
			for(int j=0;j<[theDataObject.slotViewControllers count];j++)
			{
				SlotViewController* slot2 = [theDataObject.slotViewControllers objectAtIndex:j];
				if([slot1.dayNumber intValue]==[slot2.dayNumber intValue]&&slot1!=slot2)
				{
					
					if([slot1.startTime intValue]>=[slot2.endTime intValue]||[slot1.endTime intValue]<=[slot2.startTime intValue]);
					else 
					{
						
						if (([[slot1 frequency]intValue]&[[slot2 frequency]intValue])==0)
						{
							manyModule = YES;
						}
						else
						{
							clash = YES;
						}
					}
				}
			}
			
			if(clash)
			{
				[slot1 setBackGroundColorWithCondition:CLASH];
				//	[slot1 setLabelContentWithCondition:CLASH];
				[theDataObject.image bringSubviewToFront:slot1.view];
			}
			else if(manyModule)
			{
				[slot1 setBackGroundColorWithCondition:AVAILABLE];
				//	[slot1 setLabelContentWithCondition:AVAILABLE];
				[theDataObject.image bringSubviewToFront:slot1.view];
			}
			else 
			{
				[slot1 setBackGroundColorWithCondition:NORMAL];
				[slot1 setLabelContentWithCondition:NORMAL];
				[theDataObject.image bringSubviewToFront:slot1.view];
				
			}
			
		}
		for(SlotViewController* slot in slotViewControllers)
		{
			if([slot.moduleCode isEqual:moduleCode]&&[slot.classTypeName isEqual:classTypeName]&&[slot.classGroupName isEqual:classGroupName])
			{
				slot.view.layer.borderColor = [UIColor blackColor].CGColor;
				slot.view.layer.borderWidth = 3.0f;
				
			}
			//part of recover selection
			/*
			else 
			{
				slot.view.layer.borderColor = [UIColor clearColor].CGColor;
				slot.view.layer.borderWidth = 0.0f;
			}
			*/
		}
		
		
	}
	
	[theDataObject.table reloadData];
}
 

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];

    // Release any retained subviews of the main view.
}


- (void)dealloc 
{
	[moduleCode release];
	[venue release];
	[classGroupName release];
	[startTime release];
	[endTime release];
	[moduleColor release];
	[dayNumber release];
	[classTypeName release];
	[super dealloc];
}


@end
