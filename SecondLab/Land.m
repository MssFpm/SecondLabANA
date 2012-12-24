//
//  Land.m
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Land.h"

@implementation Land
const int TOTAL_DAYS = 360;
const int AUTUMN_START = 180;
const int AUTUMN_END = 270;



- (id)initWithDayOfYear:(int)day andView:(id)view{
    self = [super init];
    if (self) {
        [self setDayOfYear:day];
        self.simulationView = view;
    }
    return self; 
}

- (void) tick:(NSTimer *) timer {
    dayOfYear++;
    dayOfYear %= TOTAL_DAYS;
    
    if (dayOfYear > AUTUMN_START && dayOfYear < AUTUMN_END) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TickNotification" object:self];
      [simulationView setNeedsDisplay];
    }

}

//- (void)dealloc {
//    [simulationView release];
//    [super dealloc];
//}

@synthesize dayOfYear;
@synthesize simulationView;

@end
