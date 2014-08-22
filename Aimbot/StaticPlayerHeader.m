//
//  StaticPlayerHeader.m
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/16/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import "StaticPlayerHeader.h"
#import "ZGProcess.h"
#import "ZGVirtualMemory.h"

@implementation StaticPlayerHeader
- (id) init
{
    self = [super init];
    if (self) {
        self.headerLocation = 0x402AAF90;
    }
    return self;
}

- (void) readInHeader:(ZGProcess *)activeProcess
{
    ZGMemorySize shortSize = 0x2;
    ZGMemorySize longSize = 0x4;
    
    if (activeProcess.valid) {
        void *value = NULL;
        
        
        if (ZGReadBytes(activeProcess.processTask, self.headerLocation + 0x20, &value, &shortSize)) {
            self.maxSlots = *(UInt16 *)value;
        }
        value = NULL;
        if (ZGReadBytes(activeProcess.processTask, self.headerLocation + 0x22, &value, &shortSize)) {
            self.slotSize = *(UInt16 *)value;
        }
        value = NULL;
        if (ZGReadBytes(activeProcess.processTask, self.headerLocation + 0x22, &value, &shortSize)) {
            self.slotSize = *(UInt16 *)value;
        }
        value = NULL;
        if (ZGReadBytes(activeProcess.processTask, self.headerLocation + 0x2E, &value, &shortSize)) {
            self.slotsTaken = *(UInt16 *)value;
        }
        value = NULL;
        if (ZGReadBytes(activeProcess.processTask, self.headerLocation + 0x34, &value, &longSize)) {
            self.firstPlayerLocation = *(UInt32 *)value;
        }
        value = NULL;
        if (ZGReadBytes(activeProcess.processTask, self.headerLocation + 0x2C, &value, &shortSize)) {
            self.inGame = *(UInt16 *)value;
        }
    }
}
- (BOOL)isInGame
{
    return (0 == self.inGame);
}
- (void)dumpInfo
{
    NSLog(@"Max Slots: %hu", self.maxSlots);
    NSLog(@"Slot Size: %hu", self.slotSize);
    NSLog(@"Slots taken: %hu", self.slotsTaken);
    NSLog(@"Offset to first player: %X", self.firstPlayerLocation);
    
}
@end
