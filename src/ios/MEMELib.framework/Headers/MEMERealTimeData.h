//
//  MEMERealTimeData.h
//  MemLib
//
//  Created by JINS MEME on 2015/02/03.
//  Copyright (c) 2015年 JINS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MEMEData.h"

@interface MEMERealTimeData : MEMEData

@property UInt8 fitError; // 0: 正常 1: 装着エラー
@property BOOL isWalking;

@property BOOL noiseStatus;

@property UInt8 powerLeft; // 5: フル充電 0: 空

@property UInt8 eyeMoveUp;
@property UInt8 eyeMoveDown;
@property UInt8 eyeMoveLeft;
@property UInt8 eyeMoveRight;

@property UInt8 blinkSpeed;    // in ms 
@property UInt16 blinkStrength;

@property float roll;
@property float pitch;
@property float yaw;

@property float accX;
@property float accY;
@property float accZ;

@end
