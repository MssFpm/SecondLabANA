//
//  StatisticsViewController.m
//  SecondLab
//
//  Created by student on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatisticsViewController.h"
#import "Hedgehog.h"
#import "Apple.h"

@implementation StatisticsViewController
@synthesize statisticsTableView;
@synthesize segmentControl;
@synthesize hedgehogs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        int const HEDGEHOGS_RESULT_TABLE = 0;
//        int const APPLES_RESULT_TABLE = 1;
        self.selectedStatistic = HEDGEHOGS_RESULT_TABLE;
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
    NSArray *matching_objects;
    if (self.selectedStatistic == HEDGEHOGS_RESULT_TABLE) {
        NSEntityDescription *hedgehog = [NSEntityDescription
                                     entityForName:@"Hedgehog" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:hedgehog];
        matching_objects = [context executeFetchRequest:request error:nil];
        [self setHedgehogs:matching_objects];
    }
    else {
//        NSEntityDescription *apple = [NSEntityDescription
//                                         entityForName:@"Apple" inManagedObjectContext:context];
//        NSFetchRequest *request = [[NSFetchRequest alloc] init];
//        [request setEntity:apple];
//        matching_objects = [context executeFetchRequest:request error:nil];
//        [self setApples: matching_objects];
        matching_objects = [NSArray arrayWithObjects: @1,nil];
    }
    
    return [matching_objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init] ;
    NSMutableString *labelText = [[NSMutableString alloc] init];
    UIImage *cellImage;

    if(self.selectedStatistic == HEDGEHOGS_RESULT_TABLE) {
        Hedgehog *hedgehog = [hedgehogs objectAtIndex: [indexPath row]];
        int applesCount = [[hedgehog apples] count];
    
        NSString *hedgehogID = [[[hedgehog objectID] URIRepresentation] lastPathComponent];
        [labelText appendString: hedgehogID];
        NSString *countInString = [[NSString alloc] initWithFormat:@" with %i apple(s)", applesCount];
        cellImage = [UIImage imageNamed:@"hedgehog-icon.png"];
        [labelText appendString:countInString];
    }
    else {
        id appDelegate = [[UIApplication sharedApplication]
                          delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *appleEntityDescription = [NSEntityDescription entityForName:@"Apple" inManagedObjectContext:context];
        Apple *apple = [self.apples objectAtIndex:[indexPath row]];
        NSAttributeDescription *appleTypeDescription = [appleEntityDescription.attributesByName objectForKey:@"type"];
        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"type"];
        NSExpression *countExpression = [NSExpression expressionForFunction:@"count:" arguments:[NSArray arrayWithObjects:keyPathExpression, nil]];
        NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
        [expressionDescription setName:@"count"];
        [expressionDescription setExpression:countExpression];
        [expressionDescription setExpressionResultType:NSInteger32AttributeType];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Apple"];
        [request setPropertiesToFetch:[NSArray arrayWithObjects:appleTypeDescription, expressionDescription, nil]];
        [request setPropertiesToGroupBy:[NSArray arrayWithObjects:appleTypeDescription, nil]];
        [request setResultType:NSDictionaryResultType];
        NSArray *results = [context executeFetchRequest:request error:nil];
        NSLog(@"--111 0   %i", results.count);
        id obj = [[results objectAtIndex:0] allKeys] ;
        NSLog(@"A  %@", obj);
        NSString *type = [[results objectAtIndex:0] valueForKey:@"type"];
        NSString *count = [[NSString alloc] initWithFormat:@"-- %@", [[results objectAtIndex:0] valueForKey:@"count"]];
        [labelText appendString:type];
        [labelText appendString:count];
        cellImage = [UIImage imageNamed:@"apple-icon.png"];
        
    }
    [[cell textLabel] setText: labelText];
    [[cell imageView] setImage:cellImage];
    return cell;
    
}

- (void)dealloc {
    [statisticsTableView release];
    [segmentControl release];
    [super dealloc];
}
- (IBAction)changeTableForStatistic:(id)sender {
    self.selectedStatistic = [self.segmentControl selectedSegmentIndex];
    [self.statisticsTableView reloadData];
}
@end
