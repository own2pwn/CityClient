//
//  RequestGetModelList.h
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface RequestGetModelList : JSONModel
@property(nonatomic,strong) NSString* method;
@property(nonatomic,strong) NSString* ipass;
@property(nonatomic,strong) NSString* ilog;
@property(nonatomic,strong) NSString* key;
@property(nonatomic,strong) NSString* locale;
@property(nonatomic,strong) NSString* version;
@property(nonatomic,assign) NSInteger id_mark;
@end