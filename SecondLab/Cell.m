//
//  Cell.m
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (void)dealloc {
   
    if (tree != nil) {
        NSLog(@"tree retain count: %d", [tree retainCount]);
        [tree release];
        NSLog(@"reld tree");
    }
    if (apple != nil) {
        NSLog(@"apple retain count: %d", [apple retainCount]);
        [apple release];
        NSLog(@"reld apple");
    }
    if (hedgehog != nil) {
        NSLog(@"hedgehog retain count: %d", [hedgehog retainCount]);
        [hedgehog release];
        NSLog(@"reld hedge");
    }
    NSLog(@"CELL RELEASE"); 
    [super dealloc];
}
@synthesize tree;
@synthesize apple;
@synthesize hedgehog;


@end
