//
//  OrdersHistoryElements.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@protocol OrdersHistoryElements @end
@interface OrdersHistoryElements : JSONModel
@property(nonatomic,strong)NSString* yandex_rating;
@property(nonatomic,strong)NSString * yandex_review;
@property(nonatomic,strong)NSString * idhash;
@property(nonatomic,strong)NSString * CollDate;
@property(nonatomic,strong)NSString *  tariff;
@property(nonatomic,strong)NSString * status;
@property(nonatomic,strong)NSString *OrderedDate;
@property(nonatomic,assign)NSInteger CollAddrTypeMenu;
@property(nonatomic,assign)NSInteger DeliveryAddrTypeMenu;
@property(nonatomic,strong)NSString *CollMetro;
@property(nonatomic,strong)NSString *DeliveryMetro;
@property(nonatomic,strong)NSString * price;
@property(nonatomic,strong)NSString *OrderFinished;
@property(nonatomic,strong)NSString *shortname;
@property(nonatomic,strong)NSString *CollMetroName;
@property(nonatomic,strong)NSString * DeliveryMetroName;
@end

