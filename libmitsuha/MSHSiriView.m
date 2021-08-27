#import "public/MSHSiriView.h"

static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {
  return CGPointMake((p1.x + p2.x) / 2 , (p1.y + p2.y) / 2);
}

static CGPoint controlPointForPoints(CGPoint p1, CGPoint p2) {
  CGPoint controlPoint = midPointForPoints(p1, p2);
  CGFloat diffy = fabs(p2.y - controlPoint.y);

  if (p1.y < p2.y)
    controlPoint.y += diffy;
  else if (p1.y > p2.y)
    controlPoint.y -= diffy;

  return controlPoint;
}

@implementation MSHSiriView

-(void)initializeWaveLayers {
  self.redWaveLayer = [MSHJelloLayer layer];
  self.greenWaveLayer = [MSHJelloLayer layer];
  self.blueWaveLayer = [MSHJelloLayer layer];

  self.redWaveLayer.frame = self.greenWaveLayer.frame = self.blueWaveLayer.frame = self.bounds;

  [self.layer addSublayer:self.redWaveLayer];
  [self.layer addSublayer:self.greenWaveLayer];
  [self.layer addSublayer:self.blueWaveLayer];

  self.redWaveLayer.zPosition = 0;
  self.greenWaveLayer.zPosition = -1;
  self.blueWaveLayer.zPosition = -2;

  [self configureDisplayLink];
  [self resetWaveLayers];

  self.redWaveLayer.shouldAnimate = true;
  self.greenWaveLayer.shouldAnimate = true;
  self.blueWaveLayer.shouldAnimate = true;
}

-(void)resetWaveLayers {
  if (!self.redWaveLayer || !self.greenWaveLayer || !self.blueWaveLayer) {
    [self initializeWaveLayers];
  }

  CGPathRef path = [self createPathWithPoints:self.points pointCount:0 inRect: self.bounds];

  NSLog(@"[libmitsuha]: Reseting Wave Layers...");

  self.redWaveLayer.path = path;
  self.greenWaveLayer.path = path;
  self.blueWaveLayer.path = path;
}

-(void)updateRedWaveColor:(UIColor *)redWaveColor greenWaveColor:(UIColor *)greenWaveColor blueWaveColor:(UIColor *)blueWaveColor {
  redWaveColor = [UIColor colorWithRed:173/255.0f green:57/255.0f blue:76/255.0f alpha:1.0f];
  greenWaveColor = [UIColor colorWithRed:48/255.0f green:220/225.0f blue:155/255.0f alpha:1.0f];
  blueWaveColor = [UIColor colorWithRed:15/255.0f green:82/255.0f blue:169/255.0f alpha:1.0f];

  self.redWaveColor = redWaveColor;
  self.greenWaveColor = greenWaveColor;
  self.blueWaveColor = blueWaveColor;
  self.redWaveLayer.fillColor = redWaveColor.CGColor;
  self.greenWaveLayer.fillColor = greenWaveColor.CGColor;
  self.blueWaveLayer.fillColor = blueWaveColor.CGColor;
}

-(void)redraw {
  [super redraw];

  CGPathRef path = [self createPathWithPoints:self.points pointCount:self.numberOfPoints inRect:self.bounds];
  self.redWaveLayer.path = path;

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.greenWaveLayer.path = path;
  });

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.blueWaveLayer.path = path;
    CGPathRelease(path);
  });
}

-(void)setSampleData:(float *)data length:(int)length {
  [super setSampleData:data length:length];

  self.points[self.numberOfPoints - 1].x = self.bounds.size.width;
  self.points[0].y = self.points[self.numberOfPoints - 1].y = self.waveOffset;
}

-(CGPathRef)createPathWithPoints:(CGPoint *)points pointCount:(NSUInteger)pointCount inRect:(CGRect)rect {
  UIBezierPath *path;

  if (pointCount > 0) {
    path = [UIBezierPath bezierPath];

    [path moveToPoint:CGPointMake(0, self.frame.size.height)];

    CGPoint p1 = self.points[0];

    [path addLineToPoint:p1];

    for (int i = 0; i < self.numberOfPoints; i++) {
      CGPoint p2 = self.points[i];
      CGPoint midPoint = midPointForPoints(p1, p2);

      [path addQuadCurveToPoint:midPoint controlPoint:controlPointForPoints(midPoint, p1)];
      [path addQuadCurveToPoint:p2 controlPoint:controlPointForPoints(midPoint, p2)];

      p1 = self.points[i];
    }

    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
  } else {
    float pixelFixer = self.bounds.size.width/self.numberOfPoints;

    if (cachedNumberOfPoints != self.numberOfPoints) {
      self.points = (CGPoint *)malloc(sizeof(CGPoint) * self.numberOfPoints);
      cachedNumberOfPoints = self.numberOfPoints;

      for (int i = 0; i < self.numberOfPoints; i++) {
        self.points[i].x = i*pixelFixer;
        self.points[i].y = self.waveOffset;
      }

      self.points[self.numberOfPoints - 1].x = self.bounds.size.width;
      self.points[0].y = self.points[self.numberOfPoints - 1].y = self.waveOffset;
    }

    return [self createPathWithPoints:self.points pointCount:self.numberOfPoints inRect:self.bounds];
  }

  CGPathRef convertedPath = path.CGPath;

  return CGPathCreateCopy(convertedPath);
}

@end
