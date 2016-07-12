//
//  LocationFaker.mm
//  LocationFaker
//
//  Created by Xiaoxuan Tang on 16/7/8.
//  Copyright (c) 2016年 __MyCompanyName__. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>
#import "OCTMenuController.h"

static float x = -1;
static float y = -1;
static double speed = 0.000022523; // 2.5m/s
static double speedX = 0.000192523;
static double speedY = 0.00019;
static double offsetX = 0;
static double offsetY = 0;
static int added = 0;
static double timestamp = -1;
static double runDistance = 0;

@interface OCTControlView : UIView

- (int)addToWindow;

@end

@interface CLLocation(Swizzle)

@end

@implementation CLLocation(Swizzle)

+ (void) load {
    Method m1 = class_getInstanceMethod(self, @selector(coordinate));
    Method m2 = class_getInstanceMethod(self, @selector(coordinate_));
    
    method_exchangeImplementations(m1, m2);
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_x"]) {
        x = [[[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_x"] floatValue];
    };
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_y"]) {
        y = [[[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_y"] floatValue];
    };
}

- (CLLocationCoordinate2D) coordinate_ {
    
    CLLocationCoordinate2D pos = [self coordinate_];
    
    // 算与联合广场的坐标偏移量
    if (x == -1 && y == -1) {
        //        x = pos.latitude - 37.7883923;
        //        y = pos.longitude - (-122.4076413);
        //        悉尼歌剧院
        x = pos.latitude - (-33.8577509);
        y = pos.longitude - 151.2146436;
        
        [[NSUserDefaults standardUserDefaults] setValue:@(x) forKey:@"_fake_x"];
        [[NSUserDefaults standardUserDefaults] setValue:@(y) forKey:@"_fake_y"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (added == 0) {
        
        added = [[[OCTControlView alloc] init] addToWindow];
    }
    
    if (autorun) {
        
        if (timestamp == -1) {
            
            timestamp = [[NSDate date] timeIntervalSince1970];
        }
        
        NSTimeInterval currts = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval interval = currts  - timestamp;
        runDistance += interval * speed;
        timestamp = currts;
    }
    
    return CLLocationCoordinate2DMake(pos.latitude - x + offsetX - runDistance,
                                      pos.longitude - y + offsetY);
}

@end


@interface OCTControlView ()<OCTMenuControllerDelegate>

@property (strong, nonatomic) UIButton *upButton;
@property (strong, nonatomic) UIButton *downButton;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIButton *menuButton;

@end

@implementation OCTControlView

#pragma mark - Life Cycle
- (instancetype)init {
    
    self = [super initWithFrame: CGRectMake(0, 20, 90, 90)];
    if (self) {
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.5];
        [self configButtons];
    }
    return self;
}

- (void)configButtons {
    
    [self addSubview: self.upButton];
    [self addSubview: self.downButton];
    [self addSubview: self.leftButton];
    [self addSubview: self.rightButton];
    [self addSubview: self.menuButton];
}

- (int)addToWindow {
    
    UIWindow *window;
    
    for(UIWindow *elt in [UIApplication sharedApplication].windows) {
        
        if (elt.windowLevel == UIWindowLevelNormal) {
            
            window = elt;
        }
    }
    
    if (window == nil) {
        
        return 0;
    }
    
    [window addSubview: self];
    
    return 1;
}

#pragma mark - OCTMenuControllerDelegate

- (void)menu:(OCTMenuController *)menu autorunDidChanged:(BOOL) newValue {
    
    autorun = newValue;
}

- (void)menuResetButtonTapped:(OCTMenuController *)menu {
    
    offsetX = 0;
    offsetY = 0;
    x = -1;
    y = -1;
    timestamp = -1;
    runDistance = 0;
}

#pragma mark - Action

- (void)showMenu {
    
    OCTMenuController *vc = [[OCTMenuController alloc] init];
    vc.delegate = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)buttonTapped:(UIButton *)button {
    
    switch (button.tag) {
            
        case 0:
            //            up
            offsetX += speedX;
            break;
        case 1:
            
            //            down
            offsetX -= speedX;
            break;
        case 2:
            //            left
            offsetY -= speedY;
            break;
        case 3:
            //            right
            offsetY += speedY;
            break;
            
        default:
            break;
    }
}

#pragma mark - Accessor
- (UIButton *)upButton {
    
    if (!_upButton) {
        
        _upButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_upButton setTitle:@"▲" forState: UIControlStateNormal];
        _upButton.frame = CGRectMake(30, 0, 30, 30);
        _upButton.tag = 0;
        _upButton.titleLabel.font = [UIFont systemFontOfSize: 25];
        [_upButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_upButton setTitleColor:[UIColor whiteColor] forState: UIControlStateHighlighted];
    }
    
    return _upButton;
}

- (UIButton *)downButton {
    
    if (!_downButton) {
        
        _downButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_downButton setTitle:@"▼" forState: UIControlStateNormal];
        _downButton.frame = CGRectMake(30, 60, 30, 30);
        _downButton.tag = 1;
        _downButton.titleLabel.font = [UIFont systemFontOfSize: 25];
        [_downButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_downButton setTitleColor:[UIColor whiteColor] forState: UIControlStateHighlighted];
    }
    
    return _downButton;
}

- (UIButton *)leftButton {
    
    if (!_leftButton) {
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_leftButton setTitle:@"◀︎" forState: UIControlStateNormal];
        _leftButton.frame = CGRectMake(0, 30, 30, 30);
        _leftButton.tag = 2;
        _leftButton.titleLabel.font = [UIFont systemFontOfSize: 25];
        [_leftButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setTitleColor:[UIColor whiteColor] forState: UIControlStateHighlighted];
    }
    
    
    return _leftButton;
}



- (UIButton *)rightButton {
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rightButton setTitle:@"▶︎" forState: UIControlStateNormal];
        _rightButton.frame = CGRectMake(60, 30, 30, 30);
        _rightButton.tag = 3;
        _rightButton.titleLabel.font = [UIFont systemFontOfSize: 25];
        [_rightButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitleColor:[UIColor whiteColor] forState: UIControlStateHighlighted];
    }
    
    return _rightButton;
}


- (UIButton *)menuButton {
    
    if (!_menuButton) {
        
        _menuButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_menuButton setTitle:@"◉" forState: UIControlStateNormal];
        _menuButton.frame = CGRectMake(30, 30, 30, 30);
        _menuButton.titleLabel.font = [UIFont systemFontOfSize: 25];
        [_menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        [_menuButton setTitleColor:[UIColor whiteColor] forState: UIControlStateHighlighted];
    }
    
    return _menuButton;
}

@end
