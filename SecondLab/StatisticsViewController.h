//
//  StatisticsViewController.h
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HEDGEHOGS_RESULT_TABLE 0
#define APPLES_RESULT_TABLE 1;

@interface StatisticsViewController : UIViewController
// extern int const HEDGEHOGS_RESULT_TABLE;
// extern int const APPLES_RESULT_TABLE;

@property (retain, nonatomic) IBOutlet UITableView *statisticsTableView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) NSArray *hedgehogs;
@property (retain) NSArray *apples;
@property int selectedStatistic;
- (IBAction)changeTableForStatistic:(id)sender;
@end
