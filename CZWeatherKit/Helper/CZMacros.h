//
//  CZMacros.h
//
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//

#if !(TARGET_OS_IPHONE)
#define CGPointValue pointValue
#endif

#define F_TO_C(temp) (5.0/9.0) * (temp - 32.0)

#define MPH_TO_KPH(speed) (speed * 1.609344)