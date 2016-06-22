//
//  WYLInputView.h
//  ABoutText
//
//  Created by ycd15 on 16/6/22.
//  Copyright © 2016年 YCD_WYL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+ExtendFrame.h"

typedef NS_ENUM(NSInteger, InputType) {
    wTextField = 0,
    wTextView
};

@interface WYLInputView : UIView

//Move View
@property (nonatomic, strong, readonly) UIView * referView;

//UI
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UITextView * textView;

//Animation duration
@property (nonatomic, assign) CGFloat keyBoardDuration;



//view type
@property (nonatomic, assign) InputType inputType;



//limit length
@property (nonatomic, assign) NSInteger maxLength;

//placeHodle (textField/textView)
@property (nonatomic, copy) NSString * placeHolder;



//block action  with none referView
@property (nonatomic, copy) void (^keyBoardFrameBack) (CGRect keyBoardFrame,CGFloat duration);
@property (nonatomic, copy) void (^keyBoardShowWithSuperViewMove) (CGFloat differ,CGFloat duration);



//init type/ referView(move View)
- (instancetype)initWithFrame:(CGRect)frame type:(InputType)type;
- (instancetype)initWithFrame:(CGRect)frame type:(InputType)type referView:(UIView *)referView;



//endEditing
- (void)endEditing:(BOOL)force;

@end
