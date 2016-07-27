//
//  XMGSettingViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/5/25.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGSettingViewController.h"
#import "XMGHelpViewController.h"
#import "XMGAboutMeViewController.h"
#import "XMGPrivatePolicyViewController.h"
#import "SDImageCache.h"


@interface XMGSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@end

@implementation XMGSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = XMGGlobalBg;
    [self getCaches];
}

//获取本地缓存大小
- (void)getCaches{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
    NSInteger totaleSize = 0;
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [manager attributesOfItemAtPath:filePath error:nil];
        if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        totaleSize += [attrs[NSFileSize] integerValue];
    }
    XMGLog(@"缓存大小：%zd",totaleSize);
}


//文件夹内部还有含有文件夹的情况
- (void)getCaches2{
    //图片缓存
    NSUInteger size = [SDImageCache sharedImageCache].getSize;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //文件夹
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
     NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    // 获得文件夹内部的所有内容
    //    NSArray *contents = [manager contentsOfDirectoryAtPath:cachePath error:nil];
    NSArray *subpaths = [manager subpathsAtPath:cachePath];
    XMGLog(@"%@", subpaths);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
        return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }
    return 25;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *tittle = nil;
    if (section == 0) {
        tittle = @"功能设置";
    } else{
        tittle = @"其他";
    }
    return tittle;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Setting";
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.textColor = XMGRGBColor(19,19,19);
        
        cell.backgroundColor =[UIColor whiteColor];
        UIView *separtor = [[UIView alloc]initWithFrame:CGRectMake(15, rect.size.height - 1, self.view.frame.size.width, 1)];
        separtor.backgroundColor = XMGRGBColor(238, 238, 244);
        [cell.contentView addSubview:separtor];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                NSArray *segmentArray = [NSArray arrayWithObjects:@"小",@"中",@"大", nil];
                UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:segmentArray];
                segment.center = CGPointMake(self.view.width - 50, cell.frame.size.height/2.0);
                segment.selectedSegmentIndex = 1;
                [cell.contentView addSubview:segment];
                cell.textLabel.text = @"字体大小";
            }
                break;
            case 1:
            {
                UISwitch *switcher = [[UISwitch alloc] init];
                switcher.onTintColor = [UIColor greenColor];
                switcher.on = NO;
                switcher.tag =0;
                switcher.center = CGPointMake(self.view.width - 40, cell.frame.size.height / 2.0);
                [switcher addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:switcher];
                cell.textLabel.text = @"转发时收藏";
            }
                break;
                case 2:
            {
                UISwitch *switcher = [[UISwitch alloc] init];
                switcher.onTintColor = [UIColor greenColor];
                switcher.on = NO;
                switcher.tag =1;
                switcher.center = CGPointMake(self.view.width - 40, cell.frame.size.height / 2.0);
                [switcher addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:switcher];
                 cell.textLabel.text = @"摇一摇夜间模式";
            }
            default:
                break;
        }
        
    } else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"离线下载";
            }
                break;
            case 1:
            {
                CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
                cell.textLabel.text = [NSString stringWithFormat:@"清除缓存（已使用%.2fMB）",size];
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"推荐给朋友";
            }
                break;
            case 3:
            {
                cell.textLabel.text = @"帮助";
            }
                break;
            case 4:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"当前版本：3.6";
            }
                break;
            case 5:
            {
                cell.textLabel.text = @"关于我们";
            }
                break;
            case 6:
            {
                cell.textLabel.text = @"设备信息";
            }
                break;
            case 7:
            {
                cell.textLabel.text = @"隐私政策";
            }
                break;
            case 8:
            {
                cell.textLabel.text = @"打分支持不得姐！";
            }
                break;
                
            default:
                break;
        }
    
    }

    return cell;
}

- (void)switchToggled:(UISwitch *)sender{
    switch (sender.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {    // 清除缓存
                // [[NSFileManager defaultManager] removeItemAtPath:<#(NSString *)#> error:<#(NSError *__autoreleasing *)#>];
                
                [[SDImageCache sharedImageCache] clearDisk];
                [self.settingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
                break;
            case 2:
            {
//                UIActionSheet *_markActionSheet = [[UIActionSheet alloc]initWithTitle:@"分享给好友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信",@"新浪微博",nil];
//                _markActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//                [_markActionSheet showInView:self.view];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享给好友" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击微信");
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"新浪微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了新浪微博");
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"取消");
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
                break;
            case 3:
            {
                XMGHelpViewController *VC = [[XMGHelpViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            case 4:
            {
                
            }
                break;
            case 5:
            {
                XMGAboutMeViewController *VC = [[XMGAboutMeViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            case 6:
            {
                
            }
                break;
            case 7:
            {
                XMGPrivatePolicyViewController *VC = [[XMGPrivatePolicyViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            case 8:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}
@end
