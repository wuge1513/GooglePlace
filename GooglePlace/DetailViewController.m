//
//  DetailViewController.m
//  GooglePlace
//
//  Created by Liu Lei on 12-3-27.
//  Copyright (c) 2012年 Coolinsoft. All rights reserved.
//

#import "DetailViewController.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "LLAnnotationView.h"

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


#import "UtilityClass.h"
#import "LLFileManage.h"

#import "SBJson.h"
#import "NSString+SBJSON.h"

#import "MasterViewController.h"

#define kCURRENT_ITEM_COUNT      5

@implementation DetailViewController

@synthesize curItemCount, totalItemCount;
@synthesize btnLoadMoreItem;
@synthesize tbPlaceList;
@synthesize muArray, arrImage;
@synthesize mapView, isMapShowing, mkMapView, lat, lng, arrGeometry, curLocation;
@synthesize tbarMap;

- (void)dealloc
{
    [btnLoadMoreItem release];
    [arrImage release];
    [tbPlaceList release];
    [muArray release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Places", @"Places");
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStyleBordered target:self action:@selector(actionShowItemOnMap)];
        self.muArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        NSMutableArray *_arrGeometry = [[NSMutableArray alloc] init];
        self.arrGeometry = _arrGeometry;
        [_arrGeometry release];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.curItemCount = kCURRENT_ITEM_COUNT;
	self.totalItemCount = [self.muArray count];
    NSLog(@"ddd = %d", self.totalItemCount);
    
    //初始图片
    for (NSInteger i = 0; i < kCURRENT_ITEM_COUNT; i++) {
        NSDictionary *dic = [self.muArray objectAtIndex:i];
        NSString *str1 = [dic objectForKey:@"icon"];
        //获取图片
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:str1]];
        UIImage *img = [UIImage imageWithData:data];
        [self.arrImage addObject:img];
    }

    
    //add load more btn in last cell
    self.btnLoadMoreItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnLoadMoreItem.frame = CGRectMake(10.0, 20.0, 300.0, 40.0);
    [self.btnLoadMoreItem setTitle:@"加载更多..." forState:UIControlStateNormal];
    [self.btnLoadMoreItem addTarget:self action:@selector(actionBtnLoadMoreItem) forControlEvents:UIControlEventTouchUpInside];
    

    UIView *_mapView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
    self.mapView = _mapView;
    [_mapView release];
    self.mapView.backgroundColor = [UIColor orangeColor];
    self.mapView.hidden = YES;
    [self.view addSubview:self.mapView];
    
    //bottom tool bar
    self.tbarMap = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 376.0, 320.0, 40.0)];
    self.tbarMap.barStyle = UIBarStyleDefault;
    [self.mapView addSubview:self.tbarMap];
    
    //space
    UIBarButtonItem *barItem0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                                  target:nil 
                                                                                  action:nil];
    
    UIBarButtonItem *barItemLocation = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Location.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(actionUpdateLocation)];
    UIBarButtonItem *barItemSubPage = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(showSubPageView)];
    [self.tbarMap sizeToFit];
    [self.tbarMap setItems:[NSArray arrayWithObjects:barItemLocation, barItem0, barItem0, barItem0, barItemSubPage, nil]];
    
    //convert map type
    UISegmentedControl *segCtl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"标准", @"卫星", @"混合", nil]];
    segCtl.segmentedControlStyle = UISegmentedControlStyleBar;
    segCtl.frame = CGRectMake(0.0, 0.0, 120.0, 30.0);
    segCtl.center = CGPointMake(160.0, 23.0);
    segCtl.selectedSegmentIndex = 0;
    [segCtl addTarget:self action:@selector(actionSegmentCtl:) forControlEvents:UIControlEventValueChanged];
    [self.tbarMap addSubview:segCtl];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark List action methods

- (void)actionBtnLoadMoreItem
{
    for (NSInteger i = self.curItemCount; i < self.curItemCount + kCURRENT_ITEM_COUNT; i++) {
        NSDictionary *dic = [self.muArray objectAtIndex:i];
        NSString *str1 = [dic objectForKey:@"icon"];
        //获取图片
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:str1]];
        UIImage *img = [UIImage imageWithData:data];
        [self.arrImage addObject:img];
        
        //位置坐标
        NSDictionary *dicGeometry = [dic objectForKey:@"geometry"];
        [self.arrGeometry addObject:dicGeometry];
    }
    
    self.curItemCount += kCURRENT_ITEM_COUNT;
    
    if(self.curItemCount >= self.totalItemCount)
        self.curItemCount = totalItemCount;
    
    [self.tbPlaceList reloadData];  //重新加载表视图
    [self.tbPlaceList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.curItemCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)showItemDetailView
{
    NSLog(@"detail...");
}


#pragma mark -
#pragma mark Map action methods
- (void)showSubPageView
{

}

- (void)actionUpdateLocation
{

}

- (void)actionSegmentCtl:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    NSLog(@"===%d",seg.selectedSegmentIndex);
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            self.mkMapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mkMapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mkMapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}


- (void)setCurrentLocation:(CLLocation *)location
{
    MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
    region.center = location.coordinate;
    region.span.longitudeDelta = 0.1f;
    region.span.latitudeDelta = 0.1f;
    [self.mkMapView setRegion:region animated:YES];
}

//地图标注
- (void)showMap
{
    MKMapView *_mkMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 376.0)];
    self.mkMapView = _mkMapView;
    [_mkMapView release];
    self.mkMapView.delegate = self;
    self.mkMapView.showsUserLocation = YES;
    self.mkMapView.autoresizesSubviews = YES;
    [self.mapView addSubview:self.mkMapView];
    
    [self setCurrentLocation:self.curLocation];
    
    for (NSInteger i = 0; i < self.curItemCount; i++) {
        NSDictionary *dic = [self.muArray objectAtIndex:i];
        NSString *name = [dic objectForKey:@"name"];
        NSString *address = [dic objectForKey:@"vicinity"];
        
        //坐标
        NSDictionary *dicGeo = [self.arrGeometry objectAtIndex:i];
        NSDictionary *dicLocation = [dicGeo objectForKey:@"location"];
        NSString *lat1 = [dicLocation objectForKey:@"lat"];
        NSString *lng1 = [dicLocation objectForKey:@"lng"];
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = [lat1 floatValue];
        theCoordinate.longitude = [lng1 floatValue];
        
        
        
        DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];
        annotation.title = name;//@"Drag to Move Pin";
        annotation.subtitle = address;//[NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
        [self.mkMapView addAnnotation:annotation];
    }      
}

- (void)actionShowItemOnMap
{
    if (!self.isMapShowing) {
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
        self.mapView.hidden = NO;
        [UIView commitAnimations];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleBordered target:self action:@selector(actionShowItemOnMap)];
    
        [self showMap];
        
    }else{
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];
        self.mapView.hidden = YES;
        [UIView commitAnimations];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStyleBordered target:self action:@selector(actionShowItemOnMap)];
    }
    
    
    self.isMapShowing = !self.isMapShowing;
}


#pragma mark -
#pragma mark UITableView Methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(self.curItemCount >= self.totalItemCount)
		return self.curItemCount;
	else
        return self.curItemCount + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
   // }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([self.muArray count] >= 1) {
        
        if (indexPath.row == self.curItemCount) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:self.btnLoadMoreItem];
        }else{
            
            NSDictionary *dic = [self.muArray objectAtIndex:indexPath.row];
            
            NSString *str2 = [dic objectForKey:@"name"];
            NSString *str3 = [dic objectForKey:@"vicinity"];
            
            cell.imageView.image = [self.arrImage objectAtIndex:indexPath.row];
            cell.textLabel.text = str2;
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 55.0, 300, 20)];
            lbl.text = str3;
            lbl.font = [UIFont systemFontOfSize:12.0];
            lbl.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lbl];
            [lbl release];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];		
	}
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //当前位置自定义，可以更改
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //return nil;
        static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
        MKAnnotationView *draggablePinView = [self.mkMapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
        
        // Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
        draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:self.mkMapView];
        draggablePinView.canShowCallout = YES;
        draggablePinView.annotation = annotation;
        draggablePinView.selected = YES;
        
        return draggablePinView;
	}
    
    //其他标记位置
   MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ass"];
    newAnnotation.animatesDrop = YES;
    newAnnotation.canShowCallout=YES;
    newAnnotation.pinColor = MKPinAnnotationColorGreen;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(showItemDetailView) forControlEvents:UIControlEventTouchUpInside];
    newAnnotation.rightCalloutAccessoryView = rightButton;
    //rightButton.tag = [self setID:annotation.title Type:1];
    
    return newAnnotation;

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"123");
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    NSLog(@"456");
}

							
@end
