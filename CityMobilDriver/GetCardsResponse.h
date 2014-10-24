//
//  GetCardsResponse.h
//  CityMobilDriver
//
//  Created by Intern on 10/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"

@interface GetCardsResponse : JSONModel
@property(strong,nonatomic)NSMutableArray*cards;
@property(nonatomic,strong)NSString*code;
@property(strong,nonatomic)NSString*text;
@end
