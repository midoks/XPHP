//
//  XPHP.m
//  XPHP
//
//  Created by midoks on 16/7/26.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "XPHP.h"
#import "XPHPSettingPanel.h"
#import "XPHPSetting.h"

static XPHP *sharedPlugin;

@interface XPHP()


@property (nonatomic, strong) XPHPSettingPanel *settingPanel;

@property (nonatomic, assign) BOOL             xIsPHP;

@property (nonatomic, assign) BOOL             xStatus;
@property (nonatomic, assign) BOOL             xStatusKMD;
@property (nonatomic, assign) double           xBeginTime;


@end

@implementation XPHP

#pragma mark - Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSArray *allowedLoaders    = [[NSArray alloc]
                               initWithObjects:@"com.apple.dt.Xcode", nil];
    if ([allowedLoaders containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
    sharedPlugin               = [[self alloc] initWithBundle:plugin];
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)bundle
{
    if (self                   = [super init]) {
        _bundle                    = bundle;
        if (NSApp && !NSApp.mainMenu) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationDidFinishLaunching:)
                                                         name:NSApplicationDidFinishLaunchingNotification
                                                       object:nil];
        } else {
            [self initializeAndLog];
        }
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSApplicationDidFinishLaunchingNotification
                                                  object:nil];
    [self initializeAndLog];
}

- (void)initializeAndLog
{
    NSString *name             = [self.bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *version          = [self.bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *status           = [self initialize] ? @"loaded successfully" : @"failed to load";
    NSLog(@"Plugin %@ %@ %@", name, version, status);
}

#pragma mark - Implementation
- (BOOL)initialize
{
    self.xIsPHP  = FALSE;
    self.xStatus = FALSE;
    
    [self initListenFile];
    [self initLoadWebSite];
    
    return [self addSettingMenu];
}

- (BOOL)addSettingMenu
{
    NSMenuItem *menuItem       = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"XPHP" action:@selector(showSettingPanel) keyEquivalent:@"P"];
        [actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
        return YES;
    } else {
        return NO;
    }
    
}

// Sample Action, for menu item:
- (void)showSettingPanel
{
    self.settingPanel          = [[XPHPSettingPanel alloc] initWithWindowNibName:@"XPHPSettingPanel"];
    [self.settingPanel showWindow:self.settingPanel];
}


- (void)initListenFile
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initLoadStatus:)
                                                 name:@"IDEEditorDocumentDidChangeNotification"
                                               object:nil];
}

-(void) initLoadStatus:(NSNotification *)notify
{
    if ([[notify object] isKindOfClass:[NSDocument class]]){
        
        NSDocument *document = (NSDocument *)[notify object];
        NSString *urlString = [[document fileURL] absoluteString];
        
        if([urlString hasSuffix:@".php"]){
            self.xIsPHP = TRUE;
        } else {
            self.xIsPHP = FALSE;
        }
    }
}

- (void)initLoadWebSite
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initloadWebUrl:)
                                                 name:@"__kMDQueryWillChangeNotification"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initloadWebUrl:)
                                                 name:@"IDELaunchSessionWillChangeStateNotification"
                                               object:nil];
}

#pragma mark - Load Web Site -
-(void) initloadWebUrl:(NSNotification *)notify
{
    NSString *notifyName = notify.name;
    
    if ([notifyName isEqualToString:@"__kMDQueryWillChangeNotification"])
    {
        self.xStatus    = TRUE;
        self.xStatusKMD = TRUE;
    }

    if(self.xStatusKMD)
    {
        if ([notifyName isEqualToString:@"IDELaunchSessionWillChangeStateNotification"])
        {
            [self loadWebSite];
            self.xStatusKMD = FALSE;
        }
    } else if (self.xStatus &&
        [notifyName isEqualToString:@"IDELaunchSessionWillChangeStateNotification"])
    {

        if (self.xBeginTime < 1)
        {
            self.xBeginTime = [[NSDate date] timeIntervalSince1970];
        }
        else if (self.xBeginTime > 1)
        {
            NSTimeInterval xEndTime = [[NSDate date] timeIntervalSince1970];
            float s                 = xEndTime - self.xBeginTime;
            if ( s > 0){
                [self loadWebSite];
            }
            self.xBeginTime            = 0.0;
        }
    }
}

-(void)loadWebSite
{
    NSInteger isOpenDebug = [[XPHPSetting defaultSetting] openDebug];
    if (self.xIsPHP && isOpenDebug>0){
        
        NSString *webSite = [[XPHPSetting defaultSetting] debugSite];
        webSite = [NSString stringWithFormat:@"http://%@", webSite];
        
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:webSite]];
    }
}

@end
