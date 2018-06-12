//
//  YHHModel.h
//  PublicUIKit
//
//  Created by Macbook on 2018/5/14.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 所有继承于YHHModel或YHHModel子类的模型均能存进数据库(为数据库支持类型)
 */
@interface YHHModel : NSObject<NSCoding,NSCopying>

@end
