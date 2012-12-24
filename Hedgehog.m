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
    [potentialApples removeObject:apple];
    [self goHome];
}

- (void) startMooving {
    mooving = YES;
    // dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    if ([potentialApples count] == 0) {
        return;
    }
    id apple = [potentialApples objectAtIndex:0];
       
    int amountOfXSteps = [self amountOfStepsToX:[apple xCoord]];
    int amountOfYSteps = [self amountOfStepsToY:[apple yCoord]];
    
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
                id appDelegate = [[UIApplication sharedApplication]
                                  delegate];
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                [self addApplesObject:apple];
                [context save:nil];
                tookApple = YES;
                NSLog(@"%d", [self hedgehogID]);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AppleTaken" object:apple];
                
                Cell* cell = [apple cell];
                [cell setApple:NULL];
                
                
            }
        }
        mooving = NO;
        if ([potentialApples count] != 0 && !tookApple) {
            [self startMooving];
        }
    });
}

- (void) goHome {
    mooving = YES;
    // dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    int amountOfXSteps = [self amountOfStepsToX:0];
    int amountOfYSteps = [self amountOfStepsToY:0];
    
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
        
        tookApple = NO;
        mooving = NO;
        if ([potentialApples count] != 0) {
            [self startMooving];
        }
    });

    
}


- (int) amountOfStepsToX:(int)targetX {
//    NSLog(@"curX: %d, appleX: %d", self.curLocationX, [apple xCoord]);
    return self.curLocationX - targetX;
}

- (int) amountOfStepsToY:(int)targetY {
    return self.curLocationY - targetY;
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
@synthesize tookApple;

@dynamic age;
@dynamic speed;
@dynamic gender;
@dynamic apples;

@end
