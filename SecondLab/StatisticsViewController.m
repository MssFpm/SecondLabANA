//
//  StatisticsViewController.m
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatisticsViewController.h"
#import "Hedgehog.h"

@implementation StatisticsViewController
@synthesize statisticsTableView;
@synthesize segmentControl;
@synthesize hedgehogs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib. 
}

- (void)viewDidUnload
{
    [self setStatisticsTableView:nil];
    [self setSegmentControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id appDelegate = [[UIApplication sharedApplication] 
                      delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *hedgehog = [NSEntityDescription    
                                     entityForName:@"Hedgehog" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:hedgehog];
    NSArray *matching_objects = [context executeFetchRequest:request error:nil];
    [self setHedgehogs:matching_objects];
    return [matching_objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init] ;
    // Configure the cell.
//    cell.textLabel.text = @"CELL";  
    NSString * str = [[NSString alloc] initWithFormat: @"%d", [[[hedgehogs objectAtIndex: [indexPath row]] age] intValue]];
    [[cell textLabel] setText: str]; 
    NSLog(@"%d", [[[hedgehogs objectAtIndex: [indexPath row]] age] intValue]);
    return cell;
    
}

- (void)dealloc {
    [statisticsTableView release];
    [segmentControl release];
    [super dealloc];
}
@end
