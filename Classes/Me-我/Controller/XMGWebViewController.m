//
//  XMGWebViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/7/4.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface XMGWebViewController()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** 进度代理对象 */
@property (nonatomic, strong) NJKWebViewProgress *progress;
@end

@implementation XMGWebViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progress;
    __weak typeof(self) weakSelf = self;
    
    self.progress.progressBlock = ^(float progress){
        weakSelf.progressView.progress = progress;
        weakSelf.progressView.hidden = (progress == 1.0);
        
    };
    self.progress.webViewProxyDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
- (IBAction)refresh:(id)sender {
    [self.webView reload];
}
- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}

#pragma mark - <UIWebViewDelegate>
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.goBackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
}

@end
