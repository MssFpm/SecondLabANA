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

-(id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context coordX: (NSInteger) coordX coordY: (NSInteger) coordY{
    self = [super initWithEntity: entity insertIntoManagedObjectContext:context];
    if(self){
        self.xCoord = coordX;
		self.yCoord = coordY;
    }
    
    return self;
}


- (void) subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToTick:) name:@"TickNotification" object:nil];    
}

- (NSString *) getRandomType {
    NSArray *types = [[NSArray alloc] initWithObjects:@"First Type", @"Second Type", @"Fourth Type", nil];
    int randomIndex = arc4random() % [types count];
    
    return [types objectAtIndex:randomIndex];
}

- (void) respondToTick: (NSNotification*) notification {
    
    if (apple == NULL) {
        id appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];       
        NSEntityDescription *entityDescription =[NSEntityDescription entityForName:@"Apple" inManagedObjectContext:context];
        apple = [[Apple alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        NSLog(@"x=%d,y=%d",self.xCoord, self.yCoord);
               
        [apple setType: [self getRandomType]];
        [apple setXCoord: self.xCoord];
        [apple setYCoord: self.yCoord];
        [cell setApple:apple];
        [apple setCell:[self cell]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewAppleNotification" object:apple];
        // remove!
//        [apple release];
        
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

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
