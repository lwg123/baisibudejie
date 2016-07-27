//
//  XMGRecommendCategory.h
//  百思不得姐
//
//  Created by weiguang on 16/5/24.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGRecommendCategory : NSObject
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger couunt;
@property (nonatomic,copy) NSString *name;

/** 这个类别对应的用户数据 */
@property (nonatomic, strong) NSMutableArray *users;
/** 总数 */
@property (nonatomic,assign) NSInteger total;
/** 当前页码 */
@property (nonatomic,assign) NSInteger currentPage;

@end
