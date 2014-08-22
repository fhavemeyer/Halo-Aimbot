//
//  HaloStructures.h
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/16/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#ifndef Aimbot_HaloStructures_h
#define Aimbot_HaloStructures_h

typedef struct
{
    unsigned char TName[32]; // 'players'
    unsigned short MaxSlots; // Max number of slots/players possible
    unsigned short SlotSize; // Size of each Static_Player struct
    unsigned long Unknown; // always 1?
    unsigned char Data[4]; // '@t@d' - translated as 'data'?
    unsigned short IsInMainMenu; // 0 = in game 1 = in main menu / not in game
    unsigned short SlotsTaken; // or # of players
    unsigned short NextPlayerIndex; // Index # of the next player to join
    unsigned short NextPlayerID; // ID # of the next player to join
    unsigned long FirstPlayer; // Pointer to the first static player
} StaticPlayerHeader;

#endif
