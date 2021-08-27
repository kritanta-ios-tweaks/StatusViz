#include "CozyColor.h"

/*
    @property (nonatomic, assign) CGFloat h;
    @property (nonatomic, assign) CGFloat s;
    @property (nonatomic, assign) CGFloat v;
    @property (nonatomic, assign) CGFloat r;
    @property (nonatomic, assign) CGFloat g;
    @property (nonatomic, assign) CGFloat b;
    @property (nonatomic, assign) CGFloat a;
*/

@implementation CozyColor

- (instancetype)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    self = [super init];
    if (self)
    {
        self.r = red;
        self.g = green;
        self.b = blue;
        self.a = 1;
        UIColor *color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
        CGFloat hue, saturation, brightness, __alpha;
        [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&__alpha];
        self.h = hue;
        self.s = saturation;
        self.v = brightness;
    }
    return self;
}

- (UIColor *)getColor
{
    return [UIColor colorWithRed:self.r/255.0f green:self.g/255.0f blue:self.b/255.0f alpha:self.a];
}

@end