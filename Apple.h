//
//  Apple.h
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Apple : NSManagedObject{
    int xCoord;
    int yCoord;
    id cell;
}

@property (assign) int xCoord;
@property (assign) int yCoord;
@property (assign) id cell;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * state;

@end
