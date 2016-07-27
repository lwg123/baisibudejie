//
//  XMGUser.h
//  百思不得姐
//
//  Created by weiguang on 16/6/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGUser : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
@end
