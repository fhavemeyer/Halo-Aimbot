//
//  StaticPlayerHeader.h
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/16/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGProcess.h"

@interface StaticPlayerHeader : NSObject

@property (nonatomic) UInt32 headerLocation;
@property (nonatomic) UInt16 maxSlots;
@property (nonatomic) UInt16 slotSize;
@property (nonatomic) UInt16 slotsTaken;
@property (nonatomic) UInt32 firstPlayerLocation;
@property (nonatomic) UInt16 inGame;

- (id)init;
- (void)readInHeader:(ZGProcess *)activeProcess;
- (BOOL)isInGame;
- (void)dumpInfo;
@end