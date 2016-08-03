//
//  XPHPSetting.h
//  XPHP
//
//  Created by midoks on 16/8/2.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPHPSetting : NSObject

+ (XPHPSetting *)defaultSetting;

-(NSInteger)openDebug;
-(void)setOpenDebug:(NSInteger)val;

-(NSString *)debugSite;
-(void)setDebugSite:(NSString *)val;

@end
