#import <Foundation/Foundation.h>
#import <MEMELib/MEMELib.h>

@interface JinsMemeMessage : NSObject

+ getError:(int)code message:(NSString*)message;
+ getErrorFromStatus:(MEMEStatus)status;
+ (int)getCalibratedCode:(MEMECalibStatus)status;
+ (NSDictionary*)convertToDictionary:(MEMERealTimeData*)data;

@end
