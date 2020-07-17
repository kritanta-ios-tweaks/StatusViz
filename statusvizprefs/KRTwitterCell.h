#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface KRTwitterCell : PSTableCell
@property (nonatomic, retain, readonly) UIView *avatarView;
@property (nonatomic, retain, readonly) UIImageView *avatarImageView;
@end

@interface KRTwitterCell () {
    NSString *_user;
}
@end
