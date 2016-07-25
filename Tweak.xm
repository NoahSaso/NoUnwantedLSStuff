#define prefsID CFSTR("com.sassoty.nounwantedlsstuff")

static BOOL isEnabled = YES;
static BOOL shouldHideSTUText = YES;
static BOOL shouldHideChevron = YES;
static BOOL shouldHideGrabbers = YES;
static NSString *stuText = @"slide to unlock";

%hook SBLockScreenBounceAnimator

// KILL THE HINT!! (iOS 7.1+)
- (void)_handleTapGesture:(id)arg1 {
	if(isEnabled) {
		if(arg1 && [arg1 isKindOfClass:[UIGestureRecognizer class]])
			[[arg1 view] removeGestureRecognizer:arg1];
	}else %orig;
}

%end

@interface SBLockScreenView
@property (retain, nonatomic) UIView *cameraGrabberView;
@end

%hook SBLockScreenView

// KILL THE HINT!! (iOS 7)
- (CGFloat)hintDisplacement {
	return (isEnabled ? 0.f : %orig);
}

// Change because there is no more sliding (idk some lower versions have this animated thing)
- (void)setCustomSlideToUnlockText:(id)arg1 animated:(BOOL)arg2 {
	if(isEnabled) %orig((shouldHideSTUText ? @"" : stuText), arg2);
	else %orig;
}

// Change because there is no more sliding
- (void)setCustomSlideToUnlockText:(id)arg1 {
	if(isEnabled) %orig((shouldHideSTUText ? @"" : stuText));
	else %orig;
}

// Stop CC and NC grabbers from loading
- (void)_addGrabberViews {
	if(isEnabled && shouldHideGrabbers) return;
	%orig;
}

/* HACKY AND BARELY WORKS
// Hide camera grabber view
- (void)startAnimating {
	%orig;
	if(!isEnabled || !shouldHideCamera) return;
	if(!self.cameraGrabberView) return;
	self.cameraGrabberView.alpha = 0;
}
- (void)layoutSubviews {
	%orig;
	if(!isEnabled || !shouldHideCamera) return;
	if(!self.cameraGrabberView) return;
	self.cameraGrabberView.alpha = 0;
}
- (void)_layoutCameraGrabberView {
	%orig;
	if(!isEnabled || !shouldHideCamera) return;
	if(!self.cameraGrabberView) return;
	self.cameraGrabberView.alpha = 0;
}
*/

%end

// Hide chevron arrow
// "Borrowed" ;) from https://github.com/codyd51/NoSTUArrow
// Thanks Phillip <3
%hook SBFGlintyStringView

- (int)chevronStyle {  
    return (isEnabled && shouldHideChevron ? 0 : %orig);
}

- (void)setChevronStyle:(int)style {
	if(isEnabled && shouldHideChevron) %orig(0);
	else %orig;
}

%end

%hook _UIGlintyStringView

- (id)chevron {
    return (isEnabled && shouldHideChevron ? nil : %orig);
}

%end

static void reloadPrefs() {
	CFPreferencesAppSynchronize(prefsID);
	NSDictionary *prefs = nil;
	CFArrayRef keyList = CFPreferencesCopyKeyList(prefsID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if(keyList) {
		prefs = (NSDictionary *)CFPreferencesCopyMultiple(keyList, prefsID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if(!prefs) prefs = [NSDictionary new];
		CFRelease(keyList);
	}
	isEnabled = prefs[@"Enabled"] ? [prefs[@"Enabled"] boolValue] : YES;
	shouldHideSTUText = prefs[@"HideSTU"] ? [prefs[@"HideSTU"] boolValue] : YES;
	shouldHideChevron = prefs[@"HideChevron"] ? [prefs[@"HideChevron"] boolValue] : YES;
	shouldHideGrabbers = prefs[@"HideGrabbers"] ? [prefs[@"HideGrabbers"] boolValue] : YES;
	stuText = prefs[@"STUText"] ?: @"slide to unlock";
}

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)reloadPrefs,
        CFSTR("com.sassoty.nounwantedlsstuff.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
