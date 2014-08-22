/*
 * Created by Mayur Pawashe on 3/9/14.
 *
 * Copyright (c) 2014 zgcoder
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ZGAppUpdaterController.h"

#import <Sparkle/Sparkle.h>

#define ZG_CHECK_FOR_UPDATES @"SUEnableAutomaticChecks"
#define ZG_CHECK_FOR_ALPHA_UPDATES @"ZG_CHECK_FOR_ALPHA_UPDATES_2"

#define SU_FEED_URL_KEY @"SUFeedURL"
#define SU_SEND_PROFILE_INFO_KEY @"SUSendProfileInfo"

#define APPCAST_URL @"http://zorg.tejat.net/bitslicer/update.php"
#define ALPHA_APPCAST_URL @"http://zorg.tejat.net/bitslicer/update_alpha.php"

@interface ZGAppUpdaterController ()

@property (nonatomic) SUUpdater *updater;

@end

@implementation ZGAppUpdaterController

+ (BOOL)runningAlpha
{
	return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] rangeOfString:@"a"].location != NSNotFound;
}

+ (void)initialize
{
	[NSUserDefaults.standardUserDefaults
	 registerDefaults:
	 @{
	   // If user is running an alpha version, we should set this to YES
	   ZG_CHECK_FOR_ALPHA_UPDATES : @([self runningAlpha]),
	   SU_FEED_URL_KEY : ([self runningAlpha] ? ALPHA_APPCAST_URL : APPCAST_URL),
	   }];
}

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		[self reloadValuesFromDefaults];
		
		self.updater = [[SUUpdater alloc] init];
		[self updateFeedURL];
	}
	return self;
}

- (void)reloadValuesFromDefaults
{
	_checksForUpdates = [[NSUserDefaults standardUserDefaults] boolForKey:ZG_CHECK_FOR_UPDATES];
	_checksForAlphaUpdates = [[NSUserDefaults standardUserDefaults] boolForKey:ZG_CHECK_FOR_ALPHA_UPDATES];
	_sendsAnonymousInfo = [[NSUserDefaults standardUserDefaults] boolForKey:SU_SEND_PROFILE_INFO_KEY];
}

- (void)updateFeedURL
{
	[self.updater setFeedURL:[NSURL URLWithString:self.checksForAlphaUpdates ? ALPHA_APPCAST_URL : APPCAST_URL]];
}

- (void)setChecksForUpdates:(BOOL)checksForUpdates
{
	_checksForUpdates = checksForUpdates;
	
	[self updateFeedURL];
	
	[[NSUserDefaults standardUserDefaults] setBool:_checksForUpdates forKey:ZG_CHECK_FOR_UPDATES];
}

- (void)setChecksForAlphaUpdates:(BOOL)checksForAlphaUpdates
{
	_checksForAlphaUpdates = checksForAlphaUpdates;
	
	[self updateFeedURL];
	
	[[NSUserDefaults standardUserDefaults] setBool:_checksForAlphaUpdates forKey:ZG_CHECK_FOR_ALPHA_UPDATES];
}

- (void)setSendsAnonymousInfo:(BOOL)sendsAnonymousInfo
{
	_sendsAnonymousInfo = sendsAnonymousInfo;
	
	[[NSUserDefaults standardUserDefaults] setBool:_sendsAnonymousInfo forKey:SU_SEND_PROFILE_INFO_KEY];
}

- (void)checkForUpdates
{
	[self.updater checkForUpdates:nil];
}

@end
