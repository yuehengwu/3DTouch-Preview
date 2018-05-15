//
//  PhotoPreviewController.m
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "PhotoPreviewController.h"

@interface PhotoPreviewController ()

@property (nonatomic, strong) NSMutableArray<UIImageView *>*imageViews;
//@property (nonatomic, strong) NSArray<NSURL *>*

@end

@implementation PhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
