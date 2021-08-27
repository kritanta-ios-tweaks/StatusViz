//
//  CozySchema.m
//  libCozy
//
//  Analyze colors and create a palette from them.
//

#include "CozySchema.h"

//  A few methods that dont make sense for use outside of the 
//      analyzer. 
@interface CozySchema (ColorCalculations)

- (NSMutableDictionary *)colorsForImage:(UIImage *)image;

- (float)contrastValueFor:(CozyColor *)a andB:(CozyColor *)b;
- (float)saturationValueFor:(CozyColor *)a andB:(CozyColor *)b;
- (int)colourDistance:(CozyColor *)a andB:(CozyColor *)b;

@end


@implementation CozySchema

/*
//  Primary Label color, for song name
@property (nonatomic, retain) CozyColor *labelColor;
//  Darker secondary label color, for album/artist and time control colors
@property (nonatomic, retain) CozyColor *secondaryLabelColor;
//  Even darker label for unimportant things
@property (nonatomic, retain) CozyColor *tertiaryLabelColor;

//  Lightest, white-tinted color for larger controls and knobs
@property (nonatomic, retain) CozyColor *controlColor;
//  Darker secondary color for active slider portions and time controls
@property (nonatomic, retain) CozyColor *secondaryControlColor;
//  Near-background color for unactive (right side) slider portions
@property (nonatomic, retain) CozyColor *tertiaryControlColor;

//  Most contrasting color in the image
@property (nonatomic, retain) CozyColor *contrastColor;

//  Most Common color in the image
@property (nonatomic, retain) CozyColor *commonColor;

//  Generated background color
@property (nonatomic, retain) CozyColor *backgroundColor;
*/

+ (CozySchema *)generateFromImage:(UIImage *)image withOptions:(NSArray *)options
{
    CozySchema *schema = [CozySchema new];
    schema.options = options;
    NSMutableDictionary *generatedColors = [schema colorsForImage:image];
    schema.commonColor = generatedColors[@"primary"];
    schema.contrastColor = generatedColors[@"secondary"];
    schema.backgroundColor = generatedColors[@"background"];
    schema.darker = !(schema.backgroundColor.v >=0.6);
    if (([schema.options containsObject:@"preferCoolBackground"]))
    {
        if ([self coolnessForColor:schema.contrastColor] > [self coolnessForColor:schema.backgroundColor])
        {
            schema.backgroundColor = schema.contrastColor;
            schema.contrastColor = generatedColors[@"background"];
        }
    }
        
    if (([schema.options containsObject:@"alwaysLightForeground"]))
        schema.darker = YES;
    if (schema.darker)
    {
        schema.labelColor = schema.commonColor;
        while (schema.labelColor.v < 0.65)
        {
            schema.labelColor = [CozySchema lighterColorForColor:schema.labelColor byFraction:0.1];
        }
        schema.secondaryLabelColor = [CozySchema darkerColorForColor:schema.labelColor byFraction:0.1];
        schema.tertiaryLabelColor = [CozySchema darkerColorForColor:schema.secondaryLabelColor byFraction:0.1];
        schema.controlColor = schema.contrastColor;
        while (schema.controlColor.v < 0.85)
        {
            schema.controlColor = [CozySchema lighterColorForColor:schema.controlColor byFraction:0.1];
        }
        schema.secondaryControlColor = [CozySchema darkerColorForColor:schema.controlColor byFraction:0.05];
        schema.tertiaryControlColor = [CozySchema darkerColorForColor:schema.secondaryControlColor byFraction:0.1];
    }
    else 
    {
        schema.labelColor = schema.commonColor;
        schema.secondaryLabelColor = [CozySchema lighterColorForColor:schema.labelColor byFraction:0.1];
        schema.tertiaryLabelColor = [CozySchema lighterColorForColor:schema.secondaryLabelColor byFraction:0.1];
        schema.controlColor = schema.contrastColor;
        schema.secondaryControlColor = [CozySchema lighterColorForColor:schema.controlColor byFraction:0.1];
        schema.tertiaryControlColor = [CozySchema lighterColorForColor:schema.secondaryControlColor byFraction:0.1];
    }
    if (([schema.options containsObject:@"darkenBackgroundTillReadable"]))
    {
        while (schema.backgroundColor.v > 0.6 || (schema.backgroundColor.s >0.7 && schema.backgroundColor.v > 0.8) )
        {
            schema.backgroundColor = [CozySchema darkerColorForColor:schema.backgroundColor byFraction:0.5];
        }
    }
    return schema;
}

- (NSMutableDictionary *)colorsForImage:(UIImage *)image {

    BOOL backgroundFoundWasGreyscale = NO;
    BOOL primaryFoundWasGreyscale = NO;
    BOOL secondaryFoundWasGreyscale = NO;

    //1. set vars
    float dimension = 20;

    //2. resize image and grab raw data
    //this part pulls the raw data from the image
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(dimension * dimension * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * dimension;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, dimension, dimension, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, dimension, dimension), imageRef);
    CGContextRelease(context);

    //3. create colour array
    NSMutableArray * colours;
    float x = 0, y = 0; //used to set coordinates
    float eR = 0, eB = 0, eG = 0; //used for mean edge colour

    CozyColor *e;
    if (!([self.options containsObject:@"dumbest"]))
    {
        for (int edge = 0; edge < 4; edge++)
        {
            colours = [NSMutableArray new];
            for (int n = 0; n<(dimension*dimension); n++)
            {
                int i = (bytesPerRow * y) + x * bytesPerPixel; //pull index
                CozyColor * c = [[CozyColor alloc] initWithRed:rawData[i] green:rawData[i + 1] blue:rawData[i + 2]]; //create colour
                [colours addObject:c]; //add colour

                if ((edge == 0 && y == 0) || //top
                    (edge == 1 && x == 0) || //left
                    (edge == 2 && y == dimension-1) || //bottom
                    (edge == 3 && x == dimension-1)) //right
                {
                    eR+=c.r; eG+=c.g; eB+=c.b;
                }

                x = (x == dimension - 1) ? 0 : x+1;
                y = (x == 0) ? y+1 : y;
            }

            e = [[CozyColor alloc] initWithRed:eR/dimension green:eG/dimension blue:eB/dimension];
            if (![self saturationIsTooLow:e] || ([self.options containsObject:@"dumber"]))
            {
                break;
            }
            else 
            {
                if (edge == 3)
                {
                    backgroundFoundWasGreyscale = YES;
                    break;
                }
            }
        }
    }
    free(rawData);

    //5. calculate the frequency of colour
    NSMutableArray * accents = [NSMutableArray new]; //holds valid accents

    float minContrast = 3.1; //play with this value
    while (accents.count < 3) { //minimum number of accents
        for (CozyColor * a in colours){

            //5.1 ignore if it does not contrast with edge
            if ([self contrastValueFor:a andB:e] < minContrast){ continue;}

            //5.2 set distance (frequency)
            for (CozyColor * b in colours){
                a.d += [self colourDistance:a andB:b];
            }

            //5.3 add colour to accents
            [accents addObject:a];
        }

        minContrast-=0.1f;
    }

    //6. sort colours by the most common
    NSArray * sorted = [[NSArray arrayWithArray:accents] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"d" ascending:true]]];

    //6.1 set primary colour (most common)
    CozyColor * p = sorted[0];
    
    if (([self.options containsObject:@"dumbest"]))
    {
        NSMutableDictionary * aresult = [NSMutableDictionary new];
        [aresult setValue:[p getColor] forKey:@"background"];
        [aresult setValue:[p getColor] forKey:@"primary"];
        [aresult setValue:[p getColor] forKey:@"secondary"]; 
        return aresult;
    }

    //7. get most contrasting colour
    float high = 0.0f; //the high
    int index = 0; //the index
    for (int n = 1; n < sorted.count; n++){

        CozyColor * c = sorted[n];
        float contrast = [self contrastValueFor:c andB:p];
        //float sat = [self saturationValueFor:c andB:p];

        if (contrast > high){
            high = contrast;
            index = n;
        }
    }
    //7.1 set secondary colour (most contrasting)
    CozyColor * s = sorted[index];

    primaryFoundWasGreyscale = [self saturationIsTooLow:p];
    secondaryFoundWasGreyscale = [self saturationIsTooLow:s];

    char cx = 7;
    char ca = backgroundFoundWasGreyscale?4:0;
    char cb = primaryFoundWasGreyscale?2:0;
    char cc = secondaryFoundWasGreyscale?1:0;
    cx = cx - ca;
    cx = cx - cb;
    cx = cx - cc;

    self.foundColors = cx;

    if ([self.options containsObject:@"noFallbackGeneration"] || ([self.options containsObject:@"dumber"]) || ([self.options containsObject:@"dumb"]))
        cx = 7;

    if (cx == 0) 
    {   // No colors were found, so use edge color and make p/s from that. 
        while ([self brightnessIsTooLow:e])
        {
            e = [CozySchema lighterColorForColor:e byFraction:0.1];
        }
        if (e.v>=0.6)
        {
            p = [CozySchema darkerColorForColor:e byFraction:0.45];
            s = [CozySchema darkerColorForColor:e byFraction:0.35];
        }
        else 
        {
            if (e.v>=0.5)
            {
                e = [CozySchema darkerColorForColor:e byFraction:0.1];
            }
            p = [CozySchema lighterColorForColor:e byFraction:0.45];
            s = [CozySchema lighterColorForColor:e byFraction:0.35];
        }
    }
    else if (cx == 1)
    {   // Only secondary was found, so use primary as background and set the rest from that
        e = s;
        while ([self brightnessIsTooLow:e])
        {
            e = [CozySchema lighterColorForColor:e byFraction:0.1];
        }
        if (e.v<0.6)
        {
            p = [CozySchema darkerColorForColor:e byFraction:0.45];
            s = [CozySchema darkerColorForColor:e byFraction:0.35];
        }
        else 
        {
            if (e.v>=0.5)
            {
                e = [CozySchema darkerColorForColor:e byFraction:0.1];
            }
            p = [CozySchema lighterColorForColor:e byFraction:0.45];
            s = [CozySchema lighterColorForColor:e byFraction:0.35];
        }
    }
    else if (cx == 2)
    {   // just primary
        e = p;
        while ([self brightnessIsTooLow:e])
        {
            e = [CozySchema lighterColorForColor:e byFraction:0.1];
        }
        if (e.v<0.6)
        {
            p = [CozySchema darkerColorForColor:e byFraction:0.45];
            s = [CozySchema darkerColorForColor:e byFraction:0.35];
        }
        else 
        {
            if (e.v>=0.5)
            {
                e = [CozySchema darkerColorForColor:e byFraction:0.1];
            }
            p = [CozySchema lighterColorForColor:e byFraction:0.45];
            s = [CozySchema lighterColorForColor:e byFraction:0.35];
        }
    }
    else if (cx == 3)
    {   // no bg
        e = s;
        while ([self brightnessIsTooLow:e])
        {
            e = [CozySchema lighterColorForColor:e byFraction:0.1];
        }
        if (e.v<0.6)
        {
            s = [CozySchema darkerColorForColor:p byFraction:0.35];
        }
        else 
        {
            if (e.v>=0.5)
            {
                e = [CozySchema darkerColorForColor:e byFraction:0.1];
            }
            s = [CozySchema lighterColorForColor:p byFraction:0.35];
        }
    }
    else if (cx == 4)
    {   // only bg
        while ([self brightnessIsTooLow:e])
        {
            e = [CozySchema lighterColorForColor:e byFraction:0.1];
        }
        if (e.v>=0.6)
        {
            p = [CozySchema darkerColorForColor:e byFraction:0.45];
            s = [CozySchema darkerColorForColor:e byFraction:0.35];
        }
        else 
        {
            if (e.v>=0.5)
            {
                e = [CozySchema darkerColorForColor:e byFraction:0.1];
            }
            p = [CozySchema lighterColorForColor:e byFraction:0.45];
            s = [CozySchema lighterColorForColor:e byFraction:0.35];
        }
    }
    else if (cx == 5)
    {   // bg and secondary found
        while ([self brightnessIsTooLow:e])
        {
            e = [CozySchema lighterColorForColor:e byFraction:0.1];
        }
        if (e.v>=0.6)
        {
            p = [CozySchema darkerColorForColor:s byFraction:0.45];
            s = [CozySchema darkerColorForColor:s byFraction:0.35];
        }
        else 
        {
            if (e.v>=0.5)
            {
                e = [CozySchema darkerColorForColor:e byFraction:0.1];
            }
            p = [CozySchema lighterColorForColor:s byFraction:0.45];
            s = [CozySchema lighterColorForColor:s byFraction:0.35];
        }
    }
    else if (cx == 6)
    {
        while ([self brightnessIsTooLow:e])
        {
            e = [CozySchema lighterColorForColor:e byFraction:0.1];
        }
        if (e.v>=0.66)
        {
            p = [CozySchema darkerColorForColor:p byFraction:0.45];
            s = [CozySchema darkerColorForColor:p byFraction:0.35];
        }
        else 
        {
            if (e.v>=0.5)
            {
                e = [CozySchema darkerColorForColor:e byFraction:0.1];
            }
            p = [CozySchema lighterColorForColor:p byFraction:0.45];
            s = [CozySchema lighterColorForColor:p byFraction:0.35];
        }
    }
    else 
    {   // Successfully got all of our colors!!
        while ([self brightnessIsTooLow:e])
        {
            e = [CozySchema lighterColorForColor:e byFraction:0.1];
        }
    }

    self.foundColors = cx;

    NSMutableDictionary * result = [NSMutableDictionary new];
    [result setValue:e forKey:@"background"];
    [result setValue:p forKey:@"primary"];
    [result setValue:s forKey:@"secondary"]; 

    return result;

}

-(float)contrastValueFor:(CozyColor *)a andB:(CozyColor *)b 
{
    float aL = 0.2126 * a.r + 0.7152 * a.g + 0.0722 * a.b;
    float bL = 0.2126 * b.r + 0.7152 * b.g + 0.0722 * b.b;
    return (aL>bL) ? (aL + 0.05) / (bL + 0.05) : (bL + 0.05) / (aL + 0.05);
}

-(float)saturationValueFor:(CozyColor *)a andB:(CozyColor *)b 
{
    float min = MIN(a.r, MIN(a.g, a.b)); //grab min
    float max = MAX(b.r, MAX(b.g, b.b)); //grab max
    return (max - min)/max;
}

-(int)colourDistance:(CozyColor *)a andB:(CozyColor *)b 
{
    return fabs(a.r-b.r)+fabs(a.g-b.g)+fabs(a.b-b.b);
}

+ (CGFloat)coolnessForColor:(CozyColor *)a
{
    return (1 - (ABS(180 - a.h) / 180));
}

// Color needs to be a bit brighter
- (BOOL)brightnessIsTooLow:(CozyColor *)color
{
    return ([self.options containsObject:@"fullBlack"]) ? NO : color.v < 0.10;
}

// Avoid greyscale
- (BOOL)saturationIsTooLow:(CozyColor *)color
{
	return color.s < 0.1;
}

+ (CozyColor *)lighterColorForColor:(CozyColor *)c byFraction:(CGFloat)frac
{
    CGFloat r, g, b;
    r = c.r/255;
    g = c.g/255;
    b = c.b/255;
    return [[CozyColor alloc] initWithRed:(r+frac)*255
                            green:(g+frac)*255
                            blue:(b+frac)*255];
}

+ (CozyColor *)darkerColorForColor:(CozyColor *)c byFraction:(CGFloat)frac
{
    CGFloat r, g, b;
    r = c.r/255;
    g = c.g/255;
    b = c.b/255;
    return [[CozyColor alloc] initWithRed:(r-frac)*255
                            green:(g-frac)*255
                            blue:(b-frac)*255];
}

@end