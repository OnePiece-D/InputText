//
//  WYLInputView.m
//  ABoutText
//
//  Created by ycd15 on 16/6/22.
//  Copyright © 2016年 YCD_WYL. All rights reserved.
//

#import "WYLInputView.h"

#define wMinSpace 2

@interface WYLInputView()<UITextFieldDelegate,UITextViewDelegate>
{
    CGRect _frame;
    
    //keyBoard frame/AnimationTime
    CGRect _keyBoardFrame;
    CGFloat _keyBoardDuration;
    //move - y
    CGFloat _boardY;
    CGFloat _maxViewY;
}

@property (nonatomic, strong, readwrite) UIView * referView;

@property (nonatomic, strong) UILabel * placeholderLabel;//textView placeholder

@end

@implementation WYLInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _maxLength = NSIntegerMax;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame type:(InputType)type {
    if ([self initWithFrame:frame]) {
        _frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _inputType = type;
        
        if (type == wTextView) {
            [self addSubview:self.textView];
            [self.textView addSubview:self.placeholderLabel];
            
            [self.placeholderLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
            
        }else if(type == wTextField) {
            [self addSubview:self.textField];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(InputType)type referView:(UIView *)referView {
    if ([self initWithFrame:frame type:type]) {
        _referView = referView;
        
    }
    return self;
}

#pragma mark -self method-
- (void)endEditing:(BOOL)force {
    if (_inputType == wTextView) {
        [self.textView endEditing:force];
    }else if (_inputType == wTextField) {
        [self.textField endEditing:force];
    }
}

- (void)pathMoveActionBlock:(CGFloat)boardY maxViewY:(CGFloat)maxViewY showBoard:(BOOL)show {
    if (self.keyBoardFrameBack) {
        self.keyBoardFrameBack(_keyBoardFrame,_keyBoardDuration);
        return;
    }
    CGFloat differVer = maxViewY - boardY + wMinSpace;
    if (self.keyBoardShowWithSuperViewMove) {
        
        if (maxViewY > boardY) {
            //向上移动 > 0
            self.keyBoardShowWithSuperViewMove(differVer, _keyBoardDuration);
            return;
        }
    }
    
    if (_referView) {
        
        if (show) {
            [UIView animateWithDuration:_keyBoardDuration animations:^{
                _referView.y -= differVer;
            }];
        }else {
            [UIView animateWithDuration:_keyBoardDuration animations:^{
                _referView.y += differVer;
            }];
        }
        
    }
}


#pragma mark -属性set-
- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = [placeHolder copy];
    
    if (_inputType == wTextView) {
        self.placeholderLabel.text = placeHolder;
    }else if (_inputType == wTextField) {
        self.textField.placeholder = placeHolder;
    }
}

#pragma mark -custom keyPath/Change-
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.placeholderLabel) {
        if ([keyPath isEqualToString:@"text"]) {
            NSString * textStr = self.placeholderLabel.text;
            CGSize size = [textStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
            self.placeholderLabel.frame = CGRectMake(5, 5, size.width, size.height);
            
        }
    }
}


#pragma mark -KeyBoard show/hiden-   //在共用多了就不对了
- (void)keyBoardWillShow:(NSNotification *)notif {
    _keyBoardFrame = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyBoardDuration = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    _boardY = _keyBoardFrame.origin.y;
    _maxViewY = CGRectGetMaxY(self.frame);
    
    /*
    if (self.keyBoardFrameBack) {
        self.keyBoardFrameBack(_keyBoardFrame,_keyBoardDuration);
        return;
    }
    
    if (self.keyBoardShowWithSuperViewMove) {
        
        if (maxViewY > boardY) {
            //向上移动 > 0
            self.keyBoardShowWithSuperViewMove(maxViewY - boardY + wMinSpace, _keyBoardDuration);
            return;
        }
    }
    
    if (_referView) {
        [UIView animateWithDuration:_keyBoardDuration animations:^{
            _referView.y -= maxViewY - boardY + wMinSpace;
        }];
    }
     */
}

- (void)keyBoardWillHide:(NSNotification *)notif {
    _boardY = _keyBoardFrame.origin.y;
    _maxViewY = CGRectGetMaxY(self.frame);
    
    /*
    if (self.keyBoardFrameBack) {
        self.keyBoardFrameBack(_keyBoardFrame,_keyBoardDuration);
        return;
    }
    
    if (self.keyBoardShowWithSuperViewMove) {
        
        if (maxViewY > boardY) {
            
            self.keyBoardShowWithSuperViewMove(-(maxViewY - boardY + wMinSpace), _keyBoardDuration);
            return;
        }
    }
    
    if (_referView) {
        [UIView animateWithDuration:_keyBoardDuration animations:^{
            _referView.y += maxViewY - boardY + wMinSpace;
        }];
    }
     */
}

#pragma mark -textView Delegate-
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger strLength = textView.text.length - range.length + text.length;
    return strLength <= _maxLength;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeholderLabel.text = _placeHolder;
    }else {
        self.placeholderLabel.text = @"";
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self pathMoveActionBlock:_boardY maxViewY:_maxViewY showBoard:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self pathMoveActionBlock:_boardY maxViewY:_maxViewY showBoard:NO];
}

#pragma mark -textField Delegate-
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger strLength = textField.text.length - range.length + string.length;
    return strLength <= _maxLength;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self pathMoveActionBlock:_boardY maxViewY:_maxViewY showBoard:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self pathMoveActionBlock:_boardY maxViewY:_maxViewY showBoard:NO];
}

#pragma mark -Lazing-
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:_frame];
        
        _textView.delegate = self;
    }
    return _textView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:_frame];
        
        _textField.delegate = self;
    }
    return _textField;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        
        _placeholderLabel.userInteractionEnabled = YES;
        
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.textColor = [UIColor grayColor];
    }
    return _placeholderLabel;
}

#pragma mark -dealloc-
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
