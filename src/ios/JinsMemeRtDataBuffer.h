#import <Foundation/Foundation.h>

@interface JinsMemeRtDataBuffer : NSObject

@property (nonatomic) long maxSize;
@property (nonatomic) NSMutableArray* buffer;
@property (nonatomic) BOOL available;

- (id)init;
- (void)setAvailable:(BOOL)availabe;
- (void)setSize:(long)size;
- (void)setDefaultSize;
- (long)getSize;
- (long)formatSize:(long)size;
- (NSDictionary*)put:(NSMutableDictionary*)data;
- (NSDictionary*)poll;
- (void)clear;

@end
