//
//  ViewController.m
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "ViewController.h"

#import "Wyh3DTouchPhotoPreviewer.h"

@interface ViewController () <Wyh3DTouchPhotoPreviewerDelegate>

@property (nonatomic, strong) Wyh3DTouchPhotoPreviewer *previewer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Home";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *touchView = [UIView new];
    touchView.backgroundColor = [UIColor blackColor];
    touchView.frame = CGRectMake(0, 0, 100, 100);
    touchView.center = self.view.center;
    [self.view addSubview:touchView];
    
    [self.previewer registerForPreviewingWithSourceView:touchView];
    
}

- (Wyh3DTouchPhotoPreviewer *)previewer {
    if (!_previewer) {
        _previewer = [Wyh3DTouchPhotoPreviewer previewerWithDelegate:self];
    }
    return _previewer;
}

#pragma mark - Wyh3DTouchPhotoPreviewerDelegate

- (NSString *)wyh3DTouchPhotoPathWithSourceView:(UIView *)sourceView {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Source.bundle/thief.gif"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
