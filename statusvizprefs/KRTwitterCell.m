//
// KRTwitterCell.m
// Twitter cell that locally loads pfps 
//		based on Cephei Framework
//
// Apache 2.0 License for code used in KRPrefsLicense located in preference bundle
//


#import "KRTwitterCell.h"
#import <Preferences/PSSpecifier.h>

@implementation KRTwitterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 38, 38)];

        self.detailTextLabel.numberOfLines = 1;
        self.detailTextLabel.textColor = [UIColor grayColor];

        self.textLabel.textColor = [UIColor blackColor];
        
        if (@available(iOS 13, *)) {
            self.tintColor = [UIColor labelColor];
        }
        else {
            self.tintColor = [UIColor blackColor];
        }

        CGFloat const size = 29.f;

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, [UIScreen mainScreen].scale);
        specifier.properties[@"iconImage"] = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        _avatarView = [[UIView alloc] initWithFrame:self.imageView.bounds];
        _avatarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _avatarView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1];
        _avatarView.userInteractionEnabled = NO;
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = size / 2;
        _avatarView.layer.borderWidth = 2;

        if (@available(iOS 13, *)) {
            _avatarView.layer.borderColor = [[UIColor tertiaryLabelColor] CGColor];
        }
        else {
            _avatarView.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.3] CGColor];
        }
        
        [self.imageView addSubview:_avatarView];

        _avatarImageView = [[UIImageView alloc] initWithFrame:_avatarView.bounds];
        _avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _avatarImageView.alpha = 0;
        _avatarImageView.layer.minificationFilter = kCAFilterTrilinear;
        [_avatarView addSubview:_avatarImageView];

        _user = [specifier.properties[@"accountName"] copy];
        NSAssert(_user, @"User name not provided");

        specifier.properties[@"url"] = [self.class _urlForUsername:_user];

        self.detailTextLabel.text = _user;

        if (!_user) {
            return self;
        }

         self.avatarImage = [UIImage imageNamed:[NSString stringWithFormat:@"/Library/PreferenceBundles/statusvizprefs.bundle/_kritanta.png"]];
    }

    return self;
}

#pragma mark - Avatar

- (void)setAvatarImage:(UIImage *)avatarImage
{
    _avatarImageView.image = avatarImage;

    if (_avatarImageView.alpha == 0)
    {
        [UIView animateWithDuration:0.15
            animations:^{
                _avatarImageView.alpha = 1;
            }
        ];
    }
}

+ (NSURL *)_urlForUsername:(NSString *)user {

/*    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"aphelion://"]]) {
        return [NSString stringWithFormat: @"aphelion://profile/%@", user]; // Easter egg by hbkirb
    } else*/
     
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
        return [NSURL URLWithString: [@"tweetbot:///user_profile/" stringByAppendingString:user]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]]) {
        return [NSURL URLWithString: [@"twitterrific:///profile?screen_name=" stringByAppendingString:user]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings://"]]) {
        return [NSURL URLWithString: [@"tweetings:///user?screen_name=" stringByAppendingString:user]];
    } else {
        return [NSURL URLWithString: [@"https://mobile.twitter.com/" stringByAppendingString:user]];
    }
}

- (void)setSelected:(BOOL)arg1 animated:(BOOL)arg2
{
    if (arg1) [[UIApplication sharedApplication] openURL:[self.class _urlForUsername:_user] options:@{} completionHandler:nil];
}
@end
