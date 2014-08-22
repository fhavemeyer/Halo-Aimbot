//
//  AppDelegate.m
//  Aimbot
//
//  Created by Frederick Havemeyer on 10/15/13.
//  Copyright (c) 2013 sword. All rights reserved.
//

#import "AppDelegate.h"
#import "ZGProcess.h"
#import "ZGProcessList.h"
#import "ZGRunningProcess.h"
#import "ZGVirtualMemory.h"

#import "StaticPlayerHeader.h"
#import "DynamicPlayerData.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    AppDelegate * __weak weakSelf = self;
    [[ZGProcessList sharedProcessList]
     addObserver:self
     forKeyPath:@"runningProcesses"
     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
     context:NULL];
    
    self.playerManager = [[StaticPlayerManager alloc] init];
    self.selectionManager = [[PlayerSelectionManager alloc] init];
    
    __block BOOL isDown = false;
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSFlagsChangedMask handler:^(NSEvent *event){
        if ([event modifierFlags] & NSShiftKeyMask) {
            isDown = !isDown;
            if (isDown) {
                [weakSelf disconnectMouse];
            }
        }
        if (isDown && [event modifierFlags] == 256) {
            isDown = !isDown;
            if (!isDown) {
                [weakSelf connectMouse];
            }
        }
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
        if ([[event charactersIgnoringModifiers] compare:@"+"] == 0) {
            NSLog(@"HAI");
            [weakSelf increaseDeltaT];
        } else if ([[event charactersIgnoringModifiers] compare:@"_"] == 0) {
            [weakSelf decreaseDeltaT];
        }
    }];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"activationPolicy" ascending:YES];
	for (ZGRunningProcess *runningProcess in [[[ZGProcessList sharedProcessList] runningProcesses] sortedArrayUsingDescriptors:@[sortDescriptor]])
	{
		if ([[runningProcess name] isEqual:@"Halo"]) {
            [self haloIsLive:runningProcess];
        }
	}
    
    if (!self.haloProcess.valid) {
        NSLog(@"Halo not yet running!");
        self.haloProcess = [[ZGProcess alloc] initWithName:@"Halo" internalName:@"Halo" is64Bit:YES];
        [[ZGProcessList sharedProcessList] requestPollingWithObserver:self];
    }
    
    
}

- (void)haloIsLive:(ZGRunningProcess *)process
{
    self.haloProcess = [[ZGProcess alloc]
                        initWithName:process.name
                        internalName:process.name
                        processID:process.processIdentifier
                        is64Bit:process.is64Bit];
    if (self.haloProcess && self.haloProcess.valid) {
        
        [[ZGProcessList sharedProcessList] addPriorityToProcessIdentifier:self.haloProcess.processID withObserver:self];
        
        
        if (!self.haloProcess.hasGrantedAccess && ![self.haloProcess hasGrantedAccess]) {
            NSLog(@"Failed accessing Halo");
        }
    
        [[ZGProcessList sharedProcessList] unrequestPollingWithObserver:self];
        NSLog(@"halo is on!");
        self.botTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(gatherData:) userInfo:nil repeats:YES];
    }
}

- (void)haloIsDead
{
    [self.haloProcess markInvalid];
    
    [[ZGProcessList sharedProcessList] removePriorityToProcessIdentifier:self.haloProcess.processID
                                                            withObserver:self];
    [[ZGProcessList sharedProcessList] requestPollingWithObserver:self];
    
    NSLog(@"Halo stopped running! Waiting for it to come back!");
    
    [self.botTimer invalidate];
    self.botTimer = nil;
}

- (void)disconnectMouse
{
    char nops[] = {0x90, 0x90, 0x90, 0x90, 0x90};
    
    // Azimuthal
    ZGWriteBytesIgnoringProtection(self.haloProcess.processTask, 0x107742, &nops, (ZGMemorySize)5);
    ZGWriteBytesIgnoringProtection(self.haloProcess.processTask, 0x107553, &nops, (ZGMemorySize)5);

    
    // Altitude
    ZGWriteBytesIgnoringProtection(self.haloProcess.processTask, 0x107A6E, &nops, (ZGMemorySize)5);
    ZGWriteBytesIgnoringProtection(self.haloProcess.processTask, 0x107A86, &nops, (ZGMemorySize)5);
    
    self.botOn = true;

    NSLog(@"Mouse disconnected");
}

- (void)connectMouse
{
    // Azimuthal
    char azimuthalInstructions1[] = {0xF3, 0x0F, 0x11, 0x4F, 0x0C};
    ZGWriteBytesIgnoringProtection(self.haloProcess.processTask, 0x107742, &azimuthalInstructions1, (ZGMemorySize)5);
    char azimuthalInstructions2[] = {0xF3, 0x0F, 0x11, 0x47, 0x0C};
    ZGWriteBytesIgnoringProtection(self.haloProcess.processTask, 0x107553, &azimuthalInstructions2, (ZGMemorySize)5);
    
    // Altitude
    char altitudeInstructions1[] = {0xF3, 0x0F, 0x11, 0x4F, 0x10};
    ZGWriteBytesIgnoringProtection(self.haloProcess.processTask, 0x107A6E, &altitudeInstructions1, (ZGMemorySize)5);
    char altitudeInstructions2[] = {0xF3, 0x0F, 0x11, 0x47, 0x10};
    ZGWriteBytesIgnoringProtection(self.haloProcess.processTask, 0x107A86, &altitudeInstructions2, (ZGMemorySize)5);
    
    self.botOn = false;
    [self.selectionManager unselectPlayer];
    
    NSLog(@"Mouse reconnected");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == [ZGProcessList sharedProcessList]) {
		NSArray *newRunningProcesses = [change objectForKey:NSKeyValueChangeNewKey];
		NSArray *oldRunningProcesses = [change objectForKey:NSKeyValueChangeOldKey];
		
		if (newRunningProcesses)
		{
			for (ZGRunningProcess *runningProcess in newRunningProcesses)
			{
				if ([self.haloProcess.name isEqualToString:runningProcess.name]) {
                    [self haloIsLive:runningProcess];
                }
			}
		}
		
		if (oldRunningProcesses)
		{
			for (ZGRunningProcess *runningProcess in oldRunningProcesses)
			{
				if ([self.haloProcess.name isEqualToString:runningProcess.name]) {
                    [self haloIsDead];
                }
			}
		}
    }
}

// ok... now what?
- (void)gatherData:(NSTimer *)timer
{
    float mouseCoords[2] = {0.0f, 0.0f};
    void *value;
    ZGMemorySize longSize = 0x4;
    
    if (self.botOn) {
        [self.playerManager update:self.haloProcess];
        
        
        if (ZGReadBytes(self.haloProcess.processTask, 0x402AD4B4, &value, &longSize)) {
            mouseCoords[0] = *(float *)value;
        }
        if (ZGReadBytes(self.haloProcess.processTask, 0x402AD4B8, &value, &longSize)) {
            mouseCoords[1] = *(float *)value;
        }
        
        if ([self.playerManager canRunBot]) {
            if (!self.selectionManager.searching) {
                if ([self.selectionManager playerSelected]) {
                    // update aim
                    [self.selectionManager lookAtSelected:[self.playerManager findMe] haloProcess:self.haloProcess];
                    
                } else {
                    // update player list
                    [self.selectionManager selectClosestPlayer:self.playerManager process:self.haloProcess mouseCoords:(float *)&mouseCoords];
                }
            } else {
                NSLog(@"Searching");
            }
        }
    }
}

- (void)increaseDeltaT
{
    self.selectionManager.deltaT += 0.5;
    NSLog(@"deltaT: [%f]", self.selectionManager.deltaT);
}
- (void)decreaseDeltaT
{
    if (self.selectionManager.deltaT > 0.5) {
        self.selectionManager.deltaT -= 0.5;
    }
}
@end
