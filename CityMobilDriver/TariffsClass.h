//
//  TariffsClass.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "TariffElements.h"
@interface TariffsClass : JSONModel
@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)NSMutableArray<TariffElements>*Tariff;
@end
