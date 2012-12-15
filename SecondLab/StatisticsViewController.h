//
//  StatisticsViewController.h
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITableView *statisticsTableView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) NSArray *hedgehogs;
@end
