//
//  XMGRecommendTagsViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/5/25.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGRecommendTagsViewController.h"
#import "XMGRecomendTags.h"
#import "XMGRecommendTagCell.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"


@interface XMGRecommendTagsViewController ()
//标签数据
@property (nonatomic,strong) NSArray *tags;

@end

@implementation XMGRecommendTagsViewController

static NSString * const ID = @"tag";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self loadTags];
    
}

- (void)loadTags{
    
    [SVProgressHUD showWithStatus:@"正在加载数据" maskType:SVProgressHUDMaskTypeBlack];
    
    //请求参数
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"a"] = @"tag_recommend";
    parmas[@"c"] = @"topic";
    parmas[@"action"] = @"sub";
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parmas progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //XMGLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        self.tags = [XMGRecomendTags mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载标签数据失败!"];
    }];
}

- (void)setupTableView{

    self.title = @"推荐标签";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = XMGGlobalBg;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMGRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.recommendTag = self.tags[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
