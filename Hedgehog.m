//
//  Hedgehog.m
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Hedgehog.h"
#import "Apple.h"


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
}

- (void) respondToNewApple: (NSNotification*) notification {
    id apple = [notification object];
    [potentialApples addObject:apple];
    if (!mooving) {
        NSLog(@"start mooving");
        [self startMooving];
    }
}

- (void) startMooving {
    mooving = YES;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    id apple = [potentialApples objectAtIndex:0];

    

    BOOL xSign = [self amountOfStepsToAppleX:apple] > 0;
    
    NSLog(@"amount = %d", fabs([self amountOfStepsToAppleX:apple]));
    
    dispatch_apply(((int)fabs([self amountOfStepsToAppleX:apple])), queue, ^(size_t i) {
        NSLog(@"in block, i = %d", i);
        self.curLocationX += xSign ? 1 : -1;
    });
    
    NSLog(@"after block");
    BOOL ySign = [self amountOfStepsToAppleY:apple] > 0;  
    dispatch_apply((int)fabs([self amountOfStepsToAppleY:apple]), queue, ^(size_t i) {
        self.curLocationY += ySign ? 1 : -1;
    });
}

- (int) amountOfStepsToAppleX:(id)apple {
        NSLog(@"curX: %d, appleX: %d", self.curLocationX, [apple xCoord]);
    return self.curLocationX - [apple xCoord];
}

- (int) amountOfStepsToAppleY:(id)apple {
    return self.curLocationY - [apple yCoord];
}


@synthesize homeLocationX;
@synthesize homeLocationY;
@synthesize curLocationX;
@synthesize curLocationY;
@synthesize potentialApples;
@synthesize mooving;

@dynamic age;
@dynamic speed;
@dynamic gender;
@dynamic apples;

@end
