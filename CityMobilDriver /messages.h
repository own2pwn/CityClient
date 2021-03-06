//
//  messages.h
//  CityMobilDriver
//
//  Created by Intern on 10/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

@protocol messages
@end
#import "JSONModel.h"

@interface messages : JSONModel
@property(nonatomic,strong,getter=getId) NSString* id;
@property(nonatomic,strong, getter=getDate) NSString* date;
@property(nonatomic,strong) NSString* text;
@property(nonatomic,assign) NSInteger from_me;
@end
