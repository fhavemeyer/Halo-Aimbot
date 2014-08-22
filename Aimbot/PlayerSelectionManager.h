//
//  PlayerSelectionManager.h
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/21/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaticPlayerManager.h"
#import "StaticPlayerData.h"
#import "DynamicPlayerData.h"

@interface PlayerSelectionManager : NSObject

@property DynamicPlayerData *selectedPlayer;
@property (atomic) bool searching;
@property (nonatomic) float deltaT;

- (void)selectClosestPlayer:(StaticPlayerManager *)playerList process:(ZGProcess *)haloProcess mouseCoords:(float *)mouseCoords;
- (void)unselectPlayer;
- (bool)playerSelected;
- (void)lookLocation:(float *)newMouseCoords me:(DynamicPlayerData *)me otherPlayer:(DynamicPlayerData *)otherPlayer;
- (void)lookAtSelected:(StaticPlayerData *)me haloProcess:(ZGProcess *)haloProc;
- (void)playerDisplacement:(StaticPlayerData *)me dynPlayer:(DynamicPlayerData *)dynamicPlayer displacement:(float *)displacementVector;
- (float)vec3Magnitude:(float*)vec;
- (float)adjustedInverseTan:(float)y x:(float)x;
- (float)adjustedInverseCos:(float)z mag:(float)mag;
@end
