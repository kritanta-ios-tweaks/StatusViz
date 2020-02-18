#line 1 "StatusViz.xm"










#include "StatusViz.h"
#include <Cozy/Cozy.h>

static BOOL hideTime;
static UIView *global_UIStatusBarForegroundView;
static NSMutableArray *globalLeftAreas;
static NSMutableArray *globalTimes;
static NSMutableArray *globalFrontBarViews;
static NSMutableArray *globalBackBarViews;
static NSMutableArray *globalFGBarViews;
static CGFloat sensi = 3;
NSDictionary *prefs = nil;


static MPUNowPlayingController *globalMPUNowPlaying;

void updateBackwaves()
{
	NSArray *options = @[ @"fullBlack", @"alwaysLightForeground", @"darkenBackgroundTillReadable", @"preferCoolBackground"];
	CozySchema *schema = [CozyAnalyzer schemaForImage:[globalMPUNowPlaying currentNowPlayingArtwork] withOptions:options];
	CozyColor *f = [schema tertiaryControlColor];
	CozyColor *b = [schema tertiaryLabelColor];
	if (b.v > f.v)
	{
		b = [schema tertiaryControlColor];
		f = [schema tertiaryLabelColor];
	}
	for (MSHBarView *bar in globalFrontBarViews)
	{
		[bar updateWaveColor:[f getColor] subwaveColor:[UIColor grayColor]];
	}
	for (MSHBarView *bar in globalBackBarViews)
	{
		[bar updateWaveColor:[b getColor] subwaveColor:[UIColor grayColor]];
	}
}
@interface _UIStatusBarRegion : NSObject 
@property (nonatomic, retain) NSMutableIndexSet *disablingTokens;
@end

void hideLeftStatusBarRegions()
{
	for (_UIStatusBarRegion *thing in globalLeftAreas)
	{
		[thing.disablingTokens addIndex:0];
	}
	for (_UIStatusBarStringView *v in globalTimes)
	{
		
	if ([v.text containsString:@":"])
	{
		v.textColor = [UIColor clearColor];
	}
	}
}
void showLeftStatusBarRegions()
{
	for (_UIStatusBarRegion *thing in globalLeftAreas)
	{
		[thing.disablingTokens removeIndex:0];
	}
	for (_UIStatusBarStringView *v in globalTimes)
	{if ([v.text containsString:@":"])
	{
		v.textColor = [UIColor whiteColor];
	}
	}
}


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class MSHBarView; @class _UIStatusBarImageView; @class SpringBoard; @class _UIStatusBarForegroundView; @class MPUNowPlayingController; @class _UIStatusBar; @class SBMediaController; @class _UIStatusBarStringView; 
static void (*_logos_orig$_ungrouped$_UIStatusBarForegroundView$willMoveToSuperview$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST, SEL, UIView *); static void _logos_method$_ungrouped$_UIStatusBarForegroundView$willMoveToSuperview$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST, SEL, UIView *); static void (*_logos_orig$_ungrouped$_UIStatusBarForegroundView$dealloc)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$_UIStatusBarForegroundView$dealloc(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$MSHBarView$setAlpha$)(_LOGOS_SELF_TYPE_NORMAL MSHBarView* _LOGOS_SELF_CONST, SEL, CGFloat); static void _logos_method$_ungrouped$MSHBarView$setAlpha$(_LOGOS_SELF_TYPE_NORMAL MSHBarView* _LOGOS_SELF_CONST, SEL, CGFloat); static void (*_logos_orig$_ungrouped$_UIStatusBarStringView$setText$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, NSString*); static void _logos_method$_ungrouped$_UIStatusBarStringView$setText$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, NSString*); static BOOL (*_logos_orig$_ungrouped$_UIStatusBarStringView$isHidden)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$_UIStatusBarStringView$isHidden(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL); static CGFloat (*_logos_orig$_ungrouped$_UIStatusBarStringView$alpha)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL); static CGFloat _logos_method$_ungrouped$_UIStatusBarStringView$alpha(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$_UIStatusBarStringView$setAlpha$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, CGFloat); static void _logos_method$_ungrouped$_UIStatusBarStringView$setAlpha$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, CGFloat); static void (*_logos_orig$_ungrouped$SBMediaController$_nowPlayingInfoChanged)(_LOGOS_SELF_TYPE_NORMAL SBMediaController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBMediaController$_nowPlayingInfoChanged(_LOGOS_SELF_TYPE_NORMAL SBMediaController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBMediaController$_mediaRemoteNowPlayingInfoDidChange$)(_LOGOS_SELF_TYPE_NORMAL SBMediaController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBMediaController$_mediaRemoteNowPlayingInfoDidChange$(_LOGOS_SELF_TYPE_NORMAL SBMediaController* _LOGOS_SELF_CONST, SEL, id); static MPUNowPlayingController* (*_logos_orig$_ungrouped$MPUNowPlayingController$init)(_LOGOS_SELF_TYPE_NORMAL MPUNowPlayingController* _LOGOS_SELF_CONST, SEL); static MPUNowPlayingController* _logos_method$_ungrouped$MPUNowPlayingController$init(_LOGOS_SELF_TYPE_NORMAL MPUNowPlayingController* _LOGOS_SELF_CONST, SEL); static MPUNowPlayingController* _logos_meta_method$_ungrouped$MPUNowPlayingController$_current_MPUNowPlayingController(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static UIImage* _logos_method$_ungrouped$MPUNowPlayingController$currentNowPlayingArtwork(_LOGOS_SELF_TYPE_NORMAL MPUNowPlayingController* _LOGOS_SELF_CONST, SEL); static NSDictionary * (*_logos_orig$_ungrouped$_UIStatusBar$regions)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBar* _LOGOS_SELF_CONST, SEL); static NSDictionary * _logos_method$_ungrouped$_UIStatusBar$regions(_LOGOS_SELF_TYPE_NORMAL _UIStatusBar* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$_UIStatusBarImageView$isHidden)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarImageView* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$_UIStatusBarImageView$isHidden(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarImageView* _LOGOS_SELF_CONST, SEL); static CGFloat (*_logos_orig$_ungrouped$_UIStatusBarImageView$alpha)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarImageView* _LOGOS_SELF_CONST, SEL); static CGFloat _logos_method$_ungrouped$_UIStatusBarImageView$alpha(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarImageView* _LOGOS_SELF_CONST, SEL); static SpringBoard* (*_logos_orig$_ungrouped$SpringBoard$init)(_LOGOS_SELF_TYPE_INIT SpringBoard*, SEL) _LOGOS_RETURN_RETAINED; static SpringBoard* _logos_method$_ungrouped$SpringBoard$init(_LOGOS_SELF_TYPE_INIT SpringBoard*, SEL) _LOGOS_RETURN_RETAINED; 

#line 80 "StatusViz.xm"
 

__attribute__((used)) static BOOL _logos_method$_ungrouped$_UIStatusBarForegroundView$kek(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$kek); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$_UIStatusBarForegroundView$setKek(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$kek, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static MSHBarView * _logos_method$_ungrouped$_UIStatusBarForegroundView$mshView(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd) { return (MSHBarView *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$mshView); }; __attribute__((used)) static void _logos_method$_ungrouped$_UIStatusBarForegroundView$setMshView(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd, MSHBarView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$mshView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static MSHBarView * _logos_method$_ungrouped$_UIStatusBarForegroundView$mshShitHackView(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd) { return (MSHBarView *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$mshShitHackView); }; __attribute__((used)) static void _logos_method$_ungrouped$_UIStatusBarForegroundView$setMshShitHackView(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd, MSHBarView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$mshShitHackView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static MSHBarView * _logos_method$_ungrouped$_UIStatusBarForegroundView$mshBackView(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd) { return (MSHBarView *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$mshBackView); }; __attribute__((used)) static void _logos_method$_ungrouped$_UIStatusBarForegroundView$setMshBackView(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd, MSHBarView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$mshBackView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static MSHBarView * _logos_method$_ungrouped$_UIStatusBarForegroundView$mshBackTwoView(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd) { return (MSHBarView *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$mshBackTwoView); }; __attribute__((used)) static void _logos_method$_ungrouped$_UIStatusBarForegroundView$setMshBackTwoView(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd, MSHBarView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$mshBackTwoView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }


static void _logos_method$_ungrouped$_UIStatusBarForegroundView$willMoveToSuperview$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIView * newSuperview) {
	_logos_orig$_ungrouped$_UIStatusBarForegroundView$willMoveToSuperview$(self, _cmd, newSuperview);
	if (((Its3AMAndIAmCravingTacoBell*)(newSuperview)).mode!=0) return;
	if (((Its3AMAndIAmCravingTacoBell*)(newSuperview)).superview.frame.origin.x+((Its3AMAndIAmCravingTacoBell*)(newSuperview)).superview.frame.origin.y!=0)return;
	if([((Its3AMAndIAmCravingTacoBell*)(newSuperview)).superview.superview.description containsString:@"CCUI"])return;
	if (self.kek)return;
	global_UIStatusBarForegroundView = self;


	self.mshView = [[MSHBarView alloc] initWithFrame:CGRectMake(20,0,50,30)];
	[(MSHBarView*)self.mshView setBarSpacing:4];
	[(MSHBarView*)self.mshView  setBarCornerRadius:2];

	self.mshView.autoHide = YES;
	self.mshView.displayLink.preferredFramesPerSecond = 24;
	self.mshView.numberOfPoints = 6;
	self.mshView.waveOffset = 26;
	self.mshView.gain = 10;
	self.mshView.limiter = 8;
	self.mshView.sensitivity = 0.5*sensi;
	self.mshView.audioProcessing.fft = YES;
	self.mshView.disableBatterySaver = NO;
	[self.mshView updateWaveColor:[UIColor whiteColor] subwaveColor:[UIColor whiteColor]];


	self.mshView.clipsToBounds=YES;

	
	
	self.mshShitHackView = [[MSHBarView alloc] initWithFrame:CGRectMake(20,0,50,30)];
	[(MSHBarView*)self.mshShitHackView setBarSpacing:4];
	[(MSHBarView*)self.mshShitHackView  setBarCornerRadius:2];

	self.mshShitHackView.autoHide = YES;
	self.mshShitHackView.displayLink.preferredFramesPerSecond = 24;
	self.mshShitHackView.numberOfPoints = 6;
	self.mshShitHackView.waveOffset = 26;
	self.mshShitHackView.gain = 0;
	self.mshShitHackView.limiter = 8;
	self.mshShitHackView.sensitivity = 0;
	self.mshShitHackView.audioProcessing.fft = YES;
	self.mshShitHackView.disableBatterySaver = NO;
	[self.mshShitHackView updateWaveColor:[UIColor whiteColor] subwaveColor:[UIColor whiteColor]];

	self.mshShitHackView.clipsToBounds=YES;


	self.mshBackView = [[MSHBarView alloc] initWithFrame:CGRectMake(20,0,50,30)];
	[(MSHBarView*)self.mshBackView setBarSpacing:4];
	[(MSHBarView*)self.mshBackView  setBarCornerRadius:2];

	self.mshBackView.autoHide = YES;
	self.mshBackView.displayLink.preferredFramesPerSecond = 24;
	self.mshBackView.numberOfPoints = 6;
	self.mshBackView.waveOffset = 26;
	self.mshBackView.gain = 10;
	self.mshBackView.limiter = 8;
	self.mshBackView.sensitivity = .75*sensi;
	self.mshBackView.audioProcessing.fft = YES;
	self.mshBackView.disableBatterySaver = NO;
	[self.mshBackView updateWaveColor:[UIColor grayColor] subwaveColor:[UIColor grayColor]];

	self.mshBackView.clipsToBounds=YES;

	self.mshBackTwoView = [[MSHBarView alloc] initWithFrame:CGRectMake(20,0,50,30)];
	[(MSHBarView*)self.mshBackTwoView setBarSpacing:4];
	[(MSHBarView*)self.mshBackTwoView  setBarCornerRadius:2];

	self.mshBackTwoView.autoHide = YES;
	self.mshBackTwoView.displayLink.preferredFramesPerSecond = 24;
	self.mshBackTwoView.numberOfPoints = 6;
	self.mshBackTwoView.waveOffset = 26;
	self.mshBackTwoView.gain = 10;
	self.mshBackTwoView.limiter = 8;
	self.mshBackTwoView.sensitivity = sensi;
	self.mshBackTwoView.audioProcessing.fft = YES;
	self.mshBackTwoView.disableBatterySaver = NO;
	[self.mshBackTwoView updateWaveColor:[UIColor grayColor] subwaveColor:[UIColor grayColor]];

	self.mshBackTwoView.clipsToBounds=YES;

	[globalFrontBarViews addObject:self.mshBackView];
	[globalBackBarViews addObject:self.mshBackTwoView];
	[globalFGBarViews addObject:self.mshView];
	[self addSubview:self.mshBackTwoView];
	[self addSubview:self.mshBackView];
	[self addSubview:self.mshView];
	[self addSubview:self.mshShitHackView];
	[self.mshView start];
	[self.mshBackView start];
	[self.mshBackTwoView start];
	[self.mshShitHackView start];
	self.kek=YES;
}


static void _logos_method$_ungrouped$_UIStatusBarForegroundView$dealloc(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd)  {
	[globalFrontBarViews removeObject:self.mshBackView];
	[globalFGBarViews removeObject:self.mshView];
	[globalBackBarViews removeObject:self.mshBackTwoView];
	[self.mshView stop];
	[self.mshBackView stop];
	[self.mshBackTwoView stop];
	[self.mshShitHackView stop];
	hideLeftStatusBarRegions();
	_logos_orig$_ungrouped$_UIStatusBarForegroundView$dealloc(self, _cmd);
}





static void _logos_method$_ungrouped$MSHBarView$setAlpha$(_LOGOS_SELF_TYPE_NORMAL MSHBarView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGFloat alpha)  {
	_logos_orig$_ungrouped$MSHBarView$setAlpha$(self, _cmd, alpha);
	if (alpha < 1)
	{
		hideTime = NO;
		for (UIView *v in globalTimes)
		{
			v.hidden = NO;
		}
		showLeftStatusBarRegions();
	}
	else {
		hideTime = YES;
		for (UIView *v in globalTimes)
		{
			v.hidden = YES;
		}
		hideLeftStatusBarRegions();
	}
}














static void _logos_method$_ungrouped$_UIStatusBarStringView$setText$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* set) {
	_logos_orig$_ungrouped$_UIStatusBarStringView$setText$(self, _cmd, set);
	[globalTimes addObject:self];
}

static BOOL _logos_method$_ungrouped$_UIStatusBarStringView$isHidden(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	return [self.text containsString:@":"] ? hideTime : _logos_orig$_ungrouped$_UIStatusBarStringView$isHidden(self, _cmd);
}


static CGFloat _logos_method$_ungrouped$_UIStatusBarStringView$alpha(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd)  {
	return [self.text containsString:@":"] ? (hideTime ? 0 : _logos_orig$_ungrouped$_UIStatusBarStringView$alpha(self, _cmd)) : _logos_orig$_ungrouped$_UIStatusBarStringView$alpha(self, _cmd);
}

static void _logos_method$_ungrouped$_UIStatusBarStringView$setAlpha$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGFloat alpha)  {
	_logos_orig$_ungrouped$_UIStatusBarStringView$setAlpha$(self, _cmd, [self.text containsString:@":"] ? (hideTime ? 0 : alpha) : alpha);
}


 


static void _logos_method$_ungrouped$SBMediaController$_nowPlayingInfoChanged(_LOGOS_SELF_TYPE_NORMAL SBMediaController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd)  {
    _logos_orig$_ungrouped$SBMediaController$_nowPlayingInfoChanged(self, _cmd);
	dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
	dispatch_after(delay, dispatch_get_main_queue(), ^(void){
		updateBackwaves();
	});
}



static void _logos_method$_ungrouped$SBMediaController$_mediaRemoteNowPlayingInfoDidChange$(_LOGOS_SELF_TYPE_NORMAL SBMediaController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    _logos_orig$_ungrouped$SBMediaController$_mediaRemoteNowPlayingInfoDidChange$(self, _cmd, arg1);

	dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
	dispatch_after(delay, dispatch_get_main_queue(), ^(void){
		updateBackwaves();
	});
}








static MPUNowPlayingController* _logos_method$_ungrouped$MPUNowPlayingController$init(_LOGOS_SELF_TYPE_NORMAL MPUNowPlayingController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    id orig = _logos_orig$_ungrouped$MPUNowPlayingController$init(self, _cmd);
    
    if (orig) {
        globalMPUNowPlaying = orig;
    }
    return orig;
}




static MPUNowPlayingController* _logos_meta_method$_ungrouped$MPUNowPlayingController$_current_MPUNowPlayingController(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return globalMPUNowPlaying;
}


 

static UIImage* _logos_method$_ungrouped$MPUNowPlayingController$currentNowPlayingArtwork(_LOGOS_SELF_TYPE_NORMAL MPUNowPlayingController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (!globalMPUNowPlaying){
        MPUNowPlayingController *nowPlayingController = [[objc_getClass("MPUNowPlayingController") alloc] init];
        [nowPlayingController startUpdating];
        return [nowPlayingController currentNowPlayingArtwork];
    }
    return [globalMPUNowPlaying currentNowPlayingArtwork];
}





static void *observer = NULL;

static void reloadPrefs() 
{
    if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) 
    {
        CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

        if (keyList) 
        {
            prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

            if (!prefs) 
            {
                prefs = [NSDictionary new];
            }
            CFRelease(keyList);
        }
    } 
    else 
    {
        prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
    }
}

 


static NSDictionary * _logos_method$_ungrouped$_UIStatusBar$regions(_LOGOS_SELF_TYPE_NORMAL _UIStatusBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd)  {
	NSDictionary *regions = _logos_orig$_ungrouped$_UIStatusBar$regions(self, _cmd);
	if (![globalLeftAreas containsObject:self]) 
	{
		[globalLeftAreas addObject:regions[@"leading"]];
	}
	return _logos_orig$_ungrouped$_UIStatusBar$regions(self, _cmd);
}



static void preferencesChanged() 
{
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();

    sensi = [prefs objectForKey:@"sensitivity"] ? [[prefs valueForKey:@"sensitivity"] floatValue] : 3;
	sensi = sensi/3;
	for (MSHBarView *bar in globalFrontBarViews)
	{
		bar.sensitivity = .75*sensi;
	}
	for (MSHBarView *bar in globalBackBarViews)
	{
		bar.sensitivity = sensi;
	}
	for (MSHBarView *bar in globalFGBarViews)
	{
		bar.sensitivity = .65*sensi;
	}
}
@interface  _UIStatusBarImageView : UIView
@end
 


static BOOL _logos_method$_ungrouped$_UIStatusBarImageView$isHidden(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarImageView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	return (self.frame.origin.y < 100) ? hideTime : _logos_orig$_ungrouped$_UIStatusBarImageView$isHidden(self, _cmd);
}

static CGFloat _logos_method$_ungrouped$_UIStatusBarImageView$alpha(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarImageView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd)  {
	return (self.frame.origin.y < 100) ? (hideTime ? 0 : _logos_orig$_ungrouped$_UIStatusBarImageView$alpha(self, _cmd)) : _logos_orig$_ungrouped$_UIStatusBarImageView$alpha(self, _cmd);
}


#import <arpa/inet.h>
#import <spawn.h>
#define ASSPort 43333
const int one = 1;
int connfd;



static SpringBoard* _logos_method$_ungrouped$SpringBoard$init(_LOGOS_SELF_TYPE_INIT SpringBoard* __unused self, SEL __unused _cmd) _LOGOS_RETURN_RETAINED {
    id orig = _logos_orig$_ungrouped$SpringBoard$init(self, _cmd);
    NSLog(@"[ASSWatchdog] checking for ASS");
    bool assPresent = [[NSFileManager defaultManager] fileExistsAtPath: @"/Library/MobileSubstrate/DynamicLibraries/AudioSnapshotServer.dylib"];
    if (assPresent) {
        NSLog(@"[ASSWatchdog] ASS found... checking if msd is hooked");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            struct sockaddr_in remote;
            remote.sin_family = PF_INET;
            remote.sin_port = htons(ASSPort);
            inet_aton("127.0.0.1", &remote.sin_addr);
            int r = -1;
            int retries = 0;

            while (connfd != -2) {
                NSLog(@"[ASSWatchdog] Connecting to ASS.");
                retries++;
                connfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

                if (connfd == -1) {
                    usleep(1000 * 1000);
                    continue;
                }
                setsockopt(connfd, SOL_SOCKET, SO_NOSIGPIPE, &one, sizeof(one));

                while(r != 0) {
                    if (retries > 3) {
                        connfd = -2;
                        NSLog(@"[ASSWatchdog] ASS not running.");
                        pid_t pid;
                        const char* args[] = {"killall", "mediaserverd", NULL};
                        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
                        break;
                    }

                    r = connect(connfd, (struct sockaddr *)&remote, sizeof(remote));
                    usleep(200 * 1000);
                    retries++;
                }

                if (connfd > 0) {
                    NSLog(@"[ASSWatchdog] Connected.");
                    close(connfd);
                }
                
                break;
            }
        });

    } else {
        NSLog(@"[ASSWatchdog] abort, there's no ASS");
    }

    return orig;
}


static __attribute__((constructor)) void _logosLocalCtor_09e210eb(int __unused argc, char __unused **argv, char __unused **envp) {
    preferencesChanged();

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        &observer,
        (CFNotificationCallback)preferencesChanged,
        (CFStringRef)@"me.kritanta.statusviz/Prefs",
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );

	NSLog(@"StatusViz: dab");

	globalTimes = [NSMutableArray array];
	globalFrontBarViews = [NSMutableArray array];
	globalBackBarViews = [NSMutableArray array];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$_UIStatusBarForegroundView = objc_getClass("_UIStatusBarForegroundView"); MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(willMoveToSuperview:), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$willMoveToSuperview$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarForegroundView$willMoveToSuperview$);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarForegroundView, sel_registerName("dealloc"), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$dealloc, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarForegroundView$dealloc);{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(kek), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$kek, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(setKek:), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$setKek, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(MSHBarView *)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(mshView), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$mshView, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(MSHBarView *)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(setMshView:), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$setMshView, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(MSHBarView *)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(mshShitHackView), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$mshShitHackView, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(MSHBarView *)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(setMshShitHackView:), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$setMshShitHackView, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(MSHBarView *)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(mshBackView), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$mshBackView, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(MSHBarView *)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(setMshBackView:), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$setMshBackView, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(MSHBarView *)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(mshBackTwoView), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$mshBackTwoView, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(MSHBarView *)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(setMshBackTwoView:), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$setMshBackTwoView, _typeEncoding); } Class _logos_class$_ungrouped$MSHBarView = objc_getClass("MSHBarView"); MSHookMessageEx(_logos_class$_ungrouped$MSHBarView, @selector(setAlpha:), (IMP)&_logos_method$_ungrouped$MSHBarView$setAlpha$, (IMP*)&_logos_orig$_ungrouped$MSHBarView$setAlpha$);Class _logos_class$_ungrouped$_UIStatusBarStringView = objc_getClass("_UIStatusBarStringView"); MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarStringView, @selector(setText:), (IMP)&_logos_method$_ungrouped$_UIStatusBarStringView$setText$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarStringView$setText$);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarStringView, @selector(isHidden), (IMP)&_logos_method$_ungrouped$_UIStatusBarStringView$isHidden, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarStringView$isHidden);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarStringView, @selector(alpha), (IMP)&_logos_method$_ungrouped$_UIStatusBarStringView$alpha, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarStringView$alpha);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarStringView, @selector(setAlpha:), (IMP)&_logos_method$_ungrouped$_UIStatusBarStringView$setAlpha$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarStringView$setAlpha$);Class _logos_class$_ungrouped$SBMediaController = objc_getClass("SBMediaController"); MSHookMessageEx(_logos_class$_ungrouped$SBMediaController, @selector(_nowPlayingInfoChanged), (IMP)&_logos_method$_ungrouped$SBMediaController$_nowPlayingInfoChanged, (IMP*)&_logos_orig$_ungrouped$SBMediaController$_nowPlayingInfoChanged);MSHookMessageEx(_logos_class$_ungrouped$SBMediaController, @selector(_mediaRemoteNowPlayingInfoDidChange:), (IMP)&_logos_method$_ungrouped$SBMediaController$_mediaRemoteNowPlayingInfoDidChange$, (IMP*)&_logos_orig$_ungrouped$SBMediaController$_mediaRemoteNowPlayingInfoDidChange$);Class _logos_class$_ungrouped$MPUNowPlayingController = objc_getClass("MPUNowPlayingController"); Class _logos_metaclass$_ungrouped$MPUNowPlayingController = object_getClass(_logos_class$_ungrouped$MPUNowPlayingController); MSHookMessageEx(_logos_class$_ungrouped$MPUNowPlayingController, @selector(init), (IMP)&_logos_method$_ungrouped$MPUNowPlayingController$init, (IMP*)&_logos_orig$_ungrouped$MPUNowPlayingController$init);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(MPUNowPlayingController*), strlen(@encode(MPUNowPlayingController*))); i += strlen(@encode(MPUNowPlayingController*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$_ungrouped$MPUNowPlayingController, @selector(_current_MPUNowPlayingController), (IMP)&_logos_meta_method$_ungrouped$MPUNowPlayingController$_current_MPUNowPlayingController, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UIImage*), strlen(@encode(UIImage*))); i += strlen(@encode(UIImage*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MPUNowPlayingController, @selector(currentNowPlayingArtwork), (IMP)&_logos_method$_ungrouped$MPUNowPlayingController$currentNowPlayingArtwork, _typeEncoding); }Class _logos_class$_ungrouped$_UIStatusBar = objc_getClass("_UIStatusBar"); MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBar, @selector(regions), (IMP)&_logos_method$_ungrouped$_UIStatusBar$regions, (IMP*)&_logos_orig$_ungrouped$_UIStatusBar$regions);Class _logos_class$_ungrouped$_UIStatusBarImageView = objc_getClass("_UIStatusBarImageView"); MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarImageView, @selector(isHidden), (IMP)&_logos_method$_ungrouped$_UIStatusBarImageView$isHidden, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarImageView$isHidden);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarImageView, @selector(alpha), (IMP)&_logos_method$_ungrouped$_UIStatusBarImageView$alpha, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarImageView$alpha);Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(init), (IMP)&_logos_method$_ungrouped$SpringBoard$init, (IMP*)&_logos_orig$_ungrouped$SpringBoard$init);} }
#line 473 "StatusViz.xm"
