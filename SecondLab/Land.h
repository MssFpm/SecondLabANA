//
//  Land.h
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Land : NSTimer{
    int dayOfYear;
    id simulationView;
}
- (id)initWithDayOfYear:(int)day andView:(id)view;

@property (assign) int dayOfYear;
@property (assign) id simulationView;

@end
