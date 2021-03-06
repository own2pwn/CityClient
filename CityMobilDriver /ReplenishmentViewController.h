//
//  ReplenishmentViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenu.h"
#import "CustomView.h"
#import "ComboBoxTableView.h"
#import "CustomView2.h"

@interface ReplenishmentViewController : UIViewController<UIWebViewDelegate,view1Delegate,ComboBoxDelegate,view1_2Delegate>
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)replenishmentSegmentedControl:(UISegmentedControl *)sender;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
- (IBAction)back:(id)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
- (IBAction)openMap:(UIButton*)sender;
@end
