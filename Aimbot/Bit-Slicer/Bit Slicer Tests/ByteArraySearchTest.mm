/*
 * Created by Mayur Pawashe on 5/24/14.
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

#import <XCTest/XCTest.h>

@interface ByteArraySearchTest : XCTestCase

@property (nonatomic) NSData *data;

@end

@implementation ByteArraySearchTest

extern "C" unsigned char* boyer_moore_helper(const unsigned char *haystack, const unsigned char *needle, unsigned long haystack_length, unsigned long needle_length, const unsigned long *char_jump, const unsigned long *match_jump);

extern void ZGPrepareBoyerMooreSearch(const unsigned char *needle, const unsigned long needle_length, unsigned long *char_jump, unsigned long *match_jump);

- (void)setUp
{
	[super setUp];
	
	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"random_data" ofType:@""]];
	XCTAssertNotNil(data);
	
	self.data = data;
}

- (BOOL)searchAndVerifyBytes:(const uint8_t *)bytes length:(NSUInteger)length getNumberOfResults:(NSUInteger *)numberOfResultsBack
{
	XCTAssertTrue(length <= self.data.length);
	
	NSUInteger numberOfResults = 0;
	for (NSUInteger dataIndex = 0; dataIndex + length <= self.data.length; dataIndex++)
	{
		if (memcmp(bytes, (uint8_t *)self.data.bytes + dataIndex, length) == 0)
		{
			numberOfResults++;
		}
	}
	
	NSUInteger numberOfBoyerMooreResults = 0;
	
	unsigned long long size = self.data.length;
	unsigned long long dataSize = length;
	const unsigned char *dataBytes = (const unsigned char *)self.data.bytes;
	
	unsigned long charJump[UCHAR_MAX + 1] = {0};
	unsigned long *matchJump = (unsigned long *)malloc(2 * (dataSize + 1) * sizeof(*matchJump));
	
	ZGPrepareBoyerMooreSearch(bytes, dataSize, charJump, matchJump);
	
	unsigned char *foundSubstring = (unsigned char *)dataBytes;
	unsigned long haystackLengthLeft = size;
	
	while (haystackLengthLeft >= dataSize)
	{
		foundSubstring = boyer_moore_helper((const unsigned char *)foundSubstring, bytes, haystackLengthLeft, dataSize, (const unsigned long *)charJump, (const unsigned long *)matchJump);
		if (foundSubstring == NULL) break;
		
		// boyer_moore_helper is only checking 0 .. dataSize-1 characters, so make a check to see if the last characters are equal
		if (foundSubstring[dataSize-1] == bytes[dataSize-1])
		{
			numberOfBoyerMooreResults++;
		}
		
		foundSubstring++;
		haystackLengthLeft = size - (unsigned long long)(foundSubstring - dataBytes);
	}
	
	free(matchJump);
	
	*numberOfResultsBack = numberOfResults;
	
	return (numberOfResults == numberOfBoyerMooreResults);
}

- (void)testOneResult
{
	const uint8_t bytes[] = {0x00, 0x00, 0x01};
	NSUInteger numberOfResults = 0;
	XCTAssertTrue([self searchAndVerifyBytes:bytes length:sizeof(bytes) getNumberOfResults:&numberOfResults]);
	XCTAssertEqual(numberOfResults, 1U);
}

- (void)testFewResultsAndAtBeginning
{
	const uint8_t bytes[] = {0x00, 0xB1};
	NSUInteger numberOfResults = 0;
	XCTAssertTrue([self searchAndVerifyBytes:bytes length:sizeof(bytes) getNumberOfResults:&numberOfResults]);
	XCTAssertEqual(numberOfResults, 3U);
}

- (void)testOneByteResults
{
	const uint8_t bytes[] = {0xA1};
	NSUInteger numberOfResults = 0;
	XCTAssertTrue([self searchAndVerifyBytes:bytes length:sizeof(bytes) getNumberOfResults:&numberOfResults]);
	XCTAssertEqual(numberOfResults, 85U);
}

- (void)testNearEndOfData
{
	const uint8_t bytes[] = {0xEC, 0x9E, 0x5F};
	NSUInteger numberOfResults = 0;
	XCTAssertTrue([self searchAndVerifyBytes:bytes length:sizeof(bytes) getNumberOfResults:&numberOfResults]);
	XCTAssertEqual(numberOfResults, 1U);
}

- (void)testEndOfData
{
	const uint8_t bytes[] = {0x9E, 0x5F, 0x07};
	NSUInteger numberOfResults = 0;
	XCTAssertTrue([self searchAndVerifyBytes:bytes length:sizeof(bytes) getNumberOfResults:&numberOfResults]);
	XCTAssertEqual(numberOfResults, 1U);
}

@end
