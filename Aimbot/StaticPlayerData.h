//
//  StaticPlayerData.h
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/16/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGProcess.h"
#import "ZGVirtualMemory.h"

@interface StaticPlayerData : NSObject

@property NSString *playerName;
@property UInt32 address;
@property UInt16 objectIndexNum;
@property UInt16 objectID;

@property Float32 playerX;
@property Float32 playerY;
@property Float32 playerZ;

- (id)initWithPlayerIndex:(UInt32)playerIndex structPointer:(UInt32)pointer structSize:(UInt32)structSize;
- (void)update:(ZGProcess *)haloProcess;
- (bool)validPlayer;
- (void)dumpInfo;

@end
