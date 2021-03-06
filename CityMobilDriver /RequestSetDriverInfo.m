//
//  RequestSetDriverInfo.m
//  CityMobilDriver
//
//  Created by Intern on 10/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestSetDriverInfo.h"
#import "SingleDataProvider.h"
#import "UserInformationProvider.h"
@implementation RequestSetDriverInfo
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.key = [SingleDataProvider sharedKey].key;
        self.method = @"setDriverInfo";
        self.ipass = @"o3XOFR7xpv";
        self.version = @"1.0.2";
        self.ilog = @"cm-api";
        self.locale = @"ru";
        self.bankid = [UserInformationProvider sharedInformation].bankid;
        
        self.versions =[[NSMutableDictionary alloc]init];
        [self.versions setObject:@"19" forKey:@"versionCode"];
        [self.versions setObject:@"17" forKey:@"sdkVersion"];
        [self.versions setObject:@"2.9" forKey:@"versionName"];
    }
    return self;
}
@end
