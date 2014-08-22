//
//  DynamicPlayerData.m
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/16/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import "DynamicPlayerData.h"

@implementation DynamicPlayerData
- (id)initWithStaticPlayerData:(StaticPlayerData *)staticPlayer process:(ZGProcess *)haloProcess
{
    self = [super init];
    
    UInt32 dynamicObjectTableStart = 0x400506E8;
    UInt16 *objectIDForSanity;
    
    ZGMemorySize shortSize = 0x2;
    ZGMemorySize longSize = 0x4;
    
    if (self && haloProcess.valid) {
        if (staticPlayer.objectID != 0 && staticPlayer.objectID != 0xFFFF) {
            void *value = NULL;
            UInt32 objectRefLocation = dynamicObjectTableStart + staticPlayer.objectIndexNum * 0xC;
            if (ZGReadBytes(haloProcess.processTask, objectRefLocation, &value, &shortSize)) {
                objectIDForSanity = value;
                // Sanity check shit
                if (*objectIDForSanity != staticPlayer.objectID) {
                    return nil;
                }
            }
            value = NULL;
            if (ZGReadBytes(haloProcess.processTask, objectRefLocation + 0x6, &value, &shortSize)) {
                self.objectSize = *(UInt16 *)value;
            }
            value = NULL;
            if (ZGReadBytes(haloProcess.processTask, objectRefLocation + 0x8, &value, &longSize)) {
                self.objectAddress = *(UInt32 *)value;
            }
            
            [self readValues:haloProcess];
        } else {
            return nil;
        }
    }
    
    return self;
}

- (void)readValues:(ZGProcess *)haloProcess
{
    ZGMemorySize shortSize = 0x2;
    ZGMemorySize longSize = 0x4;
    void *value;
    
    if (haloProcess.valid) {
        // Now comes the pretty part of reading the dynamic shit
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0x5C, &value, &longSize)) {
            self.playerX = *(Float32 *)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0x60, &value, &longSize)) {
            self.playerY = *(Float32 *)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0x64, &value, &longSize)) {
            self.playerZ = *(Float32 *)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0x68, &value, &longSize)) {
            self.playerVelX = *(Float32 *)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0x6C, &value, &longSize)) {
            self.playerVelY = *(Float32 *)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0x70, &value, &longSize)) {
            self.playerVelZ = *(Float32 *)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0xE0, &value, &longSize)) {
            self.playerHealth = *(Float32 *)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0xE4, &value, &longSize)) {
            self.playerShield = *(Float32 *)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0x208, &value, &shortSize)) {
            self.crouchState = *(UInt16 *)value;
        }
        
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0x11C, &value, &shortSize)) {
            self.vehicleIndex = *(UInt16 *)value;
        }
        
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.objectAddress + 0x11E, &value, &shortSize)) {
            self.vehicleID = *(UInt16 *)value;
        }
    }
}

- (bool)alive
{
    return (self.playerHealth > 0.00000f && self.vehicleID == 0xFFFF && self.vehicleIndex == 0xFFFF);
}

@end
