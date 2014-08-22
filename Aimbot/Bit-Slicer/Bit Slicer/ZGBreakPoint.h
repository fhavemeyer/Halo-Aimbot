/*
 * Created by Mayur Pawashe on 12/29/12.
 *
 * Copyright (c) 2012 zgcoder
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

#import <Foundation/Foundation.h>
#import "Python.h"
#import "ZGMemoryTypes.h"
#import "ZGBreakPointDelegate.h"
#import "ZGThreadStates.h"

@class ZGVariable;
@class ZGProcess;

typedef enum
{
	ZGBreakPointWatchData,
	ZGBreakPointInstruction,
	ZGBreakPointSingleStepInstruction,
} ZGBreakPointType;

@interface ZGBreakPoint : NSObject

- (id)initWithProcess:(ZGProcess *)process type:(ZGBreakPointType)type  delegate:(id <ZGBreakPointDelegate>)delegate;

@property (atomic, weak) id <ZGBreakPointDelegate> delegate;
@property (readonly, nonatomic) ZGMemoryMap task;
@property (nonatomic) thread_act_t thread;
@property (nonatomic) ZGVariable *variable;
@property (nonatomic) ZGMemorySize watchSize;
@property (readonly, nonatomic) ZGProcess *process;
@property (atomic) NSArray *debugThreads;
@property (readonly, nonatomic) ZGBreakPointType type;
@property (atomic) BOOL needsToRestore;
@property (atomic) BOOL hidden;
@property (atomic) BOOL dead;
@property (atomic) ZGMemoryAddress basePointer;
@property (nonatomic) NSMutableDictionary *cacheDictionary;
@property (nonatomic) PyObject *condition;
@property (nonatomic) PyObject *callback;
@property (nonatomic) NSError *error;
@property (nonatomic) ZGMemoryProtection originalProtection;
@property (nonatomic) x86_thread_state_t generalPurposeThreadState;
@property (nonatomic) zg_x86_vector_state_t vectorState;
@property (nonatomic) BOOL hasVectorState;
@property (nonatomic) BOOL hasAVXSupport;

@end
