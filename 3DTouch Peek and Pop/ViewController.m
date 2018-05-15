//
//  ViewController.m
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "ViewController.h"
#import "PreviewViewController.h"
#import "TouchView.h"
#import "RealPreviewViewController.h"

@interface ViewController () <UIViewControllerPreviewingDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Home";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    TouchView *touchView = [TouchView new];
    touchView.frame = CGRectMake(0, 0, 100, 100);
    touchView.center = self.view.center;
    [self.view addSubview:touchView];
    
    [self registerForPreviewingWithDelegate:self sourceView:touchView];
}

// peek
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    PreviewViewController *previewVC = [[PreviewViewController alloc]init];
    CGSize size = [previewVC setGifImages:[self wyh_imagesWithGif:@"Source.bundle/thief.gif"]];
    previewVC.preferredContentSize = size;
    return previewVC;
    
}

// pop
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
    [(PreviewViewController *)viewControllerToCommit stopPreviewing];
}

-(NSArray *)wyh_imagesWithGif:(NSString *)gifNameInBoundle {
    
    NSAssert(gifNameInBoundle, @"gif路径不得为空");
    
    NSString *dataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:gifNameInBoundle];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:dataPath], NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [imageArr addObject:image];
        CGImageRelease(imageRef);
    }
    return imageArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
