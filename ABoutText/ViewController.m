//
//  ViewController.m
//  ABoutText
//
//  Created by ycd15 on 16/6/22.
//  Copyright © 2016年 YCD_WYL. All rights reserved.
//

#import "ViewController.h"

#import "WYLInputView.h"

@interface ViewController ()

@property (nonatomic, strong) WYLInputView * inView;
@property (nonatomic, strong) WYLInputView * sinView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"+++++++++++++++++++++++");
    WYLInputView * view = [[WYLInputView alloc] initWithFrame:CGRectMake(10, 350, 200, 100) type:wTextView referView:self.view];
    view.placeHolder = @"Hello World";
    view.maxLength = 15;
    view.textView.backgroundColor = [UIColor yellowColor];
    self.inView = view;
//    __block typeof(WYLInputView *) blockView = view;
//    view.keyBoardFrameBack = ^(CGRect frame, CGFloat duration) {
//        CGFloat boardY = frame.origin.y;
//        CGFloat maxViewY = CGRectGetMaxY(blockView.frame);
//        if (maxViewY > boardY) {
//            [UIView animateWithDuration:duration animations:^{
//                self.view.frame = CGRectMake(0, 0, [UIScreen.mainScreen bounds].size.width, -(maxViewY - boardY));
//            }];
//        }
//    };
    
//    view.keyBoardShowWithSuperViewMove = ^ (CGFloat mixDiffer, CGFloat duration) {
//        [UIView animateWithDuration:duration animations:^{
//            self.view.frame = CGRectMake(0, 0, [UIScreen.mainScreen bounds].size.width, -mixDiffer);
//        }];
//    };
    
    [self.view addSubview:view];
    
    WYLInputView * sview = [[WYLInputView alloc] initWithFrame:CGRectMake(200, 400, 100, 100) type:wTextField referView:self.view];
    sview.placeHolder = @"Hello World";
    sview.maxLength = 15;
    sview.textView.backgroundColor = [UIColor yellowColor];
    self.sinView = sview;
    [self.viewIfLoaded addSubview:sview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inView endEditing:YES];
    [self.sinView endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
