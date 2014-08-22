//
//  DynamicPlayerData.h
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/16/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaticPlayerData.h"
#import "ZGProcess.h"

@interface DynamicPlayerData : NSObject

@property UInt32 objectAddress;
@property UInt16 objectSize;

@property Float32 playerHealth;
@property Float32 playerShield;
@property Float32 playerX;
@property Float32 playerY;
@property Float32 playerZ;
@property Float32 playerVelX;
@property Float32 playerVelY;
@property Float32 playerVelZ;
@property UInt16 vehicleIndex;
@property UInt16 vehicleID;
@property UInt16 crouchState;
@property NSString *name;

- (id)initWithStaticPlayerData:(StaticPlayerData *)staticPlayer process:(ZGProcess *)haloProcess;
- (void)readValues:(ZGProcess *)haloProcess;
- (bool)alive;

@end