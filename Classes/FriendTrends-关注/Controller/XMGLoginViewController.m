//
//  XMGLoginViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/5/27.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGLoginViewController.h"

@interface XMGLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/** 登录框距离控制器view左边的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;
@end

@implementation XMGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    //文字属性
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
//    
//    // NSAttributedString : 带有属性的文字(富文本技术)
//    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:attrs];
//    
//    self.phoneTextField.attributedPlaceholder = placeholder;

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

/**
 * 让当前控制器对应的状态栏是白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (IBAction)logoutButton:(id)sender {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)showLoginOrRegister:(UIButton *)button {
    //退出键盘
    [self.view endEditing:YES];
    if (self.loginViewLeftMargin.constant == 0) {//显示注册页面
        self.loginViewLeftMargin.constant =-self.view.width;
        button.selected = YES;
    } else{
        self.loginViewLeftMargin.constant = 0;  //显示登陆界面
        button.selected = NO;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
