//
//  CarInfoViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilViewController.h"
#import "EditCarInfoViewController.h"
#import "RequestGetCarInfo.h"
#import "SingleDataProvider.h"
#import "ResponseGetCarInfo.h"

@interface CarInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *carInfoTable;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;
- (IBAction)segmentControllAction:(UISegmentedControl*)sender;
- (IBAction)edit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;

@end