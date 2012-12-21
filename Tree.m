//
//  Tree.m
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tree.h"
#import "Apple.h"


@implementation Tree 

- (id) initWithCoordX: (int)x andCoordY: (int)y {
	self = [super init];
    if (self)  {
		self.xCoord = x;
		self.yCoord = y;
    }
    return self;
    
}

- (void) subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToTick:) name:@"TickNotification" object:nil];    
}

- (void) respondToTick: (NSNotification*) notification {
    
    if (apple == NULL) {      
        id appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];       
        NSEntityDescription *entityDescription =[NSEntityDescription entityForName:@"Apple" inManagedObjectContext:context];
        apple = [[Apple alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        [apple performSelector:@selector(setType:) withObject:@"FIRST"];
        NSLog(@"x=%d,y=%d",self.xCoord, self.yCoord);
        [apple setXCoord: self.xCoord];
        [apple setYCoord: self.yCoord];
        [cell setApple:apple];
        [apple setCell:[self cell]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewAppleNotification" object:apple];

    }
}
//- (void)dealloc{
//    [apple release];
//    [super dealloc];
//}

@dynamic age;
@dynamic timeOfRipening;
@dynamic probabilityOfDecay;
@dynamic probabilityOfWorminess;
@dynamic type;
@dynamic apples;
@synthesize xCoord;
@synthesize yCoord;
@synthesize apple;
@synthesize cell;


@end
