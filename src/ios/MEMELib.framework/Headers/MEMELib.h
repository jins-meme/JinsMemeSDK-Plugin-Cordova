//
//  MEMELib.h
//  
//
//  Created by JINS MEME on 8/11/14.
//  Copyright (c) 2014 JIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "MEMEStandardData.h"
#import "MEMERealTimeData.h"
#import "MEMEStdDataAverage.h"

FOUNDATION_EXPORT double MEMEVersionNumber;
FOUNDATION_EXPORT const unsigned char MEMEVersionString[];


// Communication Mode
typedef enum {
    MEME_COM_UNKNOWN  = 0,    // No Connection
    MEME_COM_STANDARD = 1,      // Standard Mode
    MEME_COM_REALTIME = 2,       // RealTime Mode
} MEMEDataMode;

// MEME Device Type
typedef enum {
    ES  = 0,
    MT = 1,
} MEMEType;

// Calibration Status
typedef enum {
    CALIB_NOT_FINISHED      = 0,
    CALIB_BODY_FINISHED     = 1,
    CALIB_EYE_FINISHED      = 2,
    CALIB_BOTH_FINISHED     = 3,
} MEMECalibStatus;

// Error Code
typedef enum {
    MEME_OK                 = 0,
    MEME_ERROR              = 1, // Misc Error
    MEME_ERROR_SDK_AUTH     = 2, // SDK Auth Error
    MEME_ERROR_APP_AUTH     = 3, // App Auth Error
    MEME_ERROR_CONNECTION   = 4, // No Connection
    MEME_DEVICE_INVALID     = 5,
    MEME_CMD_INVALID        = 6,
    MEME_ERROR_FW_CHECK     = 7, // FW Version Error
    MEME_ERROR_BL_OFF       = 8
} MEMEStatus;


typedef struct {
    int eventCode;
    BOOL commandResult;
} MEMEResponse;

// Notification Names
extern NSString *MEMELibAppAuthorizedNotification;
extern NSString *MEMELibPeripheralFoundNotification;
extern NSString *MEMELibPeripheralConnectedNotification;
extern NSString *MEMELibPeripheralDisconnetedNotification;
extern NSString *MEMELibStandardModeDataReceivedNotification;
extern NSString *MEMELibRealtimeModeDataReceivedNotification;
extern NSString *MEMELibCommandResponseNotification;
extern NSString *MEMELibDeviceInfoUpdatedNotification;

// Notification UserInfo Keys
extern NSString *MEMELibStatusCodeUserInfoKey;
extern NSString *MEMELibPeripheralUserInfoKey;
extern NSString *MEMELibMacAddressUserInfoKey;
extern NSString *MEMELibStandardDataUserInfoKey;
extern NSString *MEMELibRealtimeDataUserInfoKey;
extern NSString *MEMELibResponseUserInfoKey;
extern NSString *MEMELibResponseEventCodeUserInfoKey;
extern NSString *MEMELibResponseCommandResultUserInfoKey;

@protocol MEMELibDelegate <NSObject>

@optional

- (void) memePeripheralFound: (CBPeripheral *) peripheral withDeviceAddress: (NSString *) address;

- (void) memePeripheralConnected: (CBPeripheral *)peripheral;
- (void) memePeripheralDisconnected: (CBPeripheral *)peripheral;

- (void) memeStandardModeDataReceived: (MEMEStandardData *) data;
- (void) memeRealTimeModeDataReceived: (MEMERealTimeData *) data;

- (void) memeCommandResponse: (MEMEResponse) response;

- (void) memeAppAuthorized: (MEMEStatus) status;

- (void) memeDeviceInfoUpdated;

@end


@interface MEMELib : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic)   id<MEMELibDelegate> delegate;

@property (readonly) BOOL            isConnected;
@property (readonly) MEMECalibStatus isCalibrated;

@property (readonly) BOOL isDataReceiving;
@property (readonly) BOOL isAutoConnect;

+ (MEMELib *)sharedInstance;
+ (void) setAppClientId: (NSString *) _clientId clientSecret: (NSString *) _clientSecret;

#pragma mark CONNECTION

- (MEMEStatus) startScanningPeripherals;
- (MEMEStatus) stopScanningPeripherals;

- (MEMEStatus) connectPeripheral:(CBPeripheral *)peripheral;
- (MEMEStatus) disconnectPeripheral;

- (void) setAutoConnect: (BOOL) flag;

#pragma mark DEVICE

- (MEMEStatus) startDataReport;
- (MEMEStatus) startDataReport: (MEMEDataMode) mode;
- (MEMEStatus) stopDataReport;
- (MEMEDataMode) getDataMode;

#pragma mark INFO

- (NSString *) getSDKVersion;
- (NSString *) getFWVersion;
- (UInt8) getHWVersion;

- (int) getConnectedDeviceType;
- (int) getConnectedDeviceSubType;

- (NSArray *) getConnectedByOthers;


@end
