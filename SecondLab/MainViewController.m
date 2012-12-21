//
//  MainViewController.m
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "StatisticsViewController.h"
#import "SimulationViewController.h"

@implementation MainViewController
@synthesize showStatisticsButton;
@synthesize startSimulationButton;

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

- (IBAction)goToStatistics:(id)sender {
    StatisticsViewController *statisticsView = [[StatisticsViewController alloc] initWithNibName:@"StatisticsViewController" bundle:nil];
    [self.navigationController pushViewController:statisticsView animated:YES];
    [statisticsView release];
}
- (IBAction)goToSimulation:(id)sender {
    SimulationViewController *simulationViewController = [[SimulationViewController alloc] initWithNibName:@"SimulationViewController" bundle:nil];
    [self.navigationController pushViewController:simulationViewController animated:YES];
    [simulationViewController release];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setShowStatisticsButton:nil];
    [self setStartSimulationButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [showStatisticsButton release];
    [startSimulationButton release];
    [super dealloc];
}
- (IBAction)clearDatabase:(id)sender {
    id appDelegate =  [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest * allHedgehogs = [[NSFetchRequest alloc] init];
    [allHedgehogs setEntity:[NSEntityDescription entityForName:@"Hedgehog" inManagedObjectContext:context]];
    [allHedgehogs setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSArray *hedgehogs = [context executeFetchRequest:allHedgehogs error:nil];
    for (NSManagedObject * hedgehog in hedgehogs) {
        [context deleteObject:hedgehog];
    }
    [context save:nil];

    
}
@end
