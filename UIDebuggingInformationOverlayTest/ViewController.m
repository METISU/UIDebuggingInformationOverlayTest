//
//  ViewController.m
//  UIDebuggingInformationOverlayTest
//
//  Created by erchuan on 2021/6/22.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UIDebuggingInformationOverlayWindow:UIWindow
- (void)_setWindowControlsStatusBarOrientation:(BOOL)orientation;
@end

@implementation UIDebuggingInformationOverlayWindow

- (instancetype) init_UIDebuggingInformationOverlay {
    if (self = [super init]) {
        [self _setWindowControlsStatusBarOrientation:NO];
    }
    
    return self;
}

@end

@interface ViewController ()
@property (nonatomic, strong) UIButton *btn;
@end

@implementation ViewController

+ (void)load {
    Class UIDebuggingInformationOverlay = NSClassFromString(@"UIDebuggingInformationOverlay");
    if (!UIDebuggingInformationOverlay) {
        return;
    }
    
    Method originalInit = class_getInstanceMethod(UIDebuggingInformationOverlay, @selector(init));
    Method swizzledInit = class_getInstanceMethod([UIDebuggingInformationOverlayWindow class], @selector(init_UIDebuggingInformationOverlay));
    BOOL isSuccess = class_addMethod(UIDebuggingInformationOverlay, @selector(init), method_getImplementation(swizzledInit), method_getTypeEncoding(swizzledInit));
    if (isSuccess) {
        class_replaceMethod([UIDebuggingInformationOverlayWindow class], @selector(init_UIDebuggingInformationOverlay), method_getImplementation(originalInit), method_getTypeEncoding(originalInit));
    } else {
        method_exchangeImplementations(originalInit, swizzledInit);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击空白处";
    Class UIDebuggingInformationOverlayInvokeGestureHandler = NSClassFromString(@"UIDebuggingInformationOverlayInvokeGestureHandler");
    id handler = [UIDebuggingInformationOverlayInvokeGestureHandler.class performSelector:@selector(mainHandler)];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:handler action:@selector(_handleActivationGesture:)];
    
    [self.view addGestureRecognizer:ges];
    
}

@end
