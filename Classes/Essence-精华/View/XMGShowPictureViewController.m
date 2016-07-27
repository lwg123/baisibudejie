//
//  XMGShowPictureViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/6/12.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGShowPictureViewController.h"
#import "XMGTopics.h"
#import  "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "XMGProgressView.h"

@interface XMGShowPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet XMGProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation XMGShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //添加图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [imageView addGestureRecognizer: gesture];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    //图片尺寸
    CGFloat pictureW = SCREEN_WIDTH;
    CGFloat pictureH = pictureW * self.topic.height / self.topic.width;
    if (pictureH > SCREEN_WIDTH) { //图片显示高度超过一个屏幕，需要滚动显示
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    } else{
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.centerY = SCREEN_HEIGHT * 0.5;
    }
    
    //马上显示当前图片的下载进度
    [self.progressView setProgress:self.topic.pictureProgress animated:YES];
    
    //下载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [self.progressView setProgress:1.0 * receivedSize / expectedSize animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    
    self.saveButton.backgroundColor = [UIColor redColor];
    [self.saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    
    if (self.imageView.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"图片并没下载完毕！"];
        return;
    }
    
    //将图片写入相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    }
}




@end
