#import <UIKit/UIKit.h>

@interface VMaskTextField : UITextField

@property (nonatomic,strong) NSString * mask;
@property (nonatomic,strong) NSString * raw;
@property (nonatomic,strong) NSString * defaultCharMask;
@property (nonatomic,assign) BOOL disallowEditingBetweenCharacters;

- (double) rawToDouble;
- (float) rawToFloat;
- (NSInteger) rawToInteger;
- (NSDate *)rawToDate:(NSDateFormatter *)formatter;
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

// Our methods
- (NSString *) rawString;
- (void) setTextWithMask:(NSString *) text;

@end
