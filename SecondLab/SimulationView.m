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
        cgBounds = [self bounds];
        width = cgBounds.size.width;
        height = cgBounds.size.height;
        xDelta = width / xLines;
        yDelta = height / yLines;
        cells = [[NSMutableArray alloc] initWithCapacity:xLines];
        NSLog(@"%d", xLines);	
        int i;
        for (i = 0; i < xLines; i++) {
            NSMutableArray *inner = [[NSMutableArray alloc] initWithCapacity:yLines];
            int j;
            for (j = 0; j < yLines; j++) {
                Cell *cell = [[Cell alloc] init];
                [inner addObject:cell];
                int x = arc4random() % xLines;
                if (x == 3) {
                    Tree *tree = [[Tree alloc] initWithCoordX: i andCoordY: j];
                    [tree subscribeToNotifications];
                    [cell setTree:tree];
                    [tree setCell:cell];
                    [inner addObject:cell];
                    [tree release];
                }
                if ((x ==  4)&&(maxNumberOfHedgehog-- >= 0)) {
                    id appDelegate = [[UIApplication sharedApplication] delegate];
                    NSManagedObjectContext *context = [appDelegate managedObjectContext];
                    NSEntityDescription *entityDescription =[NSEntityDescription entityForName:@"Hedgehog" inManagedObjectContext:context];
                    Hedgehog *hedgehog = [[Hedgehog alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context HomeLocationX:i HomeLocationY:j];
                    [hedgehog subscribeToNotifications];
                    [cell setHedgehog:hedgehog];
                    [inner addObject:cell];
                    [hedgehog release];
                    
                }
                [cell release];
                
                
            }
            [cells addObject:inner];
            [inner release];
        }
        
        
    }
    NSLog(@"into init coder");
    return self;    
}

- (void) setupDrawConfiguration: (CGContextRef)context {
    NSLog(@"Setup");
    
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, cgBounds);
}

- (void) drawGrid: (CGContextRef)context {
    int i;
	for (i = 0; i < xLines; i++) {
        NSLog(@"DRAW%d", i);
		CGContextMoveToPoint(context, i * xDelta, height + 100);
		CGContextAddLineToPoint(context, i * xDelta, 0);
	}
    
	for (i = 0; i < yLines; i++) {
        NSLog(@"DRAW%d", i);
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
			if (tree != NULL) {
				NSLog(@"x: %d, y: %d", tree.xCoord, tree.yCoord);
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
				NSLog(@"x: %d, y: %d", hedgehog.curLocationX, hedgehog.curLocationY);
                CGPoint imagePoint = CGPointMake(xDelta * hedgehog.curLocationX, yDelta * hedgehog.curLocationY);
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

@end
