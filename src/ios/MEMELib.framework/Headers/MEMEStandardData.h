//
//  MEMEStandardData.h
//  MemLib
//
//  Created by JINS MEME on 2015/02/03.
//  Copyright (c) 2015年 JINS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEMEData.h"

// Focus Level
typedef enum {
    MEME_FCS_NO_DATA            = 0,
    MEME_FCS_NOT_FOCUSED        = 1,
    MEME_FCS_A_LITTLE           = 2,
    MEME_FCS_VERY               = 3,
} MemeFocusResult;

// Sleepiness Level
typedef enum {
    MEME_SLP_NO_DATA            = 0,
    MEME_SLP_NOT_SLEEPY         = 1,
    MEME_SLP_A_LITTLE           = 2,
    MEME_SLP_VERY               = 3,
} MemeSleepyResult;

// Fit Status
typedef enum {
    MEME_FIT_OK                 = 0,
    MEME_FIT_ERROR_R            = 1,
    MEME_FIT_ERROR_L            = 2,
    MEME_FIT_ERROR_BRIDGE       = 3,
} MEMEFitStatus;

@interface MEMEStandardData : MEMEData

// データが記録された時間
@property (nonatomic, strong) NSDate *capturedAt;

// 装着エラー
@property MEMEFitStatus fitError; // 0: 正常 1: 装着エラー

// バッテリーの残量
@property UInt8 powerLeft; // 5: フル充電  0: 空

// デバイスにキャッシュされているスタンダードデータの数
@property UInt16 numStoredData;

// 目の動き
@property float eyeMoveBigHorizontal;
@property float eyeMoveBigVertical;
@property float eyeMoveHorizontal;
@property float eyeMoveVertical;

// 歩行に関するデータ
@property UInt8 cadence;      

// 頭の動き
@property UInt8 headMoveBigVerticalCount;
@property UInt8 headMoveBigHorizontalCount;
@property UInt8 headMoveVerticalCount;
@property UInt8 headMoveHorizontalCount;

// 歩数
@property UInt8 numSteps280;
@property UInt8 numSteps310;
@property UInt8 numSteps340;
@property UInt8 numSteps370;
@property UInt8 numSteps400;
@property UInt8 numSteps430;
@property UInt8 numSteps460;
@property UInt8 numSteps500;
@property UInt8 numSteps530;
@property UInt8 numSteps560;
@property UInt8 numSteps590;
@property UInt8 numSteps620;
@property UInt8 numSteps650;
@property UInt8 numSteps680;
@property UInt8 numSteps710;
@property UInt8 numSteps750;
@property UInt8 numSteps780;
@property UInt8 numSteps810;
@property UInt8 numSteps840;
@property UInt8 numSteps870;
@property UInt8 numSteps900;
@property UInt8 numSteps930;
@property UInt8 numSteps960;
@property UInt8 numSteps1000;
@property (readonly) int numSteps; // 上記の合計の歩数

// 体軸
@property float rollAvg;
@property float pitchAvg;
@property float rollDiff;
@property float pitchDiff;

// 立脚期の割合
@property UInt8 footholdRight;
@property UInt8 footholdLeft;

// まばたきに関する情報
@property float numBlinks;
@property float numBlinkBurst;

@property UInt16 blinkSpeed;
@property UInt16 blinkStrength;

@property float blinkIntervalAvg;
@property float blinkIntervalMax;

@property UInt16 blinkSpeedStd;
@property UInt16 blinkStrengthMax;
@property UInt16 blinkStrengthMin;

// 姿勢マトリクス 20秒おきのデータ
@property UInt8 *sittingPostureIndices;

// 一分間のうちで眼電位がきちんと取得できなかった時間 (秒)
@property UInt8 EOGNoiseDuration;

@property (readonly) BOOL isEOGValid;

@property MemeSleepyResult sleepy;
@property MemeFocusResult  focus;

// 最新のデータかどうか
@property BOOL isCurrent;

@end
