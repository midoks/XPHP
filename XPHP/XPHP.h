//
//  XPHP.h
//  XPHP
//
//  Created by midoks on 16/7/26.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface XPHP : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end