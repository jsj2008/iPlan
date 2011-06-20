//
//  IPlanUtility.h
//  iPlan
//
//  Created by Xu Yecheng on 6/20/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IPlanUtility : NSObject {

}

+ (NSNumber*) weekOfDayStringToNSNumber:(NSString*)day;
+ (NSNumber*) frequencyStringToNSNumber:(NSString*)fre;

@end