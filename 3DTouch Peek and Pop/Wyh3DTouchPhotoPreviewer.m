//
//  WyhPhotoPreviewer.m
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "Wyh3DTouchPhotoPreviewer.h"
#import "WyhPhotoPreviewController.h"

@interface Wyh3DTouchPhotoPreviewer ()<UIViewControllerPreviewingDelegate>


@property (nonatomic, weak) UIViewController *peekController;

@end

@implementation Wyh3DTouchPhotoPreviewer

+ (instancetype)previewerWithPeekController:(UIViewController *)controller {
    
    NSAssert(controller, @"Wyh3DTouchPhotoPreviewer must need a controller !");
    
    Wyh3DTouchPhotoPreviewer *previewer = [[Wyh3DTouchPhotoPreviewer alloc]init];
    previewer.peekController = controller;
    return previewer;
}

- (void)registerForPreviewingWithSourceView:(UIView *)sourceView {
    
    NSAssert(sourceView, @"register must need a sourceView !");
    
    if (self.peekController.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self.peekController registerForPreviewingWithDelegate:self sourceView:sourceView];
    }
    
    // If current iPhone don't support 3DTouch
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressIfDontSupport3DTouch:)];
    sourceView.userInteractionEnabled = YES;
    [sourceView addGestureRecognizer:longpress];
}

- (void)longPressIfDontSupport3DTouch:(UILongPressGestureRecognizer *)longpress {
    
//    UIView *sourceView = longpress.view;
    
    if (longpress.state == UIGestureRecognizerStateEnded) {
        // 向下兼容
    }
    
}

-(NSArray *)gifWithPath:(NSString *)gifpath {
    
    NSAssert(gifpath, @"gif path invalid !");
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:gifpath], NULL);
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

#pragma mark - UIViewControllerPreviewingDelegate

// peek
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
//    if (![self.dataSource respondsToSelector:@selector(wyh3DTouchPhotoPathWithSourceView:)]) {
//        NSAssert(NO, @"delegate must implete 'wyh3DTouchPhotoPathWithSourceView:'");
//    }
    if (![self.dataSource respondsToSelector:@selector(wyh3DTouchGifArrWithSourceView:)]) {
        NSAssert(NO, @"delegate must implete 'wyh3DTouchGifArrWithSourceView:'");
    }
    
    WyhPhotoPreviewController *previewVC = [[WyhPhotoPreviewController alloc]init];
    NSArray *gifs = [self.dataSource wyh3DTouchGifArrWithSourceView:previewingContext.sourceView];
//    gifs = [self gifWithPath:[self.dataSource wyh3DTouchPhotoPathWithSourceView:previewingContext.sourceView]];
    CGSize size = [previewVC setGifImages:gifs];
    previewVC.preferredContentSize = size;
    return previewVC;
    
}

// pop
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self.peekController.navigationController pushViewController:viewControllerToCommit animated:YES];
    [(WyhPhotoPreviewController *)viewControllerToCommit stopPreviewing];
}

#pragma mark - lazy


@end
