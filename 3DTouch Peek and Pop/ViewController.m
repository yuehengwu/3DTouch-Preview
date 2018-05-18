//
//  ViewController.m
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "ViewController.h"

#import "Wyh3DTouchPhotoPreviewer.h"

@interface ViewController () <Wyh3DTouchPhotoPreviewerDataSource>

@property (nonatomic, strong) Wyh3DTouchPhotoPreviewer *previewer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"3D Touch";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *touchView = [[UILabel alloc]init];
    touchView.backgroundColor = [UIColor blackColor];
    touchView.textColor = [UIColor whiteColor];
    touchView.text = @"Touch Me";
    touchView.textAlignment = NSTextAlignmentCenter;
    touchView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 120);
    touchView.center = self.view.center;
    touchView.layer.cornerRadius = 75.f;
    [self.view addSubview:touchView];
    
    [self.previewer registerForPreviewingWithSourceView:touchView];
    
}

- (Wyh3DTouchPhotoPreviewer *)previewer {
    if (!_previewer) {
        _previewer = [Wyh3DTouchPhotoPreviewer previewerWithPeekController:self];
        _previewer.dataSource = self;
    }
    return _previewer;
}

#pragma mark - Wyh3DTouchPhotoPreviewerDelegate

- (NSString *)wyh3DTouchPhotoPathWithSourceView:(UIView *)sourceView {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Source.bundle/thief.gif"];
}

- (NSArray<UIImage *> *)wyh3DTouchGifArrWithSourceView:(UIView *)sourceView {
    NSMutableArray *gif = [NSMutableArray new];
    for (int i = 0; i < 6; i++) {
        NSString *imgNamePath = [NSString stringWithFormat:@"Source.bundle/test%d.jpg",i+1];
        UIImage *image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imgNamePath]];
        [gif addObject:image];
    }
    return gif;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
