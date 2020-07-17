
#import <MitsuhaForever/MSHFBarView.h>
#define kIdentifier @"me.kritanta.statusvizprefs"
#define kSettingsChangedNotification (CFStringRef)@"me.kritanta.statusvizprefs/Prefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/me.kritanta.statusvizprefs.plist"

@interface _UIStatusBarStringView : UIView 
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@end
@interface _UIStatusBarForegroundView : UIView 
@property (nonatomic, assign) BOOL kek;
@property (nonatomic, retain) MSHFBarView *mshFView;
@property (nonatomic, retain) MSHFBarView *mshShitHackView;
@property (nonatomic, retain) MSHFBarView *mshBackView;
@property (nonatomic, retain) MSHFBarView *mshBackTwoView;
@end

// _UIStatusBar 
@interface Its3AMAndIAmCravingTacoBell : UIView
// 0 = main screen, 1 = CC 
@property (nonatomic, assign) NSInteger mode;
@end

@interface  MPUNowPlayingController : NSObject
- (void)startUpdating;
- (id)currentNowPlayingArtwork;
+ (id)currentArtwork;
@property (nonatomic, retain) NSString *currentNowPlayingArtworkDigest;
@end
