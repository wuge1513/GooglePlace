//
//  PlaceDetailViewController.m
//  GooglePlace
//
//  Created by Lei Liu on 12-5-21.
//  Copyright (c) 2012年 Coolinsoft. All rights reserved.
//

#import "PlaceDetailViewController.h"

@implementation PlaceDetailViewController

@synthesize tbPlaceDetail;
@synthesize dicPlaceDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //初始化
        self.dicPlaceDetail = [[NSMutableDictionary alloc] init];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    CGRect tbRect = CGRectMake(0.0, 0.0, 320.0, 416.0);
    self.tbPlaceDetail = [[UITableView alloc] initWithFrame:tbRect style:UITableViewStylePlain];
    self.tbPlaceDetail.delegate = self;
    self.tbPlaceDetail.dataSource = self;
    [self.view addSubview:self.tbPlaceDetail];
    
    NSLog(@"123 = %@", self.dicPlaceDetail);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark TableView Delegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    //if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    //}
    if (indexPath.row == 0) {
        NSString *name = [self.dicPlaceDetail objectForKey:@"name"];
        cell.textLabel.text = name;
    }else if (indexPath.row == 1){
        cell.textLabel.text = [self.dicPlaceDetail objectForKey:@"international_phone_number"];
    }else if (indexPath.row == 2){
        NSNumber *x =  [self.dicPlaceDetail objectForKey:@"rating"];
        cell.textLabel.text = [NSString stringWithFormat:@"%.2f",x.floatValue];
    }else if (indexPath.row == 3){
        cell.textLabel.text = [self.dicPlaceDetail objectForKey:@"website"];
    }
        

    
    return cell;
}

@end
