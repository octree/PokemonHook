//
//  OCTMenuController.m
//  LocationFaker
//
//  Created by Octree on 2016/7/12.
//
//

#import "OCTMenuController.h"

@interface OCTMenuController ()

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *autoRunLabel;
@property (strong, nonatomic) UISwitch *autoRunSwitch;
@property (strong, nonatomic) UIButton *resetButton;

@end

@implementation OCTMenuController

#pragma mark - Life Cycle

- (instancetype)init {

    if (self = [super init]) {
    
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configView];
}

- (void)configView {
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    [self.view addSubview: self.containerView];
    [self.containerView addSubview: self.autoRunLabel];
    [self.containerView addSubview: self.autoRunSwitch];
    [self.containerView addSubview: self.resetButton];
}



#pragma mark - Action

- (void)autorunValueChanged:(UISwitch *)sender {

    autorun = sender.on;
    if ([self.delegate respondsToSelector:@selector(menu:autorunDidChanged:)]) {
        
        [self.delegate menu:self autorunDidChanged:sender.on];
    }
}

- (void)resetButtonTapped:(UIButton *)button {

    if ([self.delegate respondsToSelector:@selector(menuResetButtonTapped:)]) {
    
        [self.delegate menuResetButtonTapped: self];
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView: self.view];
    
    if (!CGRectContainsPoint(self.containerView.frame, point)) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Accessor

- (UILabel *)autoRunLabel {

    if (!_autoRunLabel) {
    
        _autoRunLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 20, 100, 30)];
        _autoRunLabel.text = @"自动行走";
    }
    
    return _autoRunLabel;
}

- (UISwitch *)autoRunSwitch {

    if (!_autoRunSwitch) {
    
        _autoRunSwitch = [[UISwitch alloc] init];
        _autoRunSwitch.on = autorun;
        
        CGRect frame = _autoRunSwitch.frame;
        frame.origin.x = 240 - 20 - frame.size.width;
        frame.origin.y = 20;
        _autoRunSwitch.frame = frame;
        
        [_autoRunSwitch addTarget:self
                           action:@selector(autorunValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
    }
    
    return _autoRunSwitch;
}

- (UIButton *)resetButton {

    if (!_resetButton) {
    
        _resetButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        _resetButton.frame =  CGRectMake(20, 64, 200, 40);
        [_resetButton setTitle:@"重 置 坐 标"
                      forState:UIControlStateNormal];
        [_resetButton setBackgroundColor: [UIColor colorWithRed: 102.0 / 255 green:124.0 / 255 blue:1.0 alpha:1.0]];
        _resetButton.layer.masksToBounds = YES;
        _resetButton.layer.cornerRadius = 8;
        [_resetButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _resetButton;
}


- (UIView *)containerView {

    if (!_containerView) {
    
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat x = (width - 240) / 2;
        CGFloat y = (height - 140) / 2;
        _containerView = [[UIView alloc]
                          initWithFrame: CGRectMake(x, y, 240, 120)];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _containerView;
}


@end
