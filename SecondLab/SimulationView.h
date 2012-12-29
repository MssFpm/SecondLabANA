//
//  SimulationView.h
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimulationView : UIView {
    int xLines;
	int yLines;
	float xDelta;
	float yDelta;
    float width;
    float height;
	NSMutableArray* cells;
  	CGImageRef treeMaskRef;
	CGRect cgBounds;
    UIImage *treeImage;
    UIImage *hedgehogImage;
    UIImage *appleImage;
    NSInteger maxNumberOfHedgehog;
}

- (void)setupDrawConfiguration:(CGContextRef) context;
- (void) drawGrid:(CGContextRef) context;
- (NSArray*) getHedgehogsFromDatabase;

@property NSInteger maxNumberOfHedgehog;
@property int xLines;
@property int yLines;
@property float xDelta;
@property float yDelta;
@property float width;
@property float height;
@property (retain) NSMutableArray* cells;
@property CGImageRef treeMaskRef;
@property CGRect cgBounds;
@property (assign) UIImage* treeImage;
@property (assign) UIImage* hedgehogImage;
@property (assign) UIImage* appleImage;



@end
