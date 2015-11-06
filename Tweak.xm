static BOOL isEnabled = YES;

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
	if(isEnabled) %orig(@"", arg2);
	else %orig;
}

// Change because there is no more sliding
- (void)setCustomSlideToUnlockText:(id)arg1 {
	if(isEnabled) %orig(@"");
	else %orig;
}

// Stop CC and NC grabbers from loading
- (void)_addGrabberViews {
	if(isEnabled) return;
	%orig;
}

// Hide camera grabber view
- (void)startAnimating {
	%orig;
	if(!isEnabled) return;
	if(!self.cameraGrabberView) return;
	self.cameraGrabberView.alpha = 0;
}
- (void)layoutSubviews {
	%orig;
	if(!isEnabled) return;
	if(!self.cameraGrabberView) return;
	self.cameraGrabberView.alpha = 0;
}
- (void)_layoutCameraGrabberView {
	%orig;
	if(!isEnabled) return;
	if(!self.cameraGrabberView) return;
	self.cameraGrabberView.alpha = 0;
}

%end

// Hide chevron arrow
// "Borrowed" ;) from https://github.com/codyd51/NoSTUArrow
// Thanks Phillip <3
%hook SBFGlintyStringView

- (int)chevronStyle {  
    return (isEnabled ? 0 : %orig);
}

- (void)setChevronStyle:(int)style {
	if(isEnabled) %orig(0);
	else %orig;
}

%end

%hook _UIGlintyStringView

- (id)chevron {
    return (isEnabled ? nil : %orig);
}

%end

static void reloadPrefs() {
	CFPreferencesAppSynchronize(CFSTR("com.sassoty.nounwantedlsstuff"));
	Boolean exists = NO;
	Boolean isEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("Enabled"), CFSTR("com.sassoty.nounwantedlsstuff"), &exists);
	isEnabled = (exists ? isEnabledRef : YES);
}

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)reloadPrefs,
        CFSTR("com.sassoty.nounwantedlsstuff.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
