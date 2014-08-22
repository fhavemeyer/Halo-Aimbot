//
//  StaticPlayerManager.h
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/16/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaticPlayerHeader.h"
#import "StaticPlayerData.h"
#import "ZGProcess.h"
#import "ZGVirtualMemory.h"

@interface StaticPlayerManager : NSObject

@property (nonatomic) StaticPlayerHeader *playerHeader;
@property (nonatomic) NSMutableArray *staticPlayers;
@property (nonatomic) UInt32 maxSlots;

- (id)init;
- (void)update:(ZGProcess *)haloProcess;
- (BOOL)canRunBot;
- (StaticPlayerData *)findMe;

@end
