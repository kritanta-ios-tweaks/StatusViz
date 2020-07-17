//
//	StatusViz.xm
//	StatusViz
//
//	Visualizer in the status bar
//
//	All of the coding practices used here are bad and you should not use them.
// 	GLOBALS ARE BAD, I'M JUST INCREDIBLY LAZY
//	3 am tweak request
//

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
	for (MSHFBarView *bar in globalFrontBarViews)
	{
		[bar updateWaveColor:[f getColor] subwaveColor:[UIColor grayColor]];
	}
	for (MSHFBarView *bar in globalBackBarViews)
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

%hook _UIStatusBarForegroundView 

%property (nonatomic, assign) BOOL kek;
%property (nonatomic, retain) MSHFBarView *mshFView;
%property (nonatomic, retain) MSHFBarView *mshShitHackView;
%property (nonatomic, retain) MSHFBarView *mshBackView;
%property (nonatomic, retain) MSHFBarView *mshBackTwoView;

- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig(newSuperview);
	if (((Its3AMAndIAmCravingTacoBell*)(newSuperview)).mode!=0) return;
	if (((Its3AMAndIAmCravingTacoBell*)(newSuperview)).superview.frame.origin.x+((Its3AMAndIAmCravingTacoBell*)(newSuperview)).superview.frame.origin.y!=0)return;
	if([((Its3AMAndIAmCravingTacoBell*)(newSuperview)).superview.superview.description containsString:@"CCUI"])return;
	if (self.kek)return;
	global_UIStatusBarForegroundView = self;


	self.mshFView = [[MSHFBarView alloc] initWithFrame:CGRectMake(20,0,50,30)];
	[(MSHFBarView*)self.mshFView setBarSpacing:4];
	[(MSHFBarView*)self.mshFView  setBarCornerRadius:2];

	self.mshFView.autoHide = YES;
	self.mshFView.displayLink.preferredFramesPerSecond = 24;
	self.mshFView.numberOfPoints = 6;
	self.mshFView.waveOffset = 26;
	self.mshFView.gain = 10;
	self.mshFView.limiter = 8;
	self.mshFView.sensitivity = 0.5*sensi;
	self.mshFView.audioProcessing.fft = YES;
	self.mshFView.disableBatterySaver = NO;
	[self.mshFView updateWaveColor:[UIColor whiteColor] subwaveColor:[UIColor whiteColor]];


	self.mshFView.clipsToBounds=YES;

	// lazy hack to fix the weird offset bug where bars can just yeet themselves
	//	entirely out of their container at random(?)
	self.mshShitHackView = [[MSHFBarView alloc] initWithFrame:CGRectMake(20,0,50,30)];
	[(MSHFBarView*)self.mshShitHackView setBarSpacing:4];
	[(MSHFBarView*)self.mshShitHackView  setBarCornerRadius:2];

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


	self.mshBackView = [[MSHFBarView alloc] initWithFrame:CGRectMake(20,0,50,30)];
	[(MSHFBarView*)self.mshBackView setBarSpacing:4];
	[(MSHFBarView*)self.mshBackView  setBarCornerRadius:2];

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

	self.mshBackTwoView = [[MSHFBarView alloc] initWithFrame:CGRectMake(20,0,50,30)];
	[(MSHFBarView*)self.mshBackTwoView setBarSpacing:4];
	[(MSHFBarView*)self.mshBackTwoView  setBarCornerRadius:2];

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
	[globalFGBarViews addObject:self.mshFView];
	[self addSubview:self.mshBackTwoView];
	[self addSubview:self.mshBackView];
	[self addSubview:self.mshFView];
	[self addSubview:self.mshShitHackView];
	[self.mshFView start];
	[self.mshBackView start];
	[self.mshBackTwoView start];
	[self.mshShitHackView start];
	self.kek=YES;
}

-(void)dealloc 
{
	[globalFrontBarViews removeObject:self.mshBackView];
	[globalFGBarViews removeObject:self.mshFView];
	[globalBackBarViews removeObject:self.mshBackTwoView];
	[self.mshFView stop];
	[self.mshBackView stop];
	[self.mshBackTwoView stop];
	[self.mshShitHackView stop];
	hideLeftStatusBarRegions();
	%orig;
}

%end

%hook MSHFBarView
-(void)setAlpha:(CGFloat)alpha 
{
	%orig(alpha);
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
%end

%hook _UIStatusBarStringView

/*-(void)layoutSubviews
{
	%orig;
	for (UIView *v in [self subviews])
	{
		v.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	}
}*/

-(void)setText:(NSString*)set
{
	%orig(set);
	[globalTimes addObject:self];
}
-(BOOL)isHidden
{
	return [self.text containsString:@":"] ? hideTime : %orig;
}

-(CGFloat)alpha 
{
	return [self.text containsString:@":"] ? (hideTime ? 0 : %orig) : %orig;
}
-(void)setAlpha:(CGFloat)alpha 
{
	%orig([self.text containsString:@":"] ? (hideTime ? 0 : alpha) : alpha);
}
%end

%hook SBMediaController 

-(void)_nowPlayingInfoChanged 
{
    %orig;
	dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
	dispatch_after(delay, dispatch_get_main_queue(), ^(void){
		updateBackwaves();
	});
}



-(void)_mediaRemoteNowPlayingInfoDidChange:(id)arg1 {
    %orig(arg1);

	dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
	dispatch_after(delay, dispatch_get_main_queue(), ^(void){
		updateBackwaves();
	});
}

%end



%hook MPUNowPlayingController

-(MPUNowPlayingController*)init
{
    id orig = %orig;
    
    if (orig) {
        globalMPUNowPlaying = orig;
    }
    return orig;
}


%new
+ (MPUNowPlayingController*)_current_MPUNowPlayingController
{
    return globalMPUNowPlaying;
}


%new 
-(UIImage*)currentNowPlayingArtwork
{
    if (!globalMPUNowPlaying){
        MPUNowPlayingController *nowPlayingController = [[objc_getClass("MPUNowPlayingController") alloc] init];
        [nowPlayingController startUpdating];
        return [nowPlayingController currentNowPlayingArtwork];
    }
    return [globalMPUNowPlaying currentNowPlayingArtwork];
}
%end



%hook _UIStatusBar 

-(NSDictionary *)regions 
{
	NSDictionary *regions = %orig;
	if (![globalLeftAreas containsObject:self]) 
	{
		[globalLeftAreas addObject:regions[@"leading"]];
	}
	return %orig;
}

%end

static void preferencesChanged() 
{
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);

	NSDictionary *prefs;

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

    sensi = [prefs objectForKey:@"sensitivity"] ? [[prefs valueForKey:@"sensitivity"] floatValue] : 3;
	sensi = sensi/3;
	for (MSHFBarView *bar in globalFrontBarViews)
	{
		bar.sensitivity = .75*sensi;
	}
	for (MSHFBarView *bar in globalBackBarViews)
	{
		bar.sensitivity = sensi;
	}
	for (MSHFBarView *bar in globalFGBarViews)
	{
		bar.sensitivity = .65*sensi;
	}
}

@interface  _UIStatusBarImageView : UIView
@end

%hook _UIStatusBarImageView 

-(BOOL)isHidden
{
	return (self.frame.origin.y < 100) ? hideTime : %orig;
}
-(CGFloat)alpha 
{
	return (self.frame.origin.y < 100) ? (hideTime ? 0 : %orig) : %orig;
}
%end

%group ASSWatchdog
#import <arpa/inet.h>
#import <spawn.h>
#define ASSPort 43333
const int one = 1;
int connfd;

%hook SpringBoard

-(id)init {
    id orig = %orig;
    NSLog(@"[ASSWatchdog] checking for ASS");
    bool assPresent = [[NSFileManager defaultManager] fileExistsAtPath: @"/Library/MobileSubstrate/DynamicLibraries/ThickASS.dylib"];
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

%end

%end

%ctor {
    preferencesChanged();

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        (CFNotificationCallback)preferencesChanged,
        (CFStringRef)@"me.kritanta.statusviz/Prefs",
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );

	NSLog(@"StatusViz: dab");

	bool const mitsuhaForeverInstalled = [[NSFileManager defaultManager] fileExistsAtPath: @"/Library/MobileSubstrate/DynamicLibraries/ASSWatchdog.dylib"];

	if (!mitsuhaForeverInstalled) %init(ASSWatchdog);

	%init;

	globalTimes = [NSMutableArray array];
	globalFrontBarViews = [NSMutableArray array];
	globalBackBarViews = [NSMutableArray array];
}


