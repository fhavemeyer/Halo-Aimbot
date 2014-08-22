//
//  StaticPlayerManager.m
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/16/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import "StaticPlayerManager.h"

@implementation StaticPlayerManager
- (id)init
{
    self = [super init];
    if (self) {
        self.playerHeader = [[StaticPlayerHeader alloc] init];
        self.staticPlayers = [NSMutableArray array];
    }
    return self;
}

- (void)update:(ZGProcess *)haloProcess
{
    if (haloProcess.valid) {
        [self.playerHeader readInHeader:haloProcess];
        
        // Only do this part if I'm in a game
        if ([self.playerHeader isInGame]) {
            if ([self.staticPlayers count] < self.playerHeader.maxSlots) {
                [self.staticPlayers removeAllObjects];
            
                for (int i = 0; i < self.playerHeader.maxSlots; i++) {
                    [self.staticPlayers addObject:[[StaticPlayerData alloc]
                                                   initWithPlayerIndex:i
                                                   structPointer:self.playerHeader.firstPlayerLocation
                                                   structSize:self.playerHeader.slotSize]];
                }
            }
            
            [self.staticPlayers makeObjectsPerformSelector:@selector(update:) withObject:haloProcess];
        }
    }
}
- (BOOL)canRunBot
{
    return [self.playerHeader isInGame];
}
- (StaticPlayerData *)findMe
{
    NSUInteger index = [self.staticPlayers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([((StaticPlayerData*)obj).playerName compare:@"sword" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 5)] == NSOrderedSame) {
            return true;
        }
        return false;
    }];
    
    if (index != -1 && index < self.playerHeader.maxSlots) {
        return [self.staticPlayers objectAtIndex:index];
    }
    return nil;
}
@end
