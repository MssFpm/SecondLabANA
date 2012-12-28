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
    [apple release];
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
    if (potentialApples == nil) {
        return;
    }
    
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
                NSLog(@"still mooving to apple");
            }
            for (int i = 0; i < fabs(amountOfYSteps); i++) {
                self.curLocationY += ySign ? -1 : +1;
                [NSThread sleepForTimeInterval:delayInSeconds];
                NSLog(@"still mooving to apple");
            }
        
        NSLog(@"mooving completed");
        
        @synchronized (apple) {
            NSLog(@"in synchronized!!!");
            NSLog(@"--> %@", potentialApples);
            if ([potentialApples containsObject:apple]) {
                NSLog(@"before cell getting");
                NSLog(@"->>>>>>>apple %@", apple);
                Cell* cell = [apple cell];
                NSLog(@"->>>>>>>>>>>cell %@", cell);
                [cell setApple:nil];
                id appDelegate = [[UIApplication sharedApplication]
                                  delegate];
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                [self addApplesObject:apple];
                tookApple = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AppleTaken" object:apple];
                
                [context save:nil];
            }
        }
        NSLog(@"after synchronized");
        mooving = NO;
//        [apple release];
        if ([potentialApples count] != 0 && !tookApple) {
            [self startMooving];
        } else {
            [self goHome];
        }
    });
}

- (int) amountOfStepsToAppleX:(int)appleX {
    return self.curLocationX - appleX;
}

- (int) amountOfStepsToAppleY:(int)appleY{
    return self.curLocationY - appleY;
}

- (void) goHome {
    int amountOfXSteps = [self amountOfStepsToAppleX:0];
    int amountOfYSteps = [self amountOfStepsToAppleY:0];
    
    BOOL xSign = amountOfXSteps > 0;
    BOOL ySign = amountOfYSteps > 0;
    double delayInSeconds = .5;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i < fabs(amountOfXSteps); i++) {
            self.curLocationX += xSign ? -1 : +1;
            [NSThread sleepForTimeInterval:delayInSeconds];
            NSLog(@"still mooving home");
        }
        for (int i = 0; i < fabs(amountOfYSteps); i++) {
            self.curLocationY += ySign ? -1 : +1;
            [NSThread sleepForTimeInterval:delayInSeconds];
            NSLog(@"still mooving home");
        }
        tookApple = NO;
        if ([potentialApples count] != 0) {
            [self startMooving];
        }
    });
    
    
}

- (void)dealloc {
    [potentialApples release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

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
