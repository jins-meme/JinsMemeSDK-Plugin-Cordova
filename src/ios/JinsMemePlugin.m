/********* JinsMemePlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <MEMELib/MEMELib.h>
#import "JinsMemeMessage.h"

@interface JinsMemePlugin : CDVPlugin <MEMELibDelegate> {
    // Member variables go here.
    BOOL _initialized;
    BOOL _isActive;
    BOOL _prevIsConnected;
    NSString *_connectedUuid;
    NSMutableArray *_peripherals;
    CDVInvokedUrlCommand* _setAppClientIDCommand;
    CDVInvokedUrlCommand* _scanCommand;
    CDVInvokedUrlCommand* _connectCommand;
    CDVInvokedUrlCommand* _reportCommand;
}

- (void)setAppClientID:(CDVInvokedUrlCommand*)command;
- (void)startScan:(CDVInvokedUrlCommand*)command;
- (void)stopScan:(CDVInvokedUrlCommand*)command;
- (void)connect:(CDVInvokedUrlCommand*)command;
- (void)isConnected:(CDVInvokedUrlCommand*)command;
- (void)disconnect:(CDVInvokedUrlCommand*)command;
- (void)setAutoConnect:(CDVInvokedUrlCommand*)command;
- (void)startDataReport:(CDVInvokedUrlCommand*)command;
- (void)stopDataReport:(CDVInvokedUrlCommand*)command;
- (void)getSDKVersion:(CDVInvokedUrlCommand*)command;
- (void)getConnectedByOthers:(CDVInvokedUrlCommand*)command;
- (void)isCalibrated:(CDVInvokedUrlCommand*)command;
- (void)getConnectedDeviceType:(CDVInvokedUrlCommand*)command;
- (void)getConnectedDeviceSubType:(CDVInvokedUrlCommand*)command;
- (void)getFWVersion:(CDVInvokedUrlCommand*)command;
- (void)getHWVersion:(CDVInvokedUrlCommand*)command;
- (void)isDataReceiving:(CDVInvokedUrlCommand*)command;
@end

@implementation JinsMemePlugin

const int JINS_MEME_PLUGIN_ERROR_INIT_FAIL = -100;
const int JINS_MEME_PLUGIN_ERROR_NOT_INIT = -101;
const int JINS_MEME_PLUGIN_ERROR_IS_SCANNING = -102;
const int JINS_MEME_PLUGIN_ERROR_NOT_CONNECTED = -103;

#pragma mark CORDOVA_DEFINED

/**
 * Initialize plugin.
 */
- (void)pluginInitialize
{
    _initialized = NO;
    _isActive = YES;
    _prevIsConnected = NO;
    _connectedUuid = nil;
    _peripherals = [NSMutableArray array];
    _setAppClientIDCommand = nil;
    _scanCommand = nil;
    _connectCommand = nil;
    _reportCommand = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAppDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAppDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

#pragma mark IOS_APP_OBSERVATION

/**
 * appDidBecomeActive
 */
- (void)onAppDidBecomeActive:(NSNotification*)notification
{
    NSLog(@"%@",@"applicationDidBecomeActive");
    BOOL currIsConnected = [[MEMELib sharedInstance] isConnected];
    _isActive = YES;

    if (_prevIsConnected != currIsConnected && nil != _connectCommand) {
        int status = currIsConnected ? 1 : 0;
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                messageAsDictionary:[self getConnectionData:_connectedUuid status:status]];
        [result setKeepCallbackAsBool:YES];
        [self sendResult:result command:_connectCommand];
    }
}
/**
 * appDidEnterBackground
 */
- (void)onAppDidEnterBackground:(NSNotification*)notification
{
    NSLog(@"%@",@"applicationDidEnterBackground");
    _isActive = NO;
    _prevIsConnected = [[MEMELib sharedInstance] isConnected];
}

#pragma mark CORDOVA_PLUGIN_UTILS

/**
 * Should initialize JINS MEME SDK.
 * This method must be calaled all plugin methods except for "setAppClientID"
 *
 * @return YES=Has not been initalized yet, NO=Has been initialized already
 */
- (BOOL)shouldInitalize:(CDVInvokedUrlCommand*)command
{
    if (_initialized) {
        return NO;
    }
    
    [self.commandDelegate sendPluginResult:[self getErrorResult:JINS_MEME_PLUGIN_ERROR_NOT_INIT
                                                           with:[NSString stringWithFormat:@"Execute setAppClientId before %@", command.methodName]]
                                callbackId:command.callbackId];

    return YES;
}
/**
 * Should connect to device.
 */
- (BOOL)shouldConnect:(CDVInvokedUrlCommand*)command
{
    if ([self shouldInitalize:command]) {
        return YES;
    }
    
    if ([[MEMELib sharedInstance] isConnected]) {
        return NO;
    }
    
    [self.commandDelegate sendPluginResult:[self getErrorResult:JINS_MEME_PLUGIN_ERROR_NOT_CONNECTED
                                                           with:[NSString stringWithFormat:@"Connect to device before %@", command.methodName]]
                                callbackId:command.callbackId];
    
    return YES;
}
/**
 * Get error dictionary.
 */
- (NSDictionary*)getConnectionData:(NSString*)uuid status:(int)connectionStatus
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            uuid, @"target",
            [NSNumber numberWithInt:connectionStatus], @"status", nil];
}
/**
 * Get error plugin result.
 */
- (CDVPluginResult*)getErrorResult:(int)code with:(NSString*)message
{
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                         messageAsDictionary:[JinsMemeMessage getError: code message:message]];
}
/**
 * Get error plugin result from MEME status.
 */
- (CDVPluginResult*)getErrorResult:(MEMEStatus)status
{
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                         messageAsDictionary:[JinsMemeMessage getErrorFromStatus:status]];
}
/**
 * Get success plugin result.
 */
- (CDVPluginResult*)getSuccessResult
{
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
}
/**
 * Get success plugin result.
 */
- (CDVPluginResult*)getSuccessResultWithString:(NSString*)message
{
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
}
/**
 * Get success plugin result.
 */
- (CDVPluginResult*)getSuccessResultWithInt:(int)message
{
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:message];
}
/**
 * Send plugin result.
 */
- (void)sendResult:(CDVPluginResult*)result command:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
/**
 * Send plugin result.
 */
- (void)sendStatusResult:(MEMEStatus)status command:(CDVInvokedUrlCommand*)command
{
    if ([self isOkStatus:status]) {
        [self sendResult:[self getSuccessResult] command:command];
    } else {
        [self sendResult:[self getErrorResult:status] command:command];
    }
}
/**
 * Is OK MEME status.
 */
- (BOOL)isOkStatus:(MEMEStatus)status
{
    return MEME_OK == status;
}

#pragma mark CORDOVA_PLUGIN_METHOD

/**
 * Initialize JINS MEME SDK.
 */
- (void)setAppClientID:(CDVInvokedUrlCommand*)command;
{
    _setAppClientIDCommand = command;
    [MEMELib setAppClientId:[command.arguments objectAtIndex:0]
               clientSecret:[command.arguments objectAtIndex:1]];
    [MEMELib sharedInstance].delegate = self;
    _initialized = NO;
}
/**
 * Begin scanning JINS MEME.
 */
- (void)startScan:(CDVInvokedUrlCommand*)command
{
    NSLog(@"Execute statScan");
    
    if ([self shouldInitalize: command]) {
        NSLog(@"Should initalize before statScan");
        return;
    }
    
    MEMEStatus status = [[MEMELib sharedInstance] startScanningPeripherals];
    
    if ([self isOkStatus:status]) {
        _scanCommand = command;
    } else {
        [self sendResult:[self getErrorResult:status] command:command];
    }
}
/**
 * Stops scanning JINS MEME.
 */
- (void)stopScan:(CDVInvokedUrlCommand*)command;
{
    if ([self shouldInitalize: command]) {
        return;
    }
    
    MEMEStatus status = [[MEMELib sharedInstance] stopScanningPeripherals];
    
    if ([self isOkStatus:status]) {
        _scanCommand = nil;
    }
    
    [self sendStatusResult:status command: command];
}
/**
 * Establishes connection to JINS MEME.
 */
- (void)connect:(CDVInvokedUrlCommand*)command
{
    if ([self shouldInitalize: command]) {
        return;
    }
    
    NSString* uuid = [command.arguments objectAtIndex:0];
    CBPeripheral *peripheral = [self findPeripheral:uuid];
    MEMEStatus status = [[MEMELib sharedInstance] connectPeripheral: peripheral ];
    
    if ([self isOkStatus:status]) {
        _connectCommand = command;
    } else {
        [self sendResult:[self getErrorResult:status] command:command];
    }
}
/**
 * Returns whether a connection to JINS MEME has been established.
 */
- (void)isConnected:(CDVInvokedUrlCommand*)command
{
    if ([self shouldInitalize: command]) {
        return;
    }
    
    int isConnectedAsInt = [[MEMELib sharedInstance] isConnected] ? 1 : 0;
    [self sendResult:[self getSuccessResultWithInt:isConnectedAsInt] command:command];
}
/**
 * Disconnects from JINS MEME.
 */
- (void)disconnect:(CDVInvokedUrlCommand*)command
{
    if ([self shouldInitalize: command]) {
        return;
    }

    [self sendStatusResult:[[MEMELib sharedInstance] disconnectPeripheral] command: command];
}
/**
 * Set auto connect.
 */
- (void)setAutoConnect:(CDVInvokedUrlCommand*)command
{
    if ([self shouldInitalize: command]) {
        return;
    }
    
    [[MEMELib sharedInstance] setAutoConnect:(BOOL)[command.arguments objectAtIndex:0]];
    [self sendResult:[self getSuccessResult] command:command];
}
/**
 * Starts receiving data.
 */
- (void)startDataReport:(CDVInvokedUrlCommand*)command
{
    if ([self shouldConnect: command]) {
        return;
    }
    
    MEMEStatus status = [[MEMELib sharedInstance] startDataReport];
    
    if ([self isOkStatus:status]) {
        _reportCommand = command;
    } else {
        [self sendResult:[self getErrorResult:status] command:command];
    }
}
/**
 * Stops receiving data.
 */
- (void)stopDataReport:(CDVInvokedUrlCommand*)command
{
    if ([self shouldConnect: command]) {
        return;
    }
    
    MEMEStatus status = [[MEMELib sharedInstance] stopDataReport];
    
    if ([self isOkStatus:status]) {
        _reportCommand = nil;
    }
    
    [self sendStatusResult:status command: command];
}
/**
 * Returns SDK version.
 */
- (void)getSDKVersion:(CDVInvokedUrlCommand*)command
{
    if ([self shouldInitalize: command]) {
        return;
    }
    
    [self sendResult:[self getSuccessResultWithString:[[MEMELib sharedInstance] getSDKVersion]] command:command];
}
/**
 * Returns JINS MEME connected with other apps.
 */
- (void)getConnectedByOthers:(CDVInvokedUrlCommand*)command
{
    if ([self shouldConnect: command]) {
        return;
    }
    

    NSArray* peripherals = [[MEMELib sharedInstance] getConnectedByOthers];
    NSMutableArray* items = [NSMutableArray array];
    
    for (CBPeripheral* p in peripherals) {
        [items addObject:[p.identifier UUIDString]];
    }
    
    [self sendResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:items] command:command];
}
/**
 * Returns calibration status.
 */
- (void)isCalibrated:(CDVInvokedUrlCommand*)command
{
    if ([self shouldConnect: command]) {
        return;
    }
    
    MEMECalibStatus status = [[MEMELib sharedInstance] isCalibrated];
    [self sendResult:[self getSuccessResultWithInt:[JinsMemeMessage getCalibratedCode:status]] command:command];
}
/**
 * Returns device type.
 */
- (void)getConnectedDeviceType:(CDVInvokedUrlCommand*)command
{
    if ([self shouldConnect: command]) {
        return;
    }
    
    [self sendResult:[self getSuccessResultWithInt:[[MEMELib sharedInstance] getConnectedDeviceType]] command:command];
}
/**
 * Returns device sub-type.
 */
- (void)getConnectedDeviceSubType:(CDVInvokedUrlCommand*)command
{
    if ([self shouldConnect: command]) {
        return;
    }
    
    [self sendResult:[self getSuccessResultWithInt:[[MEMELib sharedInstance] getConnectedDeviceSubType]] command:command];
}
/**
 * Returns firmware version.
 */
- (void)getFWVersion:(CDVInvokedUrlCommand*)command
{
    if ([self shouldConnect: command]) {
        return;
    }
    
    [self sendResult:[self getSuccessResultWithString:[[MEMELib sharedInstance] getFWVersion]] command:command];
}
/**
 * Returns hardware version.
 */
- (void)getHWVersion:(CDVInvokedUrlCommand*)command
{
    if ([self shouldConnect: command]) {
        return;
    }
    
    [self sendResult:[self getSuccessResultWithInt:[[MEMELib sharedInstance] getHWVersion]] command:command];
}
/**
 * Returns response about whether data was received or not.
 */
- (void)isDataReceiving:(CDVInvokedUrlCommand*)command
{
    if ([self shouldInitalize: command]) {
        return;
    }
    
    int isDataReceivingAsInt = [[MEMELib sharedInstance] isDataReceiving] ? 1 : 0;
    [self sendResult:[self getSuccessResultWithInt:isDataReceivingAsInt] command:command];
}

#pragma mark PERIPHERALS

/**
 * Has already found.
 */
- (BOOL)hasAlreayFound:(CBPeripheral *) peripheral
{
    for (CBPeripheral *p in _peripherals){
        if ([p.identifier isEqual: peripheral.identifier]){
            return YES;
        }
    }

    return NO;
}
/**
 * Find already found peripheral.
 */
- (CBPeripheral*)findPeripheral:(NSString*)uuid
{
    for (CBPeripheral *p in _peripherals){
        if ([[p.identifier UUIDString] isEqualToString:uuid]) {
            return p;
        }
    }
    
    return nil;
}

#pragma mark MEMELib Delegates

/**
 * Delegate for receiving authentication result.
 */
- (void) memeAppAuthorized:(MEMEStatus)status
{
    //    [self checkMEMEStatus: status];
    NSLog(@"MEME App Authorized %d", status);

    if (_initialized) {
        return;
    }

    _initialized = [self isOkStatus: status];

    if (nil == _setAppClientIDCommand) {
        return;
    }

    if (_initialized) {
        [self sendResult:[self getSuccessResult] command:_setAppClientIDCommand];
    } else {
        [self sendResult:[self getErrorResult:status] command:_setAppClientIDCommand];
    }

    _setAppClientIDCommand = nil;
}

/**
 * Delegate for receiving results of the scanning process.
 */
- (void) memePeripheralFound:(CBPeripheral*)peripheral withDeviceAddress:(NSString *)address
{
    if ([self hasAlreayFound:peripheral]) {
        return;
    }

    //NSLog(@"New peripheral found %@ %@", [peripheral.identifier UUIDString], address);
    [_peripherals addObject: peripheral];
    
    if (nil == _scanCommand) {
        return;
    }
    
    if (_isActive) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                    messageAsString:[peripheral.identifier UUIDString]];
        [result setKeepCallbackAsBool:YES];
        [self sendResult:result command:_scanCommand];
    }
}
/**
 * Delegate for receiving connection status to JINS MEME.
 */
- (void) memePeripheralConnected:(CBPeripheral*)peripheral
{
    NSLog(@"MEME Device Connected!");
    
    if (nil == _connectCommand) {
        return;
    }

    if (_isActive) {
        _connectedUuid = [peripheral.identifier UUIDString];
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                messageAsDictionary:[self getConnectionData:_connectedUuid status:1]];
        [result setKeepCallbackAsBool:YES];
        [self sendResult:result command:_connectCommand];
    }
}
/**
 * Delegate for receiving whether the app is disconnected from JINS MEME.
 */
- (void) memePeripheralDisconnected:(CBPeripheral*)peripheral
{
    NSLog(@"MEME Device Disconnected");
    
    if (nil == _connectCommand) {
        return;
    }
    
    if (_isActive) {
        _connectedUuid = [peripheral.identifier UUIDString];
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                messageAsDictionary:[self getConnectionData:_connectedUuid status:0]];
        [result setKeepCallbackAsBool:YES];
        [self sendResult:result command:_connectCommand];
    }
}
/**
 * Delegate for receiving real time mode data.
 */
- (void) memeRealTimeModeDataReceived:(MEMERealTimeData*)data
{
    if (nil == _reportCommand) {
        return;
    }
    
    if (_isActive) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                messageAsDictionary:[JinsMemeMessage convertToDictionary:data]];
        [result setKeepCallbackAsBool:YES];
        [self sendResult:result command:_reportCommand];
    }
}
/**
 * Gets command run result events.
 */
- (void) memeCommandResponse:(MEMEResponse)response
{
    NSLog(@"Command Response - eventCode: 0x%02x - commandResult: %d", response.eventCode, response.commandResult);
    
    switch (response.eventCode) {
        case 0x02:
            NSLog(@"Data Report Started");
            break;
        case 0x04:
            NSLog(@"Data Report Stopped");
            break;
        default:
            break;
    }
}

@end
