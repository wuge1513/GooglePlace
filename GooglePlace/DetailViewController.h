//
//  DetailViewController.h
//  GooglePlace
//
//  Created by Liu Lei on 12-3-27.
//  Copyright (c) 2012年 Coolinsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController<MKMapViewDelegate>


@property (assign, nonatomic) NSInteger curItemCount;
@property (assign, nonatomic) NSInteger totalItemCount;
@property (strong, nonatomic) UIButton *btnLoadMoreItem;

@property (strong, nonatomic) IBOutlet UITableView *tbPlaceList;
@property (nonatomic,copy) NSMutableArray *muArray; 
@property (nonatomic, retain) NSMutableArray *arrImage;

@property (strong, nonatomic) UIView *mapView;
@property (assign, nonatomic) BOOL isMapShowing;
@property (strong, nonatomic) MKMapView *mkMapView;


@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lng;
@property (strong, nonatomic) NSMutableArray *arrGeometry;


- (void)actionBtnLoadMoreItem;
- (void)actionShowItemOnMap;

@end
