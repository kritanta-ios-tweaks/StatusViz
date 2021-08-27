#include "CozyAnalyzer.h"

@implementation CozyAnalyzer

+ (CozySchema *)schemaForImage:(UIImage *)image withOptions:(NSArray *)options
{
    return [CozySchema generateFromImage:image withOptions:options];
}

@end