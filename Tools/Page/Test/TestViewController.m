//
//  TestViewController.m
//  Tools
//
//  Created by 张书孟 on 2018/3/5.
//  Copyright © 2018年 张书孟. All rights reserved.
//

#import "TestViewController.h"
#import "NSDate+Extension.h"
#import "HYBImageCliped.h"
#import <Masonry.h>

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(100, 64, 100, 100)];
////    [test hyb_setImage:[UIImage imageNamed:@"0"] size:CGSizeMake(100, 100) cornerRadius:50.0 rectCorner:(UIRectCornerAllCorners) backgroundColor:[UIColor whiteColor] isEqualScale:NO onCliped:^(UIImage *clipedImage) {
////
////    }];
//    test.backgroundColor = [UIColor redColor];
//    [test hyb_addCorner:UIRectCornerAllCorners cornerRadius:20];
//    [self.view addSubview:test];
    
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 100, 200, 30)];
    sc.backgroundColor = [UIColor redColor];
    sc.contentSize = CGSizeMake(4 * self.view.frame.size.width, 0);
    [self.view addSubview:sc];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"labellabellabellabellabellabellabellabellabellabellabellabellabellabellabellabellabellabellabellabel";
    [sc addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(sc);
    }];
    
    
    
    
    
    
    
    
    
    
}




@end
