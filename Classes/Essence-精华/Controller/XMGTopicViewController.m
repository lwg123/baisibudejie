//
//  XMGTopicViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/6/9.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGTopicViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "XMGTopics.h"
#import "MJRefresh.h"
#import "XMGTopicsCell.h"
#import "XMGCmtViewController.h"
#import "XMGNewViewController.h"

static NSString *ID = @"cell";

@interface XMGTopicViewController ()
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;
/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation XMGTopicViewController

- (NSMutableArray *)topics{
    if (_topics == nil) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    //添加刷新控件
    [self setupRefresh];
    
}

//初始化tableView
- (void)setupTableView{
    //设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = XMGTitilesViewY + XMGTitilesViewH;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGTopicsCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    //监听tabbar点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSelect) name:XMGTabBarDidSelectNotification object:nil];
}

- (void)tabBarSelect{
    //如果连续选中2次，直接刷新
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}


- (void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewTopics];
        
    }];
    //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreTopics];
    } ];
}

//参数 a
- (NSString *)a{
    return [self.parentViewController isKindOfClass:[XMGNewViewController class]] ? @"newlist" : @"list";
}

- (void)loadNewTopics{
    //结束上拉
    [self.tableView.mj_footer endRefreshing];
    //请求参数
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"a"] = self.a;
    parmas[@"c"] = @"data";
    parmas[@"type"] = @(self.type);
    self.params = parmas;
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parmas progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        // 字典 -> 模型
        self.topics = [XMGTopics mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        //清空页码
        self.page = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != parmas) return;
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTopics{
    
    //结束下拉
    [self.tableView.mj_header endRefreshing];
    NSInteger page = self.page + 1;
    //请求参数
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"a"] = @"list";
    parmas[@"c"] = @"data";
    parmas[@"type"] = @(self.type);
    parmas[@"page"] = @(page);
    parmas[@"maxtime"] = self.maxtime;
    self.params = parmas;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parmas progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 字典 -> 模型
        NSArray *newTopics = [XMGTopics mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        //设置页码
        self.page = page;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != parmas) return;
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    }];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XMGTopicsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XMGTopics *topic = self.topics[indexPath.row];
    return topic.cellHeight;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMGCmtViewController *cmtVC = [[XMGCmtViewController alloc] init];
    cmtVC.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:cmtVC animated:YES];
}

@end
