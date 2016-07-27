//
//  XMGAddTagViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/7/11.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGAddTagViewController.h"
#import "XMGTagButton.h"
#import "XMGTagTextField.h"
#import "SVProgressHUD.h"


@interface XMGAddTagViewController ()<UITextFieldDelegate>
/** 内容 */
@property (nonatomic, strong) UIView *contentView;
/** 文本输入框 */
@property (nonatomic, strong) XMGTagTextField *textField;
/** 添加按钮 */
@property (nonatomic, strong) UIButton *addButton;
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;

@end

@implementation XMGAddTagViewController


#pragma mark - 懒加载
- (NSMutableArray *)tagButtons{
    if (_tagButtons == nil) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (UIButton *)addButton{
    if (_addButton == nil) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.width = self.contentView.width;
        addButton.height = 35;
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        // 让按钮内部的文字和图片都左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.backgroundColor = XMGRGBColor(74, 139, 209);
        [self.contentView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupContentView];
    
    [self setupTextFiled];
    
    [self setupTags];
}

- (void)setupTags{
    for (NSString *tag in self.tags) {
        self.textField.text = tag;
        [self addButtonClick];
    }
}

- (void)setupTextFiled{
    __weak typeof(self) weakSelf = self;
    XMGTagTextField *textField = [[XMGTagTextField alloc] init];
    textField.width = self.contentView.width;
    textField.deleteBlock = ^{
        if (weakSelf.textField.hasText) return;
        
        [weakSelf tagButtonClick:[weakSelf.tagButtons lastObject]];
    };
    textField.delegate = self;
    
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    [self.contentView addSubview:textField];
    self.textField = textField;
    
}

- (void)setupContentView{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(XMGTagMargin, 64+XMGTagMargin, SCREEN_WIDTH - 2*XMGTagMargin, SCREEN_HEIGHT)];
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setupNav{
    self.title = @"添加标签";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
}

- (void)done{
    // 传递数据给上一个控制器
//    NSMutableArray *tags = [NSMutableArray array];
//    for (XMGTagButton *tagButton in self.tagButtons) {
//        [tags addObject:tagButton.currentTitle];
//    }
    
    // 传递tags给这个block
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听文字改变
//监听文字改变
- (void)textDidChange{
    
    // 更新标签和文本框的frame
    [self updateTagButtonFrame];
    
    if (self.textField.hasText) {//有文字
        //显示添加标签的按钮
        self.addButton.hidden = NO;
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + XMGTopicCellMargin;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签: %@",self.textField.text] forState:UIControlStateNormal];
        
        //获取最后一个字符
        NSString *text = self.textField.text;
        NSUInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        if ([lastLetter isEqualToString:@","] || [lastLetter isEqualToString:@"，"]) {
            
            //去除逗号
            self.textField.text = [text substringToIndex:len-1];
            [self addButtonClick];
        }
    } else{//没有文字
       //隐藏标签按钮
        self.addButton.hidden = YES;
    }
    
}

#pragma mark - 监听按钮点击
- (void)addButtonClick{
    
    if (self.tagButtons.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    //添加一个“标签按钮”
    XMGTagButton *tagButton = [XMGTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    tagButton.height = self.textField.height;
    [self.contentView addSubview:tagButton];
    [self.tagButtons addObject:tagButton];
    
    //清空textfield文字
    self.textField.text = nil;
    self.addButton.hidden = YES;
    
    //更新标签按钮的frame
    [self updateTagButtonFrame];
    [self updateTextFieldFrame];
   
}

//标签按钮的点击
- (void)tagButtonClick:(XMGTagButton *) tagButton{
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    //更新标签的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
}

#pragma mark - 更新子控件的frame
//用来更新标签按钮的frame
- (void)updateTagButtonFrame{
    for (int i = 0; i<self.tagButtons.count; i++) {
        XMGTagButton *tagButton = self.tagButtons[i];
        
        if (i == 0) { //最前面的按钮
            tagButton.x = 0;
            tagButton.y = 0;
        } else{ //其他标签
            XMGTagButton *lastTagButton = self.tagButtons[i-1];
            //计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + XMGTagMargin;
            //计算右边的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            if (rightWidth >= tagButton.width) { //按钮显示在当前行
                tagButton.x = leftWidth;
                tagButton.y = lastTagButton.y;
            } else{ //按钮显示在下一行
                tagButton.x = 0;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + XMGTagMargin;
            }
        }
    }
    
}

- (void)updateTextFieldFrame{
    //最后一个标签按钮
    XMGTagButton *lastTagButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + XMGTagMargin;
    
    //更新textfield的frame
    if (self.contentView.width - leftWidth >= [self textFieldTextWidth]) {
        self.textField.x = leftWidth;
        self.textField.y = lastTagButton.y;
    } else{
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + XMGTagMargin;
    }

}


//textField的文字宽度
- (CGFloat)textFieldTextWidth{
    //只有一行时可以用此方法获取文字宽度
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(100, textW);
}

#pragma mark - <UITextFieldDelegate>
/**
 * 监听键盘最右下角按钮的点击（return key， 比如“换行”、“完成”等等）
 */
- (BOOL)textFieldShouldReturn:(XMGTagTextField *)textField{
    
    if (self.textField.hasText) {
        [self addButtonClick];
    }
    
    return YES;
}

@end
