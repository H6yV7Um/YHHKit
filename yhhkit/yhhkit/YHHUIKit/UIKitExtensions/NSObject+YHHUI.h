//
//  NSObject+YHHUI.h
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YHHUI)
/**
 判断当前类是否有重写某个父类的指定方法
 
 @param selector 要判断的方法
 @param superclass 要比较的父类，必须是当前类的某个 superclass
 @return YES 表示子类有重写了父类方法，NO 表示没有重写（异常情况也返回 NO，例如当前类与指定的类并非父子关系、父类本身也无法响应指定的方法）
 */
- (BOOL)yhhui_hasOverrideMethod:(SEL)selector ofSuperclass:(Class)superclass;

/**
 判断指定的类是否有重写某个父类的指定方法
 
 @param selector 要判断的方法
 @param superclass 要比较的父类，必须是当前类的某个 superclass
 @return YES 表示子类有重写了父类方法，NO 表示没有重写（异常情况也返回 NO，例如当前类与指定的类并非父子关系、父类本身也无法响应指定的方法）
 */
+ (BOOL)yhhui_hasOverrideMethod:(SEL)selector forClass:(Class)aClass ofSuperclass:(Class)superclass;

/**
 对 super 发送消息
 
 @param aSelector 要发送的消息
 @return 消息执行后的结果
 @link http://stackoverflow.com/questions/14635024/using-objc-msgsendsuper-to-invoke-a-class-method @/link
 */
- (id)yhhui_performSelectorToSuperclass:(SEL)aSelector;

/**
 对 super 发送消息
 
 @param aSelector 要发送的消息
 @param object 作为参数传过去
 @return 消息执行后的结果
 */
- (id)yhhui_performSelectorToSuperclass:(SEL)aSelector withObject:(id)object;

/**
 *  系统的 performSelector 不支持参数或返回值为非对象的 selector 的调用，所以在 QMUI 增加了对应的方法，支持对象和非对象的 selector。
 *  这个方法用于无参数无返回值的 selector 调用。
 *  @param selector 要被调用的方法名
 */
- (void)yhhui_performSelector:(SEL)selector;

/**
 *  系统的 performSelector 不支持参数或返回值为非对象的 selector 的调用，所以在 QMUI 增加了对应的方法，支持对象和非对象的 selector。
 *  @param selector 要被调用的方法名
 *  @param returnValue selector 的返回值的指针地址
 */
- (void)yhhui_performSelector:(SEL)selector withReturnValue:(void *)returnValue;

/**
 *  系统的 performSelector 不支持参数或返回值为非对象的 selector 的调用，所以在 QMUI 增加了对应的方法，支持对象和非对象的 selector。
 *  @param selector 要被调用的方法名
 *  @param firstArgument 调用 selector 时要传的第一个参数的指针地址
 */
- (void)yhhui_performSelector:(SEL)selector withArguments:(void *)firstArgument, ...;

/**
 *  系统的 performSelector 不支持参数或返回值为非对象的 selector 的调用，所以在 QMUI 增加了对应的方法，支持对象和非对象的 selector。
 *
 *  使用示例：
 *  CGFloat result;
 *  CGFloat arg1, arg2;
 *  [self yhhui_performSelector:xxx withReturnValue:&result arguments:&arg1, &arg2, nil];
 *  // 到这里 result 已经被赋值为 selector 的 return 值
 *
 *  @param selector 要被调用的方法名
 *  @param returnValue selector 的返回值的指针地址
 *  @param firstArgument 调用 selector 时要传的第一个参数的指针地址
 */
- (void)yhhui_performSelector:(SEL)selector withReturnValue:(void *)returnValue arguments:(void *)firstArgument, ...;

/**
 使用 block 遍历当前实例的所有方法，父类的方法不包含在内
 */
- (void)yhhui_enumrateInstanceMethodsUsingBlock:(void (^)(SEL selector))block;

/**
 使用 block 遍历指定的某个类的实例方法，该类的父类方法不包含在内
 *  @param aClass   要遍历的某个类
 *  @param block    遍历时使用的 block，参数为某一个方法
 */
+ (void)yhhui_enumrateInstanceMethodsOfClass:(Class)aClass usingBlock:(void (^)(SEL selector))block;

/**
 遍历某个 protocol 里的所有方法
 
 @param protocol 要遍历的 protocol，例如 \@protocol(xxx)
 @param block 遍历过程中调用的 block
 */
+ (void)yhhui_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL selector))block;
@end

#pragma mark -
#pragma mark 判断对象有无
@interface NSObject (YHHUI_NOTNULL)
/**
 数据非空判断,字符串数组字典如已初始化,但内容为空,判断为YES
 
 @return 是否为空
 */
-(BOOL)yhhui_isNotNull;

/**
 数据内容非空判断,字符串数组字典如已初始化,但内容为空,判断为NO
 
 @return 是否为空
 */
-(BOOL)yhhui_isNotEmpty;
@end

