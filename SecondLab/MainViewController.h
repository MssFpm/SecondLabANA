//
//  MainViewController.h
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *showStatisticsButton;
@property (retain, nonatomic) IBOutlet UIButton *startSimulationButton;
- (IBAction)clearDatabase:(id)sender;

@end
