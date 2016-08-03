//
//  XPHPSettingPanel.m
//  XPHP
//
//  Created by midoks on 16/7/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "XPHPSettingPanel.h"

#import "XPHPSetting.h"

@interface XPHPSettingPanel()

@property (weak) IBOutlet NSButton *isOpenDebug;
@property (nonatomic, weak) IBOutlet NSTextField *debugSite;

@end

@implementation XPHPSettingPanel

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.isOpenDebug.state = [[XPHPSetting defaultSetting] openDebug];

    [self.debugSite setStringValue:[[XPHPSetting defaultSetting] debugSite]];
}

- (IBAction)setOpenDebug:(id)sender
{
    [[XPHPSetting defaultSetting] setOpenDebug:self.isOpenDebug.state];
}

- (IBAction)debugSite:(id)sender
{
    NSLog(@"fff:%@", self.debugSite.stringValue);
    [[XPHPSetting defaultSetting] setDebugSite:self.debugSite.stringValue];
}




@end
