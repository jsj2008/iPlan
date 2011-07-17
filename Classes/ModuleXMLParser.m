//
//  ModuleXMLParser.m
//  iPlan
//
//  Created by Xu Yecheng on 6/18/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "ModuleXMLParser.h"
#import "IPlanUtility.h"

@implementation ModuleXMLParser

@synthesize currentProperty;
//@synthesize currentFaculty;
@synthesize currentModule;
@synthesize currentTimeTableSlot;
@synthesize modulesParser;
@synthesize lastUpdated;
@synthesize semester;
@synthesize weekMidtermBreakAfter;
@synthesize weekOneDay;
@synthesize weekOneMonth;
@synthesize year;
// @synthesize faculties;
- (id) initWithDataAndParse:(NSData*)data
{
    [super init];
    if(super !=nil)
    {
        if (modulesParser)
        {
            [modulesParser release];
        }
        modulesParser = [[NSXMLParser alloc] initWithData:data];
        [modulesParser setDelegate:self];
        [modulesParser setShouldResolveExternalEntities:YES];
        [modulesParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
        [modulesParser setShouldReportNamespacePrefixes:NO]; //
        [modulesParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
        //NSLog(@"begin parsing");
        self.currentModule = [[XMLModule alloc] init];
        [modulesParser parse];
        //NSLog(@"end parsing");
    }
    return self;
}
- (id) initWithURLStringAndParse:(NSString *)URLString
{
    [super init];
    if(super !=nil)
    {
        NSURL *XMLURL = [[NSURL alloc] initWithString:URLString];
        // If the parser instance already exists, release it.
        if (modulesParser)
        {
            [modulesParser release];
        }
        modulesParser = [[NSXMLParser alloc] initWithContentsOfURL:XMLURL];
        [modulesParser setDelegate:self];
        [modulesParser setShouldResolveExternalEntities:YES];
        [modulesParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
        [modulesParser setShouldReportNamespacePrefixes:NO]; //
        [modulesParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
        //NSLog(@"begin parsing");
		self.currentModule = [[XMLModule alloc] init];
        [modulesParser parse];
        //NSLog(@"end parsing");
    }
    return self;
}


- (id) delegate
{
	//NSLog(@"delegate");
    return _delegate;
}
- (void) setDelegate:(id)new_delegate
{
	//NSLog(@"setDelegate");
    _delegate = new_delegate;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //NSLog(@"foundCharacters.");
    if (self.currentProperty)
    {
        // Remove the annoying <CR> suffix, -_- 
        NSString *CR = [NSString stringWithFormat:@"%c", 10];
        if ([[string substringFromIndex:[string length] - 1] isEqualToString:CR])
        {
            string = [string substringToIndex:[string length] - 1];
        }
        [currentProperty appendString:string];
        //NSLog(@"!%@!", currentProperty);
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //NSLog(@"didstartelement");
    if ([elementName isEqualToString:@"modulesinfo"])
    {
        self.lastUpdated = [attributeDict objectForKey:@"lastUpdated"];
        self.semester = [attributeDict objectForKey:@"semester"];
        self.weekMidtermBreakAfter = [attributeDict objectForKey:@"weekMidtermBreakAfter"];
        self.weekOneDay = [attributeDict objectForKey:@"weekOneDay"];
        self.weekOneMonth = [attributeDict objectForKey:@"weekOneMonth"];
        self.year = [attributeDict objectForKey:@"year"];
    }
    else if (qName)
    {
        elementName = qName;
    }

    else if (self.currentTimeTableSlot)
    {
        if ([elementName isEqualToString:@"type"] || [elementName isEqualToString:@"slot"] || [elementName isEqualToString:@"day"]
            || [elementName isEqualToString:@"time_start"] || [elementName isEqualToString:@"time_end"] || [elementName isEqualToString:@"venue"]
            || [elementName isEqualToString:@"frequency"])
        {
            self.currentProperty = [NSMutableString string];
        }
    }
    else if (self.currentModule)
    {
        if ([elementName isEqualToString:@"code"] || [elementName isEqualToString:@"title"] || [elementName isEqualToString:@"description"]
            || [elementName isEqualToString:@"examinable"] || [elementName isEqualToString:@"open_book"] || [elementName isEqualToString:@"exam_date"]
            || [elementName isEqualToString:@"mc"] || [elementName isEqualToString:@"prereq"] || [elementName isEqualToString:@"preclude"]
            || [elementName isEqualToString:@"workload"] || [elementName isEqualToString:@"remarks"] || [elementName isEqualToString:@"last_updated"])
        {
            self.currentProperty = [NSMutableString string];
        }
        else if ([elementName isEqualToString:@"timetable_slot"])
        {
            self.currentTimeTableSlot = [[XMLTimeTableSlot alloc] init]; // Create the element
        }
    }


    // else if (self.currentFaculty)
    // {
    //     if ([elementName isEqualToString:@"module"])
    //     {
    //         self.currentTimeTableSlot = [[XMLModule alloc] init]; // Create the element
    //     }
    // }
    else { // We are outside of everything, so we need a
        // Check for deeper nested node
        if ([elementName isEqualToString:@"module"])
        {
            //self.currentModule = [[XMLModule alloc] init];
        }
    }   
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (qName)
    {
        elementName = qName;
    }

    if (self.currentTimeTableSlot)
    {
        if ([elementName isEqualToString:@"type"])
        {
            self.currentTimeTableSlot.type = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"slot"])
        {
            self.currentTimeTableSlot.slot = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"day"])
        {
            self.currentTimeTableSlot.day = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"time_start"])
        {
            self.currentTimeTableSlot.time_start = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"time_end"])
        {
            self.currentTimeTableSlot.time_end = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"venue"])
        {
            self.currentTimeTableSlot.venue = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"frequency"])
        {
            self.currentTimeTableSlot.frequency = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"timetable_slot"])
        {
            [currentModule addTimeTableSlot:self.currentTimeTableSlot];
            self.currentTimeTableSlot = nil;
        }    
    }
    else if (self.currentModule)
    {
        if ([elementName isEqualToString:@"code"])
        {
			//NSLog(@"Success in Code");
            self.currentModule.code = self.currentProperty;
			//NSLog(@"Out of code");
        }
        else if ([elementName isEqualToString:@"title"])
        {
            self.currentModule.title = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"description"])
        {
            self.currentModule.description = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"examinable"])
        {
            self.currentModule.examinable = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"open_book"])
        {
            self.currentModule.open_book = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"exam_date"])
        {
            self.currentModule.exam_date = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"mc"])
        {
            self.currentModule.mc = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"prereq"])
        {
            self.currentModule.prereq = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"preclude"])
        {
            self.currentModule.preclude = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"workload"])
        {
            self.currentModule.workload = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"remarks"])
        {
            self.currentModule.remarks = self.currentProperty;
        }
        else if ([elementName isEqualToString:@"last_updated"])
        {
            self.currentModule.last_updated = self.currentProperty;
        }
        // The end :)
        else if ([elementName isEqualToString:@"module"])
        {
        //    [self.currentModule debugCurrentModule];

            NSMutableDictionary *classGroupTypes = [[NSMutableDictionary alloc] initWithCapacity:4];
            NSMutableDictionary *classGroupsUnderConstruction;
            // Will not be released 
            NSMutableArray *moduleClassTypesUnderConstruction = [[NSMutableArray alloc] init];
            
            for (XMLTimeTableSlot *TTSlot in self.currentModule.timeTableSlots)
            {
                Slot *slotUnderConstruction;

                // Convert day of week from string to NSNumber
                NSNumber *dayNum = [IPlanUtility weekOfDayStringToNSNumber:TTSlot.day];
                //NSLog(@"%d", [dayNum integerValue]);
                [dayNum retain];

                NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                NSNumber *timeStart = [[f numberFromString:TTSlot.time_start] retain];
                NSNumber *timeEnd = [[f numberFromString:TTSlot.time_end] retain];
                [f release];
                
                int weeks = [self.semester integerValue] > 2 ? NUMBER_OF_WEEKS_FOR_SPECIAL_TERM : NUMBER_OF_WEEKS_FOR_NORMAL_SEMESTER;
                NSArray *frequency = [[IPlanUtility frequencyStringToNSArray:TTSlot.frequency Weeks:weeks] retain];
                slotUnderConstruction = [[Slot alloc] initWithVenue:TTSlot.venue
                                                            WithDay:dayNum
                                                      WithStartTime:timeStart
                                                        WithEndTime:timeEnd
                                                      WithGroupName:TTSlot.slot
                                                      WithFrequency:frequency];
                // If current ClassGroup type (LECTURE, for example) does not exist, create it first
                if (![classGroupTypes valueForKey:TTSlot.type])
                {
                    NSMutableArray *slots = [[NSMutableArray alloc] init];
                    [classGroupTypes setValue:slots forKey:TTSlot.type];
                }
                [[classGroupTypes valueForKey:TTSlot.type] addObject:slotUnderConstruction];
                [slotUnderConstruction release];
            }

            // Construt ClassGroups
            classGroupsUnderConstruction = [[NSMutableDictionary alloc] initWithCapacity:4];
            for (NSString *key in classGroupTypes)
            {
                // Initialize array of class groups for one category (LECTURE, for example)
                NSMutableArray *classGroupPerCategory = [[NSMutableArray alloc] init];
                [classGroupsUnderConstruction setValue:classGroupPerCategory forKey:key];
                [classGroupPerCategory release];

                NSArray *slots = [classGroupTypes valueForKey:key];
                NSMutableDictionary *groups = [[NSMutableDictionary alloc] init];

                for (Slot *slot in slots)
                {
                    if (![groups valueForKey:slot.groupName])
                    {
                        NSMutableArray *subGroup = [[NSMutableArray alloc] init];
                        [groups setValue:subGroup forKey:slot.groupName];
                        [subGroup release];
                    }
                    [[groups valueForKey:slot.groupName] addObject:slot];
                }

                for(NSString *key2 in groups)
                {
                    NSArray *subGroup = [groups valueForKey:key2];
                    // Any slot will do
                    Slot *anySlot = [subGroup objectAtIndex:0];
                    ClassGroup *classGroup = [[ClassGroup alloc] initWithName:key2
                                                                     WithSlots:subGroup
                                                                 WithFrequency:anySlot.frequency
                                                                  WithSelected:@"NO"];
                    [classGroupPerCategory addObject:classGroup];
                    [classGroup release];
                }
            }

            // Construct ModuleClassType
            for (NSString *key3 in classGroupsUnderConstruction)
            {
                NSArray *classGroupPerCategory = [classGroupsUnderConstruction valueForKey:key3];
                ModuleClassType *moduleClassTypeUnderConstruction;
                moduleClassTypeUnderConstruction = [[ModuleClassType alloc] initWithName:key3 WithGroups:classGroupPerCategory];
                [moduleClassTypesUnderConstruction addObject:moduleClassTypeUnderConstruction];
            //    NSLog(@"%d", [moduleClassTypeUnderConstruction retainCount]);
            }

            // Finally (-_-;) Construct Module
            
            Module *moduleUnderConstruction = [[Module alloc] initWithDescription:self.currentModule.description
                                                                         WithCode:self.currentModule.code
                                                                        WithTitle:self.currentModule.title
                                                                   WithExaminable:self.currentModule.examinable
                                                                     WithOpenBook:self.currentModule.open_book
                                                                     WithExamDate:self.currentModule.exam_date
                                                                       WithCredit:self.currentModule.mc
                                                                 WithPrerequisite:self.currentModule.prereq
                                                                   WithPreclusion:self.currentModule.preclude
                                                                     WithWorkload:self.currentModule.workload
                                                                       WithRemark:self.currentModule.remarks
                                                                   WithLastUpdate:self.currentModule.last_updated
                                                                     WithSelected:@"NO"
                                                              WithModuleClassType:moduleClassTypesUnderConstruction];

            // Encoding

            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentDirectory = [paths objectAtIndex:0];
            NSString *modulesDirectory= [[documentDirectory stringByAppendingString:@"/"] stringByAppendingString:MODULE_DOCUMENT_NAME];
            // Tell if plists directory exists, if not, create it
            NSFileManager * fm = [NSFileManager defaultManager];
            if (![fm fileExistsAtPath:modulesDirectory])
            {
                [fm createDirectoryAtPath:modulesDirectory withIntermediateDirectories:NO attributes:nil error:NULL];
            }
			NSString* filename = [moduleUnderConstruction.code stringByReplacingOccurrencesOfString:@"/" withString:@"|"];
            filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@" "];
			filename = [filename stringByAppendingString:@".plist"];
			NSString* fullPath = [NSString stringWithFormat:@"%@/%@", modulesDirectory, filename];
			//NSLog(@"code%@",[moduleUnderConstruction.code stringByAppendingString:@".plist"]);
			//NSLog(@"doc%@", modulesDirectory);
			//NSLog(@"%@",fullPath);
            NSMutableData* data = [[NSMutableData alloc] init];
            NSKeyedArchiver* arc = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
            [arc encodeObject:moduleUnderConstruction forKey:@"module"];
	
            [arc finishEncoding];
            BOOL success = [data writeToFile:fullPath atomically:YES];
            [arc release];
            [data release];
            if(!success)
			{ 
				//NSLog(@"Unsuccessful!");
			}
			else 
			{
				//NSLog(@"Success!");
			}
            // End of encoding
			
            [moduleUnderConstruction release];
            [self.currentModule release];
            self.currentModule = [[XMLModule alloc] init];
            [classGroupTypes release];
            //NSLog(@"Alive......");
        }
    }
    // Consider removing Faculties
    // else if (self.currentFaculty)
    // {
    //     if ([elementName isEqualToString:@"faculty"])
    //     {
    //         [faculties addObject:self.currentFaculty];
    //         self.currentFaculty = nil;
    //     }
    // }
}

// Destructor
- (void) dealloc
{
    [modulesParser release];
    [super dealloc];
}

@end
