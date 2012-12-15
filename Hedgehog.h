//
//  Hedgehog.h
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Hedgehog : NSManagedObject{
    NSMutableArray * potentialApples;
    BOOL mooving;
    NSInteger hedgehogID;
}

-(id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context HomeLocationX: (NSInteger) homeLocation_x HomeLocationY: (NSInteger) homeLocation_y;

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSSet *apples;
@property (assign) NSInteger homeLocationX;
@property (assign) NSInteger homeLocationY;
@property (assign) NSInteger curLocationX;
@property (assign) NSInteger curLocationY;
@property (assign) NSMutableArray *potentialApples;
@property (assign) BOOL mooving;
@property (assign) NSInteger hedgehogID;

- (void) subscribeToNotifications;
- (void) startMooving;
- (int) amountOfStepsToX: (int)x ;
- (int) amountOfStepsToY:(int)y;
- (void) moveToHome;
@end

@interface Hedgehog (CoreDataGeneratedAccessors)

- (void)addApplesObject:(NSManagedObject *)value;
- (void)removeApplesObject:(NSManagedObject *)value;
- (void)addApples:(NSSet *)values;
- (void)removeApples:(NSSet *)values;
@end
