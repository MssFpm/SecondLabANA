//
//  Cell.h
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tree.h"
#import "Hedgehog.h"
#import "Apple.h"

@interface Cell : NSObject {
	Tree* tree;
    Hedgehog* hedgehog;
	Apple* apple;
}

@property (assign) Tree* tree;
@property (assign) Hedgehog* hedgehog;
@property (assign) Apple* apple;


@end
