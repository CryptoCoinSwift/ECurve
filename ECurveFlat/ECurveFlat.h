//
//  ECurveFlat.h
//  ECurveFlat
//
//  Created by Sjors Provoost on 09-08-14.
//  Copyright (c) 2014 Crypto Coin Swift. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for ECurveFlat.
FOUNDATION_EXPORT double ECurveFlatVersionNumber;

//! Project version string for ECurveFlat.
FOUNDATION_EXPORT const unsigned char ECurveFlatVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ECurveFlat/PublicHeader.h>

void subtract(uint32_t result[], uint32_t lhs[], uint32_t rhs[]);
uint32_t *  divideWithOverflowC(uint32_t numerator[], uint32_t denominator[]);
uint32_t * remainderWithOverflowC(uint32_t numerator[], uint32_t denominator[]);
void montgomery(uint32_t x[], uint32_t y[],  uint32_t z[]);
void multiply(uint32_t lhs[], uint32_t rhs[],  uint32_t res[]);