//
//  Tree.h
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Apple;

@interface Tree : NSManagedObject { 
    int xCoord;
    int yCoord;
    id apple;
    id cell;
    
}

- (id) initWithCoordX:(int)x andCoordY: (int)y;
- (id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context coordX: (NSInteger) coordX coordY: (NSInteger) coordY;
- (void) subscribeToNotifications;
- (void) respondToTick: (NSNotification*) notification;
- (NSString *) getRandomType;

@property int xCoord;
@property int yCoord;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * timeOfRipening;
@property (nonatomic, retain) NSString * probabilityOfDecay;
@property (nonatomic, retain) NSNumber * probabilityOfWorminess;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *apples;
@property (assign) id apple;
@property (assign) id cell;
@end

@interface Tree (CoreDataGeneratedAccessors)

- (void)addApplesObject:(Apple *)value;
- (void)removeApplesObject:(Apple *)value;
- (void)addApples:(NSSet *)values;
- (void)removeApples:(NSSet *)values;
@end
