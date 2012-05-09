//
//  MasterViewController.m
//  GooglePlace
//
//  Created by Liu Lei on 12-3-27.
//  Copyright (c) 2012年 Coolinsoft. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "SBJson.h"
#import "NSString+SBJSON.h"

#define USE_THREAD
#define kLOAD_IMAGES_NUM_FIRST     20

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize lm, curLocation;
@synthesize strLongitude, strAccuracy, strLatitude;
@synthesize tfType, tfRadius, curAddress;
@synthesize arrItemText, arrItemImages, receivedData, arrGeometry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        
        NSMutableArray *_arrItemText = [[NSMutableArray alloc] init];
        self.arrItemText = _arrItemText;
        [_arrItemText release];
        
        NSMutableArray *_arrItemImages = [[NSMutableArray alloc] initWithCapacity:kLOAD_IMAGES_NUM_FIRST];
        self.arrItemImages = _arrItemImages;
        [_arrItemImages release];
        
        for (NSInteger i = 0; i < kLOAD_IMAGES_NUM_FIRST; i++) {
            [self.arrItemImages addObject:[NSNull null]];
        }
        
        NSMutableData *_data = [[NSMutableData alloc] init];
        self.receivedData = _data;
        [_data release];
        
        NSMutableArray *_arrGeometry = [[NSMutableArray alloc] init];
        self.arrGeometry = _arrGeometry;
        [_arrGeometry release];
        
    }
    return self;
}
							
- (void)dealloc
{
    [arrGeometry release];
    [receivedData release];
    [arrItemText release];
    [arrItemImages release];
    
    [tfType release];
    [tfRadius release];
    
    [strAccuracy release];
    [strLatitude release];
    [strLongitude release];
    [lm release];
    
    [_detailViewController release];
    [super dealloc];
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
    
    self.tfType.text = @"food";
    self.tfRadius.text = @"1000";
    
	// Do any additional setup after loading the view, typically from a nib.
    //获取定位信息
    CLLocationManager *_lm = [[CLLocationManager alloc] init];  
    self.lm = _lm;
    //是否开启定位服务
    if ([self.lm locationServicesEnabled]) {  
        self.lm.delegate = self;
        //精确度
        self.lm.desiredAccuracy = kCLLocationAccuracyBest;
        //指定设备必须移动多少距离位置信息才会更新，这个属性的单位是米,可以使用kCLDistanceFilterNone常量
        self.lm.distanceFilter = 100.0f;
        //启动位置管理器
        [self.lm startUpdatingLocation];  
    } 
    [_lm release];
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


/*Place Search 请求
 location（必填）– 在其周围检索“地方”信息的纬度/经度。此参数必须作为 google.maps.LatLng 对象提供。
 radius（必填）– 要在其范围内返回的“地方”结果的距离（以米为单位）。推荐的最佳做法是根据位置传感器指定的地方信号的精确度来设置 radius。请注意，您可以将 radius 偏向结果设为指定的区域，但无法将结果完全限制在指定区域中。
 types（可选）– 将结果限制为至少匹配一种指定类型的“地方”。类型应使用竖线符号 (type1|type2|etc) 进行分隔。请参见支持的类型列表。
 language（可选）– 语言代码，表示返回结果时应使用的语言（如果可能的话）。请参见支持的语言列表及其代码。请注意，我们会经常更新支持的语言，因此该列表可能并不详尽。
 name（可选）– 要与“地方”的名称进行匹配的字词。这会将结果限制为包含传递的 name 值的结果。当加入名称时，系统可能会扩大搜索范围，以确保获得适量的结果。
 sensor（必填）- 表示位置请求是否来自于使用位置传感器（如 GPS）的设备，从而确定此请求中发送的位置。该值必须为 true 或 false。
 key（必填）– 您的应用程序的 API 密钥。此密钥用于标识您的应用程序，以便管理配额，从而让您的应用程序添加的“地方”可立即在该应用程序中使用。要创建 API 项目并获取密钥，请访问 API 控制台。
 */


- (IBAction)btnAction:(id)sender
{
    
    NSLog(@"===%@,%@", self.strLatitude, self.strLongitude);
    NSString *strLocation = [NSString stringWithFormat:@"%@,%@",self.strLatitude, self.strLongitude];
    NSString *strRadius = self.tfRadius.text;//@"500";
    NSString *strTypes = self.tfType.text;//@"bank"; 
    NSString *strName = @"";
    NSString *strSensor = @"false";
    NSString *strKey = API_KEY;
    

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *strURL = [NSString stringWithFormat:@"%@location=%@&radius=%@&types=%@&name=%@&sensor=%@&key=%@", PLACEAPI_SEARCHURL_JSON, strLocation, strRadius, strTypes, strName, strSensor, strKey];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSLog(@"url = %@", url);
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	[req setHTTPMethod:@"GET"];
	[NSURLConnection connectionWithRequest:req delegate:self];
    
}

- (void)loadImages:(NSNumber *)index
{
    NSDictionary *dic = [self.arrItemText objectAtIndex:[index integerValue]];
    
    //图片
    NSString *str1 = [dic objectForKey:@"icon"];
    //获取图片
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:str1]];
    UIImage *img = [UIImage imageWithData:data];
    [self.arrItemImages replaceObjectAtIndex:[index integerValue] withObject:img];
    
    //位置坐标 前5个
    NSDictionary *dicGeometry = [dic objectForKey:@"geometry"];
    [self.arrGeometry addObject:dicGeometry];
    NSLog(@"yes %d", [index integerValue]);
}

#pragma mark -
#pragma mark NSURLConnection

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[self.receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.receivedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    
    NSString *str = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"str = %@", str);
    
    NSMutableDictionary *jsonDic = [str JSONValue];
    NSLog(@"123 = %@", jsonDic);
    
    NSArray *arr = [jsonDic objectForKey:@"results"];
    NSLog(@"456 = %@", arr);
   
    self.arrItemText = [NSArray arrayWithArray:arr];
    
    for (NSInteger i = 0; i < kLOAD_IMAGES_NUM_FIRST; i++) {
        
#ifdef USE_THREAD
        [NSThread detachNewThreadSelector:@selector(loadImages:) toTarget:self withObject:[NSNumber numberWithInteger:i]];
#else
        NSDictionary *dic = [self.arrItemText objectAtIndex:i];
        
        //图片
        NSString *str1 = [dic objectForKey:@"icon"];
        //获取图片
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:str1]];
        UIImage *img = [UIImage imageWithData:data];
        [self.arrItemImages addObject:img];
        
        //位置坐标 前5个
        NSDictionary *dicGeometry = [dic objectForKey:@"geometry"];
        [self.arrGeometry addObject:dicGeometry];
        NSLog(@"no %d",i);
#endif
        
    }
    
    DetailViewController *dc = [[DetailViewController alloc] init];
    dc.muArray = self.arrItemText;
    dc.arrImage = self.arrItemImages;
    dc.lat = [self.strLatitude floatValue];
    dc.lng = [self.strLongitude floatValue];
    dc.arrGeometry = self.arrGeometry;
    dc.curLocation = self.curLocation;
    [self.navigationController pushViewController:dc animated:YES];
}

#pragma mark- 定位服务

//获得一个新的定位值时
- (void) locationManager: (CLLocationManager *) manager  
     didUpdateToLocation: (CLLocation *) newLocation  
            fromLocation: (CLLocation *) oldLocation{  
    
    self.curLocation = newLocation;
    
    NSString *lat = [NSString stringWithFormat:@"%g",  
                     newLocation.coordinate.latitude];  
    //纬度
    self.strLatitude = lat;
    NSLog(@"Latitude = %@", strLatitude);
    
    
    NSString *lng = [NSString stringWithFormat:@"%g",  
                     newLocation.coordinate.longitude];
    //经度
    self.strLongitude = lng;
    NSLog(@"Longitude = %@", strLongitude);
    
    
    //horizontalAccuracy属性可以指定精度范围，单位是米
    NSString *acc = [NSString stringWithFormat:@"%g",  
                     newLocation.horizontalAccuracy];  
    self.strAccuracy = acc; //精确度    
    
    self.curAddress.text = [NSString stringWithFormat:@"lat:%@, long:%@", lat, lng];
}  

//位置管理器不能确定位置信息
- (void) locationManager: (CLLocationManager *) manager  
        didFailWithError: (NSError *) error {  
    NSString *msg = @"Error obtaining location";  
    UIAlertView *alert = [[UIAlertView alloc]  
                          initWithTitle:@"Error"  
                          message:msg  
                          delegate:nil  
                          cancelButtonTitle: @"Done"  
                          otherButtonTitles:nil];  
    [alert show];       
    [alert release];  
}  



@end
