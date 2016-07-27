//
//  XMGCmtViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/6/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGCmtViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XMGTopicsCell.h"
#import "AFNetworking.h"
#import "XMGComment.h"
#import "XMGTopics.h"
#import "UIImageView+WebCache.h"
#import "XMGUser.h"
#import "XMGCommentHeaderView.h"
#import "XMGCommentCell.h"

static NSString * const XMGCommentId = @"comment";
@interface XMGCmtViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;

/** 保存帖子的top_cmt */
@property (nonatomic,strong) XMGComment *saved_top_cmt;
//保存当前页码
@property (nonatomic,assign) NSInteger page;
/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation XMGCmtViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBasic];
    
    [self setupHeader];
    
    [self setupRefresh];
}

- (void)setupHeader{
    UIView *header = [[UIView alloc] init];
    
    //清空top_cmt
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    //添加cell
    XMGTopicsCell *cell = [XMGTopicsCell viewFromXib];
    cell.topic = self.topic;
    cell.size =CGSizeMake(SCREEN_WIDTH, self.topic.cellHeight);
    [header addSubview:cell];
    
    //header的高度
    header.height = self.topic.cellHeight;
    //设置header
    self.tableView.tableHeaderView = header;
    
}

- (void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewComments];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreComments];
    } ];
    self.tableView.mj_footer.hidden = YES;
}

- (void)loadNewComments{
    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //最热评论
        self.hotComments = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        //最新评论
        self.latestComments = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //页码
        self.page = 1;
        
        //刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreComments{
    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    

    NSInteger page = self.page + 1;
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    XMGComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //最新评论
        NSArray *newComments = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        self.page = page;
        
        //刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        } else {
            // 结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];

}
- (void)setBasic{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:self action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.tableView.backgroundColor = XMGGlobalBg;
    //cell高度设置，自动调整高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGCommentCell class]) bundle:nil] forCellReuseIdentifier:XMGCommentId];
    
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}

- (void)keyboardWillChangeFrame:(NSNotification *)note{
    
    //键盘显示/隐藏之后的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //修改底部约束
    self.bottom.constant = SCREEN_HEIGHT - frame.origin.y;
    //动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //动画布局
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //恢复帖子的top_cmt
    if (self.saved_top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
}

//没被调用
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    //恢复帖子的top_cmt
//    if (self.saved_top_cmt) {
//        self.topic.top_cmt = self.saved_top_cmt;
//        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
//    }
//}
//返回section组的所有评论数组
- (NSArray *)commentInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

- (XMGComment *)commentInIndexPath:(NSIndexPath *)indexPath{
    return [self commentInSection:indexPath.section][indexPath.row];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    //隐藏尾部上拉刷新控件
    tableView.mj_footer.hidden = (latestCount == 0);
    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    
    // 非第0组
    return latestCount;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        return hotCount ? @"最热评论" : @"最新评论";
//    }
//    return @"最新评论";
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    XMGCommentHeaderView *header = [XMGCommentHeaderView headerViewWithTableView:tableView];
    //设置label的数据
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
       header.title = hotCount ? @"最热评论" : @"最新评论";
    } else{
        header.title = @"最新评论";
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGCommentId];
    cell.comment = [self commentInIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
        
    } else{
        XMGCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];

        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report= [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        
        menu.menuItems = @[ding,replay,report];
        CGRect rect = CGRectMake(0, cell.frame.size.height/2, cell.width, cell.height/2);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}


- (void)ding:(id)sender {
     NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)replay:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)report:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}



@end
