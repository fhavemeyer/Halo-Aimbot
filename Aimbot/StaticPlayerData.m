//
//  StaticPlayerData.m
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/16/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import "StaticPlayerData.h"

@implementation StaticPlayerData
- (id)initWithPlayerIndex:(UInt32)playerIndex structPointer:(UInt32)pointer structSize:(UInt32)structSize {
    self = [super init];
    if (self) {
        self.address = pointer + structSize * playerIndex;
    }
    return self;
}
- (void)update:(ZGProcess *)haloProcess
{
    void *value = NULL;
    ZGMemorySize shortSize = 0x2;
    ZGMemorySize longSize = 0x4;
    ZGMemorySize nameSize = 0x18;
    if (haloProcess.valid) {
        if (ZGReadBytes(haloProcess.processTask, self.address + 0x34, &value, &shortSize)) {
            self.objectIndexNum = *(UInt16*)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.address + 0x36, &value, &shortSize)) {
            self.objectID = *(UInt16*)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.address + 0xF8, &value, &longSize)) {
            self.playerX = *(Float32*)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.address + 0xFC, &value, &longSize)) {
            self.playerY = *(Float32*)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.address + 0x100, &value, &longSize)) {
            self.playerZ = *(Float32*)value;
        }
        value = NULL;
        if (ZGReadBytes(haloProcess.processTask, self.address + 0x4, &value, &nameSize)) {
            self.playerName = [[NSString alloc] initWithBytes:value length:24 encoding:NSUTF16LittleEndianStringEncoding];
        }
    }
}
- (bool)validPlayer
{
    return (self.objectID != 0x0 && self.objectID != 0xFFFF);
}
- (void)dumpInfo
{
    NSLog(@"Object Number: %hu", self.objectIndexNum);
    NSLog(@"Object ID: %hu", self.objectID);
    NSLog(@"Object Coordinates: <%f,%f,%f>", self.playerX, self.playerY, self.playerZ);
}
@end
