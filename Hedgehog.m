//
//  Hedgehog.m
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Hedgehog.h"
#import "Apple.h"
#import "Cell.h"


@implementation Hedgehog

-(id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context HomeLocationX: (NSInteger) homeLocationX HomeLocationY: (NSInteger) homeLocationY{
    self = [super initWithEntity: entity insertIntoManagedObjectContext:context];
    if(self){
        //        [self setAge:1];
        //        NSNumber *sex;
        //        sex = 1;
        //        [self setGender:sex];
        //        [self setSpeed:sex];
        potentialApples = [[NSMutableArray alloc] initWithCapacity:0];
        [self setHomeLocationX:homeLocationX];
        [self setHomeLocationY:homeLocationY];
        [self setCurLocationX:homeLocationX];
        [self setCurLocationY:homeLocationY];
        mooving = NO;
        
        
    }
    return self;
}

- (void) subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToNewApple:) name:@"NewAppleNotification" object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToAppleTaken:) name:@"AppleTaken" object:nil];    
}

- (void) respondToNewApple: (NSNotification*) notification {
    id apple = [notification object];
    [potentialApples addObject:apple];
    if (!mooving) {
        NSLog(@"start mooving");
        [self startMooving];
    }
}

- (void) respondToAppleTaken: (NSNotification*) notification {
    id apple = [notification object];
    @synchronized(apple) {
        [potentialApples removeObject:apple];
    }
}

- (void) startMooving {
    mooving = YES;
    
    id apple = [potentialApples objectAtIndex:0];
    
    int amountOfXSteps = [self amountOfStepsToAppleX:[apple xCoord]];
    int amountOfYSteps = [self amountOfStepsToAppleY:[apple yCoord]];
    
    BOOL xSign = amountOfXSteps > 0;
    BOOL ySign = amountOfYSteps > 0;  
    double delayInSeconds = .5;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            for (int i = 0; i < fabs(amountOfXSteps); i++) {
                self.curLocationX += xSign ? -1 : +1;
                [NSThread sleepForTimeInterval:delayInSeconds];
            }
            for (int i = 0; i < fabs(amountOfYSteps); i++) {
                self.curLocationY += ySign ? -1 : +1;
                [NSThread sleepForTimeInterval:delayInSeconds];
            }
        
        @synchronized (apple) {
            if ([potentialApples containsObject:apple]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AppleTaken" object:apple];
                Cell* cell = [apple cell];
                [cell setApple:NULL];
                id appDelegate = [[UIApplication sharedApplication]
                                  delegate];
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                [self addApplesObject:apple];
                
                [context save:nil];
            }
        }
        mooving = NO;
        if ([potentialApples count] != 0 /*and no apple*/) {
            [self startMooving];
        }
    });
}

- (int) amountOfStepsToAppleX:(int)appleX {
    return self.curLocationX - appleX;
}

- (int) amountOfStepsToAppleY:(int)appleY{
    return self.curLocationY - appleY;
}

//- (void)dealloc {
//    [potentialApples release];
//
//    [super dealloc];
//}

@synthesize homeLocationX;
@synthesize homeLocationY;
@synthesize curLocationX;
@synthesize curLocationY;
@synthesize potentialApples;
@synthesize mooving;
@synthesize hedgehogID;

@dynamic age;
@dynamic speed;
@dynamic gender;
@dynamic apples;

@end
