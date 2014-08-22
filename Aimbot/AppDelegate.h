//
//  AppDelegate.h
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/15/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZGProcess.h"

#import "StaticPlayerManager.h"
#import "PlayerSelectionManager.h"
#import "ZGRunningProcess.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) ZGProcess *haloProcess;
@property (nonatomic) bool botOn;
@property (strong, nonatomic) NSTimer *botTimer;
@property (strong, nonatomic) StaticPlayerManager *playerManager;
@property (strong, nonatomic) PlayerSelectionManager *selectionManager;
@property (atomic) bool searching;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)haloIsLive:(ZGRunningProcess *)process;
- (void)haloIsDead;
- (void)disconnectMouse;
- (void)connectMouse;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
- (void)gatherData:(NSTimer *)timer;
- (void)increaseDeltaT;
- (void)decreaseDeltaT;

@end
