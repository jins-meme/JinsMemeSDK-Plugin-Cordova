#import "JinsMemeMessage.h"

@implementation JinsMemeMessage

/**
 * Get error dictionary.
 */
+ (NSDictionary*)getError:(int)code message:(NSString*)message
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:code], @"code",
            message, @"message", nil];
}

/**
 * Get error dictionary from MemeStatus.
 */
+ getErrorFromStatus:(MEMEStatus)status
{
    return [JinsMemeMessage getError:[JinsMemeMessage getMemeStatusCode:status]
                             message:[JinsMemeMessage getMemeStatusMessage:status]];
}

/**
 * Get MEME status code as integer.
 * The codes must be as same as ones used in Android plugin.
 */
+ (int) getMemeStatusCode:(MEMEStatus) status
{
    if (MEME_OK == status) {
        return 0;
    } else if (MEME_ERROR == status) {
        return 1;
    } else if (MEME_ERROR_SDK_AUTH == status) {
        return 2;
    } else if (MEME_ERROR_APP_AUTH == status) {
        return 3;
    } else if (MEME_ERROR_CONNECTION == status) {
        return 4;
    } else if (MEME_DEVICE_INVALID == status) { // Android MEME_ERROR_LOGICAL
        return 5;
    } else if (MEME_CMD_INVALID == status) {
        return 6;
    } else if (MEME_ERROR_FW_CHECK == status) {
        return 7;
    } else if (MEME_ERROR_BL_OFF == status) {
        return 8;
    } else {
        return -1; // Never come here.
    }
}
/**
 * Get MEME status message.
 */
+ (NSString*) getMemeStatusMessage:(MEMEStatus) status
{
    if (MEME_OK == status) {
        return @"App successfully authenticated, connection to JINS MEME established";
    } else if (MEME_ERROR == status) {
        return @"Error issuing command to JINS MEME";
    } else if (MEME_ERROR_SDK_AUTH == status) {
        return @"SDK authentication error";
    } else if (MEME_ERROR_APP_AUTH == status) {
        return @"App authentication error";
    } else if (MEME_ERROR_CONNECTION == status) {
        return @"Failure establishing connection to JINS MEME";
    } else if (MEME_DEVICE_INVALID == status) { // Android MEME_ERROR_LOGICAL
        return @"Device disabled";
    } else if (MEME_CMD_INVALID == status) {
        return @"Not permitted to run command";
    } else if (MEME_ERROR_FW_CHECK == status) {
        return @"MEME firmware is not up to date";
    } else if (MEME_ERROR_BL_OFF == status) {
        return @"Bluetooth is not enabled";
    } else {
        return @"Unknown"; // Never come here.
    }
}
/**
 * Get MEMECalibStatus code.
 * The codes must be as same as ones used in Android plugin.
 */
+ (int)getCalibratedCode:(MEMECalibStatus)status
{
    if (CALIB_NOT_FINISHED == status) {
        return 0;
    } else if (CALIB_BODY_FINISHED == status) {
        return 1;
    } else if (CALIB_EYE_FINISHED == status) {
        return 2;
    } else if (CALIB_BOTH_FINISHED == status) {
        return 3;
    } else {
        return -1; // Never come here.
    }
}

/**
 * Convert MEMERealTimeData into dictionary.
 */
+ (NSDictionary*)convertToDictionary:(MEMERealTimeData*)data
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    int noiseStatus = [data noiseStatus] ? 1 : 0;
    
    [dic setValue:[NSNumber numberWithUnsignedChar:[data eyeMoveUp]] forKey:@"eyeMoveUp"];
    [dic setValue:[NSNumber numberWithUnsignedChar:[data eyeMoveDown]] forKey:@"eyeMoveDown"];
    [dic setValue:[NSNumber numberWithUnsignedChar:[data eyeMoveLeft]] forKey:@"eyeMoveLeft"];
    [dic setValue:[NSNumber numberWithUnsignedChar:[data eyeMoveRight]] forKey:@"eyeMoveRight"];
    [dic setValue:[NSNumber numberWithUnsignedChar:[data blinkSpeed]] forKey:@"blinkSpeed"];
    [dic setValue:[NSNumber numberWithUnsignedChar:[data blinkStrength]] forKey:@"blinkStrength"];
    [dic setValue:[NSNumber numberWithUnsignedChar:[data isWalking]] forKey:@"walking"];
    [dic setValue:[NSNumber numberWithFloat:[data roll]] forKey:@"roll"];
    [dic setValue:[NSNumber numberWithFloat:[data pitch]] forKey:@"pitch"];
    [dic setValue:[NSNumber numberWithFloat:[data yaw]] forKey:@"yaw"];
    [dic setValue:[NSNumber numberWithChar:[data accX]] forKey:@"accX"];
    [dic setValue:[NSNumber numberWithChar:[data accY]] forKey:@"accY"];
    [dic setValue:[NSNumber numberWithChar:[data accZ]] forKey:@"accZ"];
    [dic setValue:[NSNumber numberWithInt:noiseStatus] forKey:@"noiseStatus"];
    [dic setValue:[NSNumber numberWithUnsignedChar:[data fitError]] forKey:@"fitError"];
    [dic setValue:[NSNumber numberWithUnsignedChar:[data powerLeft]] forKey:@"powerLeft"];
    
    return dic;
}

@end
