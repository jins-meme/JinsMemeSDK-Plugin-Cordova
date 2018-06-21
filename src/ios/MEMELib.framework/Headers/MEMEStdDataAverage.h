//
//  MEMEStdDataAverage.h
//  MEMELib
//
//  Created by JINS MEME on 2015/08/05.
//  Copyright (c) 2015年 JIN. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "MEMEData.h"

@interface MEMEStdDataAverage : MEMEData

@property float eyeMoveBigHorizontal;
@property float eyeMoveBigVertical;
@property float eyeMoveHorizontal;
@property float eyeMoveVertical;
@property float numBlinks;
@property float numBlinkBurst;
@property float blinkSpeed;
@property float blinkStrength;
@property float blinkStrengthMax;
@property float blinkStrengthMin;
@property float blinkIntervalAvg;
@property float blinkIntervalMax;

@end
