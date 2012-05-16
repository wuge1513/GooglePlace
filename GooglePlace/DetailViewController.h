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
@property (nonatomic, strong) NSMutableArray *arrImage;

@property (strong, nonatomic) UIToolbar *tbarMap;
@property (strong, nonatomic) UIView *mapView;
@property (strong, nonatomic) MKMapView *mkMapView;
@property (strong, nonatomic) CLLocation *curLocation;
@property (assign, nonatomic) BOOL isMapShowing;
@property (assign, nonatomic) BOOL isShowSubPageView;


@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lng;
@property (strong, nonatomic) NSMutableArray *arrGeometry;

- (void)showSubPageView;
- (void)actionUpdateLocation;
- (void)actionSegmentCtl:(id)sender;
- (void)actionBtnLoadMoreItem;
- (void)actionShowItemOnMap;
- (void)setCurrentLocation:(CLLocation *)location;


- (void)showItemDetailView;
@end
