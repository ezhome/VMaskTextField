#import "VMaskTextField.h"

NSString * kVMaskTextFieldDefaultChar = @"#";

@implementation VMaskTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.defaultCharMask = kVMaskTextFieldDefaultChar;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultCharMask = kVMaskTextFieldDefaultChar;
    }
    return self;
}

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (!_mask) {
        return YES;
    }

    if (self.disallowEditingBetweenCharacters) {
        NSInteger minimanAllowedLocation = self.text.length - 1;
        NSInteger editionLocation = range.location;
        if (editionLocation < minimanAllowedLocation) {
            [self resignFirstResponder]; // Do a trick with first responded to move
            [self becomeFirstResponder]; // cursor to the end of text field
            return NO;
        }
    }

    NSString * currentTextDigited = [self.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length == 0) {
        unichar lastCharDeleted = 0;
        while (currentTextDigited.length > 0 && !isnumber([currentTextDigited characterAtIndex:currentTextDigited.length-1])) {
            lastCharDeleted = [currentTextDigited characterAtIndex:[currentTextDigited length] - 1];
            currentTextDigited = [currentTextDigited substringToIndex:[currentTextDigited length] - 1];
        }
        self.text = currentTextDigited;
        return NO;
    }

    NSMutableString * returnText = [[NSMutableString alloc] init];
    if (currentTextDigited.length > _mask.length) {
        return NO;
    }

    int last = 0;
    BOOL needAppend = NO;
    for (int i = 0; i < currentTextDigited.length; i++) {
        unichar  currentCharMask = [_mask characterAtIndex:i];
        unichar  currentChar = [currentTextDigited characterAtIndex:i];
        if (isnumber(currentChar) && currentCharMask == '#') {
            [returnText appendString:[NSString stringWithFormat:@"%c",currentChar]];
        }else{
            if (currentCharMask == '#') {
                break;
            }
            if (isnumber(currentChar) && currentChar != currentCharMask) {
                needAppend = YES;
            }
            [returnText appendString:[NSString stringWithFormat:@"%c",currentCharMask]];
        }
        last = i;
    }

    for (int i = last+1; i < _mask.length; i++) {
        unichar currentCharMask = [_mask characterAtIndex:i];
        if (currentCharMask != '#') {
            [returnText appendString:[NSString stringWithFormat:@"%c",currentCharMask]];
        }
        if (currentCharMask == '#') {
            break;
        }
    }
    if (needAppend) {
        [returnText appendString:string];
    }
    self.text = returnText;
    return NO;
}

-(double) rawToDouble{
    return [_raw doubleValue];
}

-(float) rawToFloat{
    return [_raw floatValue];
}

-(NSInteger) rawToInteger{
    return [_raw intValue];
}

-(NSDate *)rawToDate:(NSDateFormatter *)formatter{
    NSDate *date = [formatter dateFromString:_raw];
    return date;
}

- (NSString *) rawString {
    return [self rawStringForString:self.text];
}

- (NSString *)rawStringForString:(NSString *)string {
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/:. -()"];
    return [[string componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
}

- (void)setTextWithMask:(NSString *) text {

    self.text = @"";

    NSString *stringToSetup = [self rawStringForString:text];

    if (!self.mask) {
        self.text = stringToSetup;
        return;
    }

    NSString *currentTextDigited = stringToSetup;

    NSMutableString * returnText = [[NSMutableString alloc] init];
    if (currentTextDigited.length > _mask.length) {
        return;
    }
    int last = 0;
    for (int i = 0; i < currentTextDigited.length; i++) {
        unichar  currentCharMask = [_mask characterAtIndex:i];
        unichar  currentChar = [currentTextDigited characterAtIndex:i];

        for (int index = last + i; index < _mask.length; index++) {
            unichar currentCharMask = [_mask characterAtIndex:index];
            if (currentCharMask != '#') {
                [returnText appendString:[NSString stringWithFormat:@"%c",currentCharMask]];
                last++;
            }
            if (currentCharMask == '#') {
                break;
            }
        }

        if (isnumber(currentChar) && currentCharMask == '#') {
            [returnText appendString:[NSString stringWithFormat:@"%c",currentChar]];
        } else {
            if (currentCharMask == '#') {
                break;
            }

            if (isnumber(currentChar) && currentChar != currentCharMask) {
                [returnText appendString:[NSString stringWithFormat:@"%c",currentChar]];
            }
        }
    }

    self.text = returnText;
}

@end
