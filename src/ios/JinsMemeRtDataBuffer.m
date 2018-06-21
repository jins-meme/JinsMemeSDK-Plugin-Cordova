#import "JinsMemeRtDataBuffer.h"

const long MIN_SIZE = 0;
const long MAX_SIZE = 72000;
const long DEFAULT_SIZE = 12000;

@implementation JinsMemeRtDataBuffer

@synthesize maxSize = _maxSize;
@synthesize available = _available;

/**
 * Initialize.
 */
- (id)init {
    if (self = [super init]) {
        _maxSize = DEFAULT_SIZE;
        _available = NO;
        self.buffer = [[NSMutableArray alloc] init];
    }
    
    return self;
}
/**
 * Set avaiability.
 */
- (void)setAvailable:(BOOL)availabe {
    _available = availabe;
}
/**
 * Set buffer size.
 */
- (void)setSize:(long)size {
    _maxSize = [self formatSize:size];
}
/**
 * Set buffer size to default.
 */
- (void)setDefaultSize {
    _maxSize = DEFAULT_SIZE;
}
/**
 * Get buffer size.
 */
- (long)getSize {
    return [self.buffer count];
}
/**
 * Format size.
 */
- (long)formatSize:(long)size {
    if (size < MIN_SIZE) {
        return MIN_SIZE;
    }
    
    if (size > MAX_SIZE) {
        return MAX_SIZE;
    }
    
    return size;
}
/**
 * Put data.
 */
- (NSDictionary*)put:(NSMutableDictionary*)data {
    if (!self.available) {
        return nil;
    }
    
    NSDictionary* polledData;
    
    if ([self.buffer count] >= self.maxSize) {
        polledData = [self poll];
    }

    [data setValue:[NSNumber numberWithBool:YES] forKey:@"isBackground"];
    [self.buffer addObject:data];
    
    return polledData;
}
/**
 * Poll data.
 */
- (NSDictionary*)poll {
    if ([self.buffer count] == 0) {
        return nil;
    }

    NSDictionary* polledData = [self.buffer objectAtIndex:0];
    [self.buffer removeObjectAtIndex:0];
    
    return polledData;
}
/**
 * Clear buffer.
 */
- (void)clear {
    [self.buffer removeAllObjects];
}

@end
