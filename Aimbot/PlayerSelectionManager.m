//
//  PlayerSelectionManager.m
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/21/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import "PlayerSelectionManager.h"
#import <math.h>
#import "ZGProcess.h"
#import "ZGVirtualMemory.h"

#define MAX_MOUSE_DISPLACEMENT 7.024814731040729f
#define HEAD_HEIGHT -0.04
#define CROUCH_MODIFIER 0.33

@implementation PlayerSelectionManager

- (id)init
{
    self = [super init];
    if (self) {
        self.deltaT = 2.0f;
    }
    return self;
}

// Find the player who's displacement between the view vector and his 2d coordinates is smallest
- (void)selectClosestPlayer:(StaticPlayerManager *)playerList process:(ZGProcess *)haloProcess mouseCoords:(float *)mouseCoords
{
    StaticPlayerData *me = [playerList findMe];
    DynamicPlayerData *myData = [[DynamicPlayerData alloc] initWithStaticPlayerData:me process:haloProcess];
    DynamicPlayerData *dynamicPlayer = nil;
    self.searching = true;
    
    float spherCoords[2] = {0.0f, 0.0f};
    
    // Vector Displacement
    float displacement[3] = {0.0f, 0.0f, 0.0f};
    
    // Mouse displacement magnitude initialized to the maximum it could be
    float mouseDisplacementMag = MAX_MOUSE_DISPLACEMENT;
    float mouseComparisonMagnitude = 0.0f;
    float adjustedMouseDisplacementMag = 0.0f;
    
    // Make sure we're not looking for anyone yet
    self.selectedPlayer = nil;
    
    for (StaticPlayerData *player in playerList.staticPlayers) {
        if ([player validPlayer] && player != me && player.playerName != NULL) {
            dynamicPlayer = [[DynamicPlayerData alloc] initWithStaticPlayerData:player process:haloProcess];
            NSLog(player.playerName);
            NSLog(@"vehicleID: %x", dynamicPlayer.vehicleID);
            NSLog(@"vehicleIndex: %x", dynamicPlayer.vehicleIndex);

            if ([dynamicPlayer alive]) {
                [self playerDisplacement:me dynPlayer:dynamicPlayer displacement:(float *)&displacement];
                
                // Let's find the theta and phi
                if (displacement[0] != 0.0f && displacement[1] != 0.0f) {
                    [self lookLocation:(float*)&spherCoords me:myData otherPlayer:dynamicPlayer];
                    
                    mouseComparisonMagnitude = sqrt(pow(mouseCoords[0] - spherCoords[0], 2) + pow(mouseCoords[1] - spherCoords[1], 2));
                    adjustedMouseDisplacementMag = sqrt(pow(spherCoords[0] - 2*M_PI - mouseCoords[0], 2) + pow(mouseCoords[1] - spherCoords[1], 2));
                    
                    // If it's an edge case, make sure we're comparing against the adjusted values
                    if (adjustedMouseDisplacementMag < mouseComparisonMagnitude) {
                        mouseComparisonMagnitude = adjustedMouseDisplacementMag;
                    }
                    
                    if (mouseComparisonMagnitude < mouseDisplacementMag) {
                        mouseDisplacementMag = mouseComparisonMagnitude;
                        if (mouseDisplacementMag < M_PI_4) {
                            self.selectedPlayer = dynamicPlayer;
                            self.selectedPlayer.name = player.playerName;
                        }
                    }
                } else {
                    // Found the closest player lol
                    self.selectedPlayer = [[DynamicPlayerData alloc] initWithStaticPlayerData:player process:haloProcess];
                    self.searching = false;
                    return;
                }
            }
        }
    }
    self.searching = false;
}

// Unfortunately, since I did a bad job coding this, I seem to have to do shit semi-arbitrarily
- (void)lookLocation:(float *)newMouseCoords me:(DynamicPlayerData *)me otherPlayer:(DynamicPlayerData *)otherPlayer
{
    float theta = 0.0f;
    float phi = 0.0f;
    float mag = 0.0f;
    float playerCoords[3];
    
    float lagAdjustment = self.deltaT;
    
    playerCoords[0] = otherPlayer.playerX - me.playerX;
    playerCoords[1] = otherPlayer.playerY - me.playerY;
    playerCoords[2] = otherPlayer.playerZ - me.playerZ;
    
    mag = [self vec3Magnitude:(float *)&playerCoords];
    
    if (mag < 25) {
        lagAdjustment = (mag/25)*lagAdjustment;
    }
    
    playerCoords[0] = playerCoords[0] + otherPlayer.playerVelX * lagAdjustment;
    playerCoords[1] = playerCoords[1] + otherPlayer.playerVelY * lagAdjustment;
    playerCoords[2] = playerCoords[2] + otherPlayer.playerVelZ * lagAdjustment * 0.5;
    
    theta = [self adjustedInverseTan:playerCoords[1] x:playerCoords[0]];
    
    if ([otherPlayer crouchState] == 1) {
        playerCoords[2] = playerCoords[2] + HEAD_HEIGHT * CROUCH_MODIFIER;
    } else {
        playerCoords[2] = playerCoords[2] + HEAD_HEIGHT;
    }
    
    mag = [self vec3Magnitude:(float*)&playerCoords];
    
    phi = [self adjustedInverseCos:playerCoords[2] mag:mag];
    
    newMouseCoords[0] = theta;
    newMouseCoords[1] = phi;
}

- (void)lookAtSelected:(StaticPlayerData *)me haloProcess:(ZGProcess *)haloProc
{
    float mouseCoords[2] = {0.0f, 0.0f};
    [self.selectedPlayer readValues:haloProc];
    DynamicPlayerData *myData = [[DynamicPlayerData alloc] initWithStaticPlayerData:me process:haloProc];
    [self lookLocation:(float*)&mouseCoords me:myData otherPlayer:self.selectedPlayer];
    
    ZGWriteBytesIgnoringProtection(haloProc.processTask, 0x402AD4B4, &mouseCoords[0], 0x4);
    ZGWriteBytesIgnoringProtection(haloProc.processTask, 0x402AD4B8, &mouseCoords[1], 0x4);
}

- (void)unselectPlayer
{
    self.selectedPlayer = nil;
}

- (bool)playerSelected
{
    if (self.selectedPlayer && [self.selectedPlayer alive]) {
        return true;
    }
    
    self.selectedPlayer = nil;
    return false;
}

// definitly faster ways of doing it than this
- (void)playerDisplacement:(StaticPlayerData *)me dynPlayer:(DynamicPlayerData *)dynamicPlayer displacement:(float *)displacementVector
{
    displacementVector[0] = dynamicPlayer.playerX - me.playerX;
    displacementVector[1] = dynamicPlayer.playerY - me.playerY;
    displacementVector[2] = dynamicPlayer.playerZ - me.playerZ;
    
    // If it's crouching do this shit
    if ([dynamicPlayer crouchState] == 1) {
        displacementVector[2] = displacementVector[2] * CROUCH_MODIFIER;
    }
}

- (float)vec3Magnitude:(float*)vec
{
    return sqrtf(powf(vec[0], 2) + powf(vec[1], 2) + powf(vec[2], 2));
}

// maps atan2f from [-pi,pi] to [0,2pi)
- (float)adjustedInverseTan:(float)y x:(float)x
{
    float val = 0.0f;
    val = atan2f(y, x);
    if (val < 0) {
        val += 2*M_PI;
    }
    if (val >= 2*M_PI) {
        val -= 2*M_PI;
    }
    return val;
}
// maps acof from [-1,1] to [-pi,pi]
- (float)adjustedInverseCos:(float)z mag:(float)mag
{
    float val = 0.0f;
    val = acosf(z/mag);
    return M_PI_2 - val;
}
@end
