//
//  MasterViewController.h
//  GooglePlace
//
//  Created by Liu Lei on 12-3-27.
//  Copyright (c) 2012年 Coolinsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class DetailViewController;

@interface MasterViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) CLLocationManager *lm;  
@property (nonatomic,copy) NSString *strLatitude;
@property (nonatomic,copy) NSString *strLongitude;
@property (nonatomic,copy) NSString *strAccuracy;


@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSMutableArray *arrItemText;
@property (nonatomic, retain) NSMutableArray *arrItemImages;
@property (strong, nonatomic) NSMutableArray *arrGeometry;

@property (strong, nonatomic) IBOutlet UILabel *curAddress;
@property (strong, nonatomic) IBOutlet UITextField *tfType;
@property (strong, nonatomic) IBOutlet UITextField *tfRadius;


- (IBAction)btnAction:(id)sender;
@end
