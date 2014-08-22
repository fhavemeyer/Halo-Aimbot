/*
 * Created by Mayur Pawashe on 10/25/09.
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

#ifndef _ZG_VIRTUAL_MEMORY_H
#define _ZG_VIRTUAL_MEMORY_H

#ifdef __cplusplus
extern "C" {
#endif

#include "ZGMemoryTypes.h"
#include <mach/vm_region.h>
#include <stdbool.h>

// Caller for ZGTaskForPID is responsible for using ZGDeallocatePort
bool ZGTaskForPID(int processID, ZGMemoryMap *processTask);
bool ZGDeallocatePort(ZGMemoryMap processTask);

bool ZGPIDForTask(ZGMemoryMap processTask, int *processID);

bool ZGPageSize(ZGMemoryMap processTask, ZGMemorySize *pageSize);

bool ZGAllocateMemory(ZGMemoryMap processTask, ZGMemoryAddress *address, ZGMemorySize size);
bool ZGDeallocateMemory(ZGMemoryMap processTask, ZGMemoryAddress address, ZGMemorySize size);

// ZGReadBytes allocates memory, the caller is responsible for deallocating it using ZGFreeBytes(...)
bool ZGReadBytes(ZGMemoryMap processTask, ZGMemoryAddress address, void **bytes, ZGMemorySize *size);
void ZGFreeBytes(ZGMemoryMap processTask, const void *bytes, ZGMemorySize size);

bool ZGWriteBytes(ZGMemoryMap processTask, ZGMemoryAddress address, const void *bytes, ZGMemorySize size);
bool ZGWriteBytesIgnoringProtection(ZGMemoryMap processTask, ZGMemoryAddress address, const void *bytes, ZGMemorySize size);

bool ZGRegionInfo(ZGMemoryMap processTask, ZGMemoryAddress *address, ZGMemorySize *size, ZGMemoryBasicInfo *regionInfo);
bool ZGRegionSubmapInfo(ZGMemoryMap processTask, ZGMemoryAddress *address, ZGMemorySize *size, ZGMemorySubmapInfo *regionInfo);

bool ZGMemoryProtectionInRegion(ZGMemoryMap processTask, ZGMemoryAddress *address, ZGMemorySize *size, ZGMemoryProtection *memoryProtection);
bool ZGProtect(ZGMemoryMap processTask, ZGMemoryAddress address, ZGMemorySize size, ZGMemoryProtection protection);

bool ZGSuspendCount(ZGMemoryMap processTask, integer_t *suspendCount);

bool ZGSuspendTask(ZGMemoryMap processTask);
bool ZGResumeTask(ZGMemoryMap processTask);
	
#ifdef __cplusplus
}
#endif

#endif
