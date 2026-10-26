#import <UIKit/UIKit.h>
#import "../Settings/YTGlassSettingsViewController.h"
#import "../Core/YTRuntime.h"
#import "../Core/YTTokens.h"
#import "../Core/YTGlass.h"

@interface YTMSettingsViewController : UIViewController
- (void)ytm_openVitrineSettings;
@end

@interface YTMMainSettingsViewController : UIViewController
- (void)ytm_openVitrineSettings;
@end

@interface YTMBaseSettingsViewController : UIViewController
- (void)ytm_openVitrineSettings;
@end

@interface YTAppSettingsViewController : UIViewController
- (void)ytm_openVitrineSettings;
@end

@interface YTMIntegrationsSettingsViewController : UIViewController
- (void)ytm_openVitrineSettings;
@end

static void YTPresentSettingsFromVC(UIViewController *vc) {
    YTGlassSettingsViewController *settingsVC = [[YTGlassSettingsViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    nav.modalPresentationStyle = UIModalPresentationPageSheet;
    YTPresentDarkStyle(nav);
    [vc presentViewController:nav animated:YES completion:nil];
}

%hook YTMSettingsViewController

- (void)viewDidLoad {
    %orig;
    UIBarButtonItem *modBtn = [[UIBarButtonItem alloc] initWithTitle:@"✨ Vitrine"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(ytm_openVitrineSettings)];
    modBtn.tintColor = [UIColor systemPinkColor];
    self.navigationItem.rightBarButtonItem = modBtn;
}

%new
- (void)ytm_openVitrineSettings {
    YTPresentSettingsFromVC(self);
}

%end

%hook YTMMainSettingsViewController

- (void)viewDidLoad {
    %orig;
    UIBarButtonItem *modBtn = [[UIBarButtonItem alloc] initWithTitle:@"✨ Vitrine"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(ytm_openVitrineSettings)];
    modBtn.tintColor = [UIColor systemPinkColor];
    self.navigationItem.rightBarButtonItem = modBtn;
}

%new
- (void)ytm_openVitrineSettings {
    YTPresentSettingsFromVC(self);
}

%end

%hook YTMBaseSettingsViewController

- (void)viewDidLoad {
    %orig;
    UIBarButtonItem *modBtn = [[UIBarButtonItem alloc] initWithTitle:@"✨ Vitrine"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(ytm_openVitrineSettings)];
    modBtn.tintColor = [UIColor systemPinkColor];
    self.navigationItem.rightBarButtonItem = modBtn;
}

%new
- (void)ytm_openVitrineSettings {
    YTPresentSettingsFromVC(self);
}

%end

%hook YTAppSettingsViewController

- (void)viewDidLoad {
    %orig;
    UIBarButtonItem *modBtn = [[UIBarButtonItem alloc] initWithTitle:@"✨ Vitrine"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(ytm_openVitrineSettings)];
    modBtn.tintColor = [UIColor systemPinkColor];
    self.navigationItem.rightBarButtonItem = modBtn;
}

%new
- (void)ytm_openVitrineSettings {
    YTPresentSettingsFromVC(self);
}

%end

%hook YTMIntegrationsSettingsViewController

- (void)viewDidLoad {
    %orig;
    UIBarButtonItem *modBtn = [[UIBarButtonItem alloc] initWithTitle:@"✨ Vitrine"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(ytm_openVitrineSettings)];
    modBtn.tintColor = [UIColor systemPinkColor];
    self.navigationItem.rightBarButtonItem = modBtn;
}

%new
- (void)ytm_openVitrineSettings {
    YTPresentSettingsFromVC(self);
}

%end
