//
//  LPAlertView.h
//  Lodger-Pad
//
//  Created by xun on 10/8/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "HMBasicDialogView.h"
@class AlertMsg;
@class HMAction;

typedef NS_ENUM(NSInteger, IconType) {
    IconWarn,       //!<⚠️icon
    IconTick,       //!<✅icon
    IconPhone       //!<电话图标
};


@interface LPAlertView : HMBasicDialogView

+ (instancetype)alertViewWithMsg:(NSString *)msg;

+ (instancetype)alertViewWithMsg:(NSString *)msg
                  greenBorderBtn:(void(^)(UIButton *btn))greenBorderBtn
                        greenBtn:(void(^)(UIButton *btn))greenBtn;

+ (instancetype)alertViewWithMsg:(NSString *)msg
                        iconType:(IconType)iconType
                  greenBorderBtn:(void(^)(UIButton *btn))greenBorderBtn
                        greenBtn:(void(^)(UIButton *btn))greenBtn;

+ (instancetype)alertViewWithMsg:(NSString *)msg
                       detailMsg:(NSString *)detailMsg
                  greenBorderBtn:(void(^)(UIButton *btn))greenBorderBtn
                        greenBtn:(void(^)(UIButton *btn))greenBtn;


//+ (instancetype)alertViewWithMsg:(NSString *)msg
//                       detailMsg:(NSString *)detailMsg
//                         actions:(NSArray <HMAction *>*)actions;

// 有三个按钮的弹窗

// 三个按钮的弹窗(左中右)

+ (instancetype)alertViewWithMsg:(NSString *)msg
                       detailMsg:(NSString *)detailMsg
                    leftBtnBlock:(void(^)(UIButton *btn))leftBtnBlock
                  middleBtnBlock:(void(^)(UIButton *btn))middleBtnBlock
                   rightBtnBlock:(void(^)(UIButton *btn))rightBtnBlock;

// 三个按钮的弹窗(上中下)
+ (instancetype)alertViewWithMsg:(NSString *)msg
                      upBtnBlock:(void(^)(UIButton *btn))upBtnBlock
                  middleBtnBlock:(void(^)(UIButton *btn))middleBtnBlock
                    downBtnBlock:(void(^)(UIButton *btn))downBtnBlock;

/**
 用自定义视图创建弹出对话框

 @param customView   自定义视图
 @param greenBorderBtn 绿边按钮
 @param greenBtn       绿色按钮

 @return 对话框
 */
+ (instancetype)alertViewWithCustomView:(UIView *)customView
                         greenBorderBtn:(void(^)(UIButton *btn))greenBorderBtn
                               greenBtn:(void(^)(UIButton *btn))greenBtn;


/**
 用自定义视图创建弹出对话框

 @param customerView 自定义视图
 @param isShow 是否需要显示右上角的关闭按钮
 @param titleLab 标题
 @param greenBorderBtn 绿边按钮
 @param greenBtn 绿色按钮
 
 @return 对话框
 */
+(instancetype)alertViewCustomerView:(UIView *)customerView isShowCloseBtn:(BOOL) isShow titleLab:(void (^)(UILabel *lab))titleLab greenBorderBtn:(void (^)(UIButton *btn))greenBorderBtn greenBtn:(void (^)(UIButton *btn))greenBtn;

/**
 字体大小、颜色自定义

 @param msgs           信息数组（数组元素为AlertMsg,默认颜色[UIColor blackColor],默认大小kFont(24),行间距默认10）
 @param iconType       弹窗icon类型
 @param greenBorderBtn 绿边按钮
 @param greenBtn       绿色按钮

 @return 对话框
 */
+ (instancetype)alertViewWithMsgs:(NSArray<AlertMsg *> *)msgs
                         iconType:(IconType)iconType
                   greenBorderBtn:(void(^)(UIButton *btn))greenBorderBtn
                         greenBtn:(void(^)(UIButton *btn))greenBtn;

- (void)showAndAutoRemovedAfterSecond:(NSTimeInterval)interval;

@end

@interface AlertMsg : NSObject

@property (nonatomic, copy) NSString *msg;//!<信息内容
@property (nonatomic, strong) UIFont *font;//!<字体大小
@property (nonatomic, strong) UIColor *color;//!<字体颜色
@property (nonatomic, assign) CGFloat lineSpace;//!<行间距

@end
