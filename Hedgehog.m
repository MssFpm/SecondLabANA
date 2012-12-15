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
    // dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    id apple = [potentialApples objectAtIndex:0];
    
    //    dispatch_apply(((int)fabs([self amountOfStepsToAppleX:apple])), queue, ^(size_t i) {
    //        NSLog(@"in block, i = %d", i);
    //        self.curLocationX += xSign ? 1 : -1;
    //    });
    //    
    //    dispatch_apply((int)fabs([self amountOfStepsToAppleY:apple]), queue, ^(size_t i) {
    //        self.curLocationY += ySign ? 1 : -1;
    //    });
    
    int amountOfXSteps = [self amountOfStepsToAppleX:apple];
    int amountOfYSteps = [self amountOfStepsToAppleY:apple];
    
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
                //TODO: add apple to hedgehog
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AppleTaken" object:apple];
                
                Cell* cell = [apple cell];
                [cell setApple:NULL];
//                
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

- (int) amountOfStepsToAppleX:(id)apple {
    NSLog(@"curX: %d, appleX: %d", self.curLocationX, [apple xCoord]);
    return self.curLocationX - [apple xCoord];
}

- (int) amountOfStepsToAppleY:(id)apple {
    return self.curLocationY - [apple yCoord];
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
