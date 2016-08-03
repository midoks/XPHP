//
//  XPHPSetting.m
//  XPHP
//
//  Created by midoks on 16/8/2.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "XPHPSetting.h"

NSString *const xps_OpenDebugK = @"com.xphp.opendebug";
NSString *const xps_DebugSiteK = @"com.xphp.debugsite";

@implementation XPHPSetting

+ (XPHPSetting *)defaultSetting
{
    static dispatch_once_t once;
    static XPHPSetting * defaultSetting;
    
    dispatch_once(&once, ^{
        defaultSetting = [[XPHPSetting alloc] init];
        
        NSDictionary *defaults = @{xps_OpenDebugK:@1,xps_DebugSiteK:@"localhost"};
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    });
    return defaultSetting;
}

-(NSInteger)openDebug
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:xps_OpenDebugK];
}


-(void)setOpenDebug:(NSInteger)val
{
    [[NSUserDefaults standardUserDefaults] setInteger:val forKey:xps_OpenDebugK];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)debugSite
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:xps_DebugSiteK];
}

-(void)setDebugSite:(NSString *)val
{
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:xps_DebugSiteK];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




@end
