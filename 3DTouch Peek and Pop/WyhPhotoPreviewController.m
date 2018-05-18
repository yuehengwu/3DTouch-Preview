//
//  PreviewViewController.m
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "WyhPhotoPreviewController.h"
#import "WyhPhotoSelectorService.h"

@interface WyhPhotoPreviewController ()

@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray<UIImage *>* gifs;
@property (nonatomic, strong) NSMutableArray<UIImageView *>* gifImageViews;

@property (nonatomic, strong) WyhPhotoSelectorService *photoService;

@end

@implementation WyhPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Alarm Photo";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.gifImageView];
}

- (void)dealloc {
    
}

#pragma mark - OverWrite

- (void)startPreviewing {
    
    if (self.gifImageView.animationImages.count > 0 && !self.gifImageView.isAnimating) {
        
        [self.gifImageView startAnimating];
        self.gifImageView.center = self.view.center;
    }
}

- (void)stopPreviewing {
    
    self.gifImageView.center = self.view.center;
    
    [self reconfigUIIfPreviewStopped];
}

#pragma mark - Privte Function

- (void)reconfigUIIfPreviewStopped {
    
    [self.gifImageView stopAnimating];
    self.gifImageView.hidden = YES;
    
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
    
    self.gifImageViews = [NSMutableArray new];
    
    CGFloat edgeX = 5.f, imgW = (UIScreen.mainScreen.bounds.size.width - edgeX*3)/2;
    CGFloat imgH = self.gifImageView.bounds.size.height*imgW/self.gifImageView.bounds.size.width;
    CGFloat edgeY = 5.f;
    UIView *lastImg = NULL;
    for (int i = 0; i < self.gifs.count; i++) {
        @autoreleasepool {
            UIImage *img = self.gifs[i];
            UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
            CGFloat imgX = (i%2==0)?edgeX:(imgW+2*edgeX);
            CGFloat imgY = (i%2==0) ? (!lastImg?(64.f+edgeY+24.f):CGRectGetMaxY(lastImg.frame)+edgeY) : (lastImg.frame.origin.y);
            imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
            [self.scrollView addSubview:imgView];
            lastImg = imgView;
            // tap
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageIntoSelector:)];
            [imgView addGestureRecognizer:tap];
            
            [self.gifImageViews addObject:imgView];
        }
    }
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(lastImg.frame) + edgeY);
}

- (void)tapImageIntoSelector:(UITapGestureRecognizer *)tapges {
    
    UIImageView *imgView = (UIImageView *)tapges.view;
    NSInteger index = [self.gifImageViews indexOfObject:imgView];
    
    self.photoService.localImages = [self.gifs copy];
    [self.photoService showPhotoWithIndex:index SourceController:self];
    
}

#pragma mark - API

- (CGSize)setGifImages:(NSArray<UIImage *>*)gifImages {
    
    _gifs = [gifImages copy];
    CGSize originalSize = CGSizeZero;
    
    if (gifImages.count > 0) {
        self.gifImageView.animationImages = [gifImages copy];
        self.gifImageView.animationDuration = 0.2 * gifImages.count;
        self.gifImageView.animationRepeatCount = MAXFLOAT;
        [self.gifImageView sizeToFit];
        originalSize = self.gifImageView.bounds.size;
    }
    return originalSize;
}

#pragma mark - previewActionItems

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction *share = [UIPreviewAction actionWithTitle:@"Share" style:(UIPreviewActionStyleDefault) handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    UIPreviewAction *cancel = [UIPreviewAction actionWithTitle:@"Cancel" style:(UIPreviewActionStyleDestructive) handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    return @[share,cancel];
}

#pragma mark - Photo selector

- (NSArray<UIImage *> *)localPhotos {
    if (self.gifs != nil) {
        return [self.gifs copy];
    }
    return nil;
}

#pragma mark - lazy

- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc]init];
    }
    return _gifImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (WyhPhotoSelectorService *)photoService {
    if (!_photoService) {
        _photoService = [WyhPhotoSelectorService service];
    }
    return _photoService;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
