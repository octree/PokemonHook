//
//  OCTMenuController.h
//  LocationFaker
//
//  Created by Octree on 2016/7/12.
//
//

#import <UIKit/UIKit.h>

//  恢复到初始位置
//  打开/关闭 自动行走

static BOOL autorun = NO;

@class OCTMenuController;
@protocol OCTMenuControllerDelegate <NSObject>

@optional
- (void)menu:(OCTMenuController *)menu autorunDidChanged:(BOOL) newValue;
- (void)menuResetButtonTapped:(OCTMenuController *)menu;

@end

@interface OCTMenuController : UIViewController

@property (assign, nonatomic) id<OCTMenuControllerDelegate> delegate;

@end
