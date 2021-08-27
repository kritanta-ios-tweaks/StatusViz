#import <UIKit/UIKit.h>
#import "MSHView.h"
#import "MSHJelloLayer.h"

@interface MSHSiriView : MSHView

@property (nonatomic, strong) MSHJelloLayer *redWaveLayer;
@property (nonatomic, strong) MSHJelloLayer *greenWaveLayer;
@property (nonatomic, strong) MSHJelloLayer *blueWaveLayer;

@property (nonatomic, strong) UIColor *redWaveColor;
@property (nonatomic, strong) UIColor *greenWaveColor;
@property (nonatomic, strong) UIColor *blueWaveColor;

-(void)updateRedWaveColor:(UIColor *)redWaveColor greenWaveColor:(UIColor *)greenWaveColor blueWaveColor:(UIColor *)blueWaveColor;

-(CGPathRef)createPathWithPoints:(CGPoint *)points pointCount:(NSUInteger)pointCount inRect:(CGRect)rect;

@end
