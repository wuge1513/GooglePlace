//
//  PlaceDetailViewController.h
//  GooglePlace
//
//  Created by Lei Liu on 12-5-21.
//  Copyright (c) 2012年 Coolinsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) UITableView *tbPlaceDetail;
@property (strong, nonatomic) NSMutableDictionary *dicPlaceDetail;

@end
