//
//  NSObject+YHHUI.m
//  yhhkit
//
//  Created by Macbook on 2018/5/15.
//  Copyright © 2018年 Ehanghai. All rights reserved.
//

#import "NSObject+YHHUI.h"
#import <objc/message.h>
#import <objc/runtime.h>



@implementation NSObject (YHHUI)
- (BOOL)yhhui_hasOverrideMethod:(SEL)selector ofSuperclass:(Class)superclass {
    return [NSObject yhhui_hasOverrideMethod:selector forClass:self.class ofSuperclass:superclass];
}

+ (BOOL)yhhui_hasOverrideMethod:(SEL)selector forClass:(Class)aClass ofSuperclass:(Class)superclass {
    if (![aClass isSubclassOfClass:superclass]) {
        return NO;
    }
    
    if (![superclass instancesRespondToSelector:selector]) {
        return NO;
    }
    
    Method superclassMethod = class_getInstanceMethod(superclass, selector);
    Method instanceMethod = class_getInstanceMethod(aClass, selector);
    if (!instanceMethod || instanceMethod == superclassMethod) {
        return NO;
    }
    return YES;
}

- (id)yhhui_performSelectorToSuperclass:(SEL)aSelector {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector);
}

- (id)yhhui_performSelectorToSuperclass:(SEL)aSelector withObject:(id)object {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL, ...) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector, object);
}

- (void)yhhui_performSelector:(SEL)selector {
    [self yhhui_performSelector:selector withReturnValue:NULL arguments:NULL];
}

- (void)yhhui_performSelector:(SEL)selector withArguments:(void *)firstArgument, ... {
    [self yhhui_performSelector:selector withReturnValue:NULL arguments:firstArgument, NULL];
}

- (void)yhhui_performSelector:(SEL)selector withReturnValue:(void *)returnValue {
    [self yhhui_performSelector:selector withReturnValue:returnValue arguments:NULL];
}

- (void)yhhui_performSelector:(SEL)selector withReturnValue:(void *)returnValue arguments:(void *)firstArgument, ... {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        [invocation setArgument:firstArgument atIndex:2];
        
        va_list args;
        va_start(args, firstArgument);
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(args, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(args);
    }
    
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

- (void)yhhui_enumrateInstanceMethodsUsingBlock:(void (^)(SEL))block {
    [NSObject yhhui_enumrateInstanceMethodsOfClass:self.class usingBlock:block];
}

+ (void)yhhui_enumrateInstanceMethodsOfClass:(Class)aClass usingBlock:(void (^)(SEL selector))block {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(aClass, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        if (block) block(selector);
    }
    
    free(methods);
}

+ (void)yhhui_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL))block {
    unsigned int methodCount = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methods[i];
        if (block) {
            block(methodDescription.name);
        }
    }
    free(methods);
}

@end

@implementation NSObject (YHHUI_NOTNULL)

-(BOOL)yhhui_isNotNull{
    if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null]){
        return YES;
    }
    return NO;
}

-(BOOL)yhhui_isNotEmpty{
    if([self isKindOfClass:[NSArray class]] ||
       [self isKindOfClass:[NSMutableArray class]] ||
       [self isKindOfClass:[NSSet class]] ||
       [self isKindOfClass:[NSMutableSet class]] ||
       [self isKindOfClass:[NSDictionary class]] ||
       [self isKindOfClass:[NSMutableDictionary class]]){
        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(count)] && [self performSelector:@selector(count) withObject:nil]>0){
            return YES;
        }
        return NO;
    }
    //    if([self isKindOfClass:[NSSet class]] ||
    //       [self isKindOfClass:[NSMutableSet class]]){
    //        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(count)] && [(NSSet *)self count]>0){
    //            return YES;
    //        }
    //        return NO;
    //    }
    //    if([self isKindOfClass:[NSDictionary class]] ||
    //       [self isKindOfClass:[NSMutableDictionary class]]){
    //        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(count)] && [(NSDictionary *)self count]>0){
    //            return YES;
    //        }
    //        return NO;
    //    }
    if([self isKindOfClass:[NSString class]]){
        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(length)] && [(NSString *)self length]>0){
            return YES;
        }
        return NO;
    }
    if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null]){
        return YES;
    }
    return NO;
}
@end
