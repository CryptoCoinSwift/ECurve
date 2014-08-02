//
//  ECurve.h
//  ECurve
//
//  Created by Sjors Provoost on 01-07-14.
//

#ifdef __APPLE__
#include "TargetConditionals.h"

#if TARGET_IPHONE_SIMULATOR
#define iOs

#elif TARGET_OS_IPHONE
#define iOs

#elif TARGET_OS_MAC
// mac os

#else
// Unsupported platform
#endif
#endif

#ifdef iOs
#import <UIKit/UIKit.h>
//! Project version number for ECurve.
FOUNDATION_EXPORT double ECurveVersionNumber;

//! Project version string for ECurve.
FOUNDATION_EXPORT const unsigned char ECurveVersionString[];
#else
#import <Cocoa/Cocoa.h>

//! Project version number for ECurveMac.
FOUNDATION_EXPORT double ECurveMacVersionNumber;

//! Project version string for ECurveMac.
FOUNDATION_EXPORT const unsigned char ECurveMacVersionString[];
#endif

// In this header, you should import all the public headers of your framework using statements like #import <ECurve/PublicHeader.h>


