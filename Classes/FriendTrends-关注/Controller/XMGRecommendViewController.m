//
//  XMGRecommendViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/5/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGRecommendViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XMGRecommendCategoryCell.h"
#import "XMGRecommendCategory.h"
#import "MJExtension.h"
#import "XMGRecommendUserCell.h"
#import "XMGRecommendUser.h"
#import "MJRefresh.h"

#define XMGSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface XMGRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 左边的类别数据 */
@property (nonatomic, strong) NSArray *categories;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
//请求参数
@property (nonatomic,strong) NSMutableDictionary *params;
//AFN请求管理者
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation XMGRecommendViewController

static NSString * const XMGCategoryId = @"category";
static NSString * const XMGUserId = @"user";

- (AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 控件的初始化
    [self setupTableView];
    
    //添加刷新控件
    [self setupRefresh];
    
    [self loadCategories];
}

/**
 * 加载左侧的类别数据
 */
- (void)loadCategories{
    //设置指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    //发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        // XMGLog(@"%@", responseObject);
        //服务器返回的Json数据转成模型
        self.categories = [XMGRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.categoryTableView reloadData];
        // 默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
         [self.userTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];

}

//添加刷新控件
- (void)setupRefresh{
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewUsers];
    }];
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreUsers];
    }];
    self.userTableView.mj_footer.hidden = YES;
}
- (void)setupTableView{
    //注册
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:XMGCategoryId];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:XMGUserId];
    
    //设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.rowHeight = 70;
    self.title = @"推荐关注";
    self.categoryTableView.backgroundColor = XMGRGBColor(244, 244, 244);
    self.categoryTableView.tableFooterView = [[UIView alloc] init];
    self.userTableView.tableFooterView = [[UIView alloc] init];
    self.userTableView.backgroundColor = XMGRGBColor(244, 244, 244);
}

#pragma mark - 加载用户数据
- (void)loadNewUsers{
    XMGRecommendCategory *rc = XMGSelectedCategory;
    rc.currentPage = 1;
    
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.id);
    params[@"page"] = @(rc.currentPage);
    self.params = params;
    
    //发送请求加载右侧数据
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典->模型
        NSArray *users = [XMGRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //清除所有旧数据
        [rc.users removeAllObjects];
        //添加到当前类别对应的用户数组中
        [rc.users addObjectsFromArray:users];
        //保存总数
        rc.total = [responseObject[@"total"] integerValue];
        
        //不是最后一次请求
        if (self.params != params) return;
        
        //刷新右边的表格
        [self.userTableView reloadData];
        
        //结束刷新
        [self.userTableView.mj_header endRefreshing];
        
        //底部控件结束刷新
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreUsers{
    XMGRecommendCategory *category = XMGSelectedCategory;
    
    // 发送请求给服务器, 加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.id);
    params[@"page"] = @(++category.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 字典数组 -> 模型数组
        NSArray *users = [XMGRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        // 刷新右边的表格
        [self.userTableView reloadData];
        
        // 让底部控件结束刷新
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.userTableView.mj_footer endRefreshing];
    }];

}

/**
 * 时刻监测footer的状态
 */
- (void)checkFooterState{
    XMGRecommendCategory *rc = XMGSelectedCategory;
    self.userTableView.mj_footer.hidden = (rc.users.count == 0);
    
    //让底部控件结束刷新
    if (rc.users.count == rc.total) {
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
        
    } else{
        [self.userTableView.mj_footer endRefreshing];
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.categoryTableView) {
        return self.categories.count;
    } else{
        [self checkFooterState];
        return [XMGSelectedCategory users].count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        XMGRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGCategoryId];
        cell.catagory = self.categories[indexPath.row];
        return cell;
    } else{
        XMGRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGUserId];
        
        cell.user = [XMGSelectedCategory users][indexPath.row];
        return cell;
    }
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 结束刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
    XMGRecommendCategory *c = self.categories[indexPath.row];
        if (c.users.count) {
            //显示曾经的数据
            [self.userTableView reloadData];
        } else{
            // 赶紧刷新表格,目的是: 马上显示当前category的用户数据, 不让用户看见上一个category的残留数据
            [self.userTableView reloadData];
            
            // 进入下拉刷新状态
            [self.userTableView.mj_header beginRefreshing];
        }

}

- (void)dealloc{
    [self.manager.operationQueue cancelAllOperations];
}

@end
