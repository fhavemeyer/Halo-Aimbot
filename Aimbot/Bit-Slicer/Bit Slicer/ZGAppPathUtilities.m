/*
 * Created by Mayur Pawashe on 3/10/14.
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

#import "ZGAppPathUtilities.h"

@implementation ZGAppPathUtilities

+ (NSString *)ourApplicationSupportPath
{
	NSString *applicationSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
	return [applicationSupportPath stringByAppendingPathComponent:@"Bit Slicer"];
}

+ (NSString *)createApplicationSupportPath
{
	NSString *ourApplicationSupportPath = [self ourApplicationSupportPath];
	if (ourApplicationSupportPath == nil)
	{
		return nil;
	}
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	if (![fileManager fileExistsAtPath:ourApplicationSupportPath] && ![fileManager createDirectoryAtPath:ourApplicationSupportPath withIntermediateDirectories:NO attributes:nil error:NULL])
	{
		return nil;
	}
	
	return ourApplicationSupportPath;
}

+ (NSString *)createEmptyPythonFile
{
	NSString *applicationSupportPath = [self createApplicationSupportPath];
	if (applicationSupportPath == nil)
	{
		return nil;
	}
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if (![fileManager fileExistsAtPath:applicationSupportPath])
	{
		return nil;
	}
	
	NSString *emptyPythonFilePath = [applicationSupportPath stringByAppendingPathComponent:[@"temporary_script" stringByAppendingPathExtension:@"py"]];
	
	if ([fileManager fileExistsAtPath:emptyPythonFilePath])
	{
		return emptyPythonFilePath;
	}
	
	FILE *file = fopen([emptyPythonFilePath UTF8String], "w");
	
	if (file == NULL)
	{
		return nil;
	}
	
	fclose(file);
	
	return emptyPythonFilePath;
}

+ (NSString *)lastErrorLogPath
{
	NSString *ourApplicationSupportPath = [self createApplicationSupportPath];
	if (ourApplicationSupportPath == nil)
	{
		return nil;
	}
	
	return [ourApplicationSupportPath stringByAppendingPathComponent:@"last script error.txt"];
}

+ (NSString *)createUserModulesDirectory
{
	NSString *ourApplicationSupportPath = [self createApplicationSupportPath];
	if (ourApplicationSupportPath == nil)
	{
		return nil;
	}
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	NSString *modulesPath = [ourApplicationSupportPath stringByAppendingPathComponent:@"Modules"];
	if (![fileManager fileExistsAtPath:modulesPath] && ![fileManager createDirectoryAtPath:modulesPath withIntermediateDirectories:NO attributes:nil error:NULL])
	{
		return nil;
	}
	
	return modulesPath;
}

@end
