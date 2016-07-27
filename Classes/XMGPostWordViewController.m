//
//  XMGPostWordViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/7/11.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGPostWordViewController.h"
#import "XMGPlaceholderLabelTextView.h"
#import "XMGAddTagToolbar.h"

@interface XMGPostWordViewController ()<UITextViewDelegate>
/** 文本输入控件 */
@property (nonatomic, strong) XMGPlaceholderLabelTextView *textView;
/** 工具条 */
@property (nonatomic, weak) XMGAddTagToolbar *toolbar;
@end

@implementation XMGPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupTextView];
    [self setupToolbar];
}

- (void)setupNav{
    self.title = @"发表文字";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO; //默认不能点击
    // 强制刷新
    [self.navigationController.navigationBar layoutIfNeeded];
}

//监听键盘的弹出和隐藏
- (void)keyboardWillChangeFrame:(NSNotification *)note{
    //键盘最终的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, keyboardF.origin.y - SCREEN_HEIGHT);
    }];
    
}

- (void)setupToolbar{
    XMGAddTagToolbar *toolbar = [XMGAddTagToolbar viewFromXib];
    toolbar.width = self.view.width;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.x = 0;
    
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupTextView{
    XMGPlaceholderLabelTextView *textView = [[XMGPlaceholderLabelTextView alloc] init];
    
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    textView.frame = self.view.bounds;
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post{
    XMGLogFunc;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
