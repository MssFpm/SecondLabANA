//
//  SimulationView.m
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimulationView.h"
#import "Cell.h"
#import "Tree.h"
#import "Hedgehog.h"

@implementation SimulationView


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        maxNumberOfHedgehog = 5;
        xLines = 7;
        yLines = 7;
        treeImage = [UIImage imageNamed:@"1353749451_tree.png"];
        hedgehogImage = [UIImage imageNamed:@"rsz_hedgehog-icon.png"];
        appleImage = [UIImage imageNamed:@"apple-icon.png"];
        homeImage = [UIImage imageNamed:@"1356204118_house.png"];
        cgBounds = [self bounds];
        width = cgBounds.size.width;
        height = cgBounds.size.height;
        xDelta = width / xLines;
        yDelta = height / yLines;
        cells = [[NSMutableArray alloc] initWithCapacity:xLines];
        NSArray *hedgehogs = [self getHedgehogsFromDatabase];
        int i;
        for (i = 0; i < xLines; i++) {
            NSMutableArray *inner = [[NSMutableArray alloc] initWithCapacity:yLines];
            int j;
            for (j = 0; j < yLines; j++) {
                Cell *cell = [[Cell alloc] init];
                [inner addObject:cell];
                int x = arc4random() % xLines;
                NSLog(@"x = %d", x);
                if (x == 3) {
                    Tree *tree = [[Tree alloc] initWithCoordX: i andCoordY: j];
                    [tree subscribeToNotifications];
                    [cell setTree:tree];
                    [tree setCell:cell];
                    [tree release];
                }
               
                if ((x == 4)&&(maxNumberOfHedgehog >= 0)) {
                    Hedgehog *hedgehog;
                    id appDelegate = [[UIApplication sharedApplication] delegate];
                    NSManagedObjectContext *context = [appDelegate managedObjectContext];
                    if ((hedgehogs.count == 0) || (hedgehogs.count < (5- maxNumberOfHedgehog + 1))) {
                                               NSEntityDescription *entityDescription =[NSEntityDescription entityForName:@"Hedgehog" inManagedObjectContext:context];
                        hedgehog = [[Hedgehog alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context HomeLocationX:i HomeLocationY:j];
                    } else {
                        hedgehog = [hedgehogs objectAtIndex:(5 - maxNumberOfHedgehog)];
                    }
                    NSLog(@"hedgehog's coords: x=%d y=%d", i,j);
                    
                    [hedgehog subscribeToNotifications];
                    [hedgehog setHedgehogID:maxNumberOfHedgehog];
                    [cell setHedgehog:hedgehog];
                    [hedgehog release];
                    [context save:nil];
                    maxNumberOfHedgehog--;
                    
                }
                [cell release];
            }
            [cells addObject:inner];
            [inner release];
        }
        NSLog(@"%d amount of hedhegogs", 5 - maxNumberOfHedgehog);
        
        
    }
    return self;    
}

- (NSArray *)getHedgehogsFromDatabase {
    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest * allHedgehogs = [[NSFetchRequest alloc] init];
    [allHedgehogs setEntity:[NSEntityDescription entityForName:@"Hedgehog" inManagedObjectContext:context]];
    [allHedgehogs setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSArray *hedgehogs = [context executeFetchRequest:allHedgehogs error:nil];
    
    return hedgehogs;
}

- (void) setupDrawConfiguration: (CGContextRef)context {
    
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, cgBounds);
}

- (void) drawGrid: (CGContextRef)context {
    int i;
	for (i = 0; i < xLines; i++) {
		CGContextMoveToPoint(context, i * xDelta, height + 100);
		CGContextAddLineToPoint(context, i * xDelta, 0);
	}
    
	for (i = 0; i < yLines; i++) {
		CGContextMoveToPoint(context, 0, i * yDelta);
		CGContextAddLineToPoint(context, width, i * yDelta);
	}
}

- (void) drawField: (CGContextRef)context {
    
    int i;
	for (i = 0; i < xLines; i++) {
		int j;
		NSMutableArray *inner = [cells objectAtIndex:i];
		for (j = 0; j < yLines; j++) {
			Cell* cell = [inner objectAtIndex:j];
			Tree* tree = cell.tree;
            if ((i == 0) && (j == 0)) {
               CGPoint homePoint = CGPointMake(0, 0);
                [homeImage drawAtPoint:homePoint];
            }
			if (tree != NULL) {
                CGPoint imagePoint = CGPointMake(xDelta * tree.xCoord, yDelta * tree.yCoord);
                [treeImage drawAtPoint:imagePoint];
                id apple = [cell apple];
                if (apple != NULL) {
                    CGPoint applePoint = CGPointMake(xDelta * [apple xCoord] + 20, yDelta * [apple yCoord] + 20);
                    [appleImage drawAtPoint:applePoint];
                }
            }
            Hedgehog* hedgehog = cell.hedgehog;
			if (hedgehog != NULL) {
                CGPoint imagePoint = CGPointMake(xDelta * hedgehog.curLocationX +20, yDelta * hedgehog.curLocationY +20);
                [hedgehogImage drawAtPoint:imagePoint];
            }
		}
	}
}

- (void)drawRect:(CGRect)rect {
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    [self setupDrawConfiguration: context];
    [self drawGrid:context];
    [self drawField:context];
	CGContextSetLineWidth(context, 0.5);
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
	CGContextStrokePath(context);
}


@synthesize maxNumberOfHedgehog;
@synthesize hedgehogs;
@synthesize height;
@synthesize cells;
@synthesize xDelta;
@synthesize yDelta;
@synthesize treeImage;
@synthesize appleImage;
@synthesize hedgehogImage;
@synthesize cgBounds;
@synthesize treeMaskRef;
@synthesize xLines;
@synthesize yLines;
@synthesize width;
@synthesize homeImage;

@end
