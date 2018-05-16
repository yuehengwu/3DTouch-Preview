//
//  PhotoPreviewController.m
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "WyhPhotoSelector.h"

@interface WyhPhotoSelector ()<UIScrollViewDelegate,CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray<UIImage *>*localPhotos;
@property (nonatomic, strong) NSMutableArray<NSURL *>*netPhotoURLs;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<UIImageView *>*imageViews;
@property (nonatomic, strong) NSMutableArray<UIScrollView *>*scrollViews;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) CAKeyframeAnimation *currentZoomAnimation;
@property (nonatomic, assign) NSInteger currentZoomIndex;

@property (nonatomic, strong) UILabel *pageCountLabel;

@property (nonatomic, strong) UITapGestureRecognizer *dismissTap;
@end

@implementation WyhPhotoSelector

- (instancetype)initWithDelegate:(id<WyhPhotoSelectorDelegate>)delegate {
    
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self configUI];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startZoomAnimations];
}

#pragma mark - Methods

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doubleTapAction:(UITapGestureRecognizer *)tapGes{
    [self stopCurrentZoomAnimation];
    
    float newScale = 0;
    UIScrollView *tapView = (UIScrollView *)tapGes.view;
    if ([tapView zoomScale] <= 1.0) {
        newScale=tapView.zoomScale * 2.0;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[tapGes locationInView:tapGes.view]];
        [tapView zoomToRect:zoomRect animated:YES];
    }else{
        [tapView setZoomScale:1.0 animated:YES];
    }
}

- (void)startZoomAnimations {
    
    [self zoomInWithCurrentZoomIndex:0];
    
}

- (void)zoomInWithCurrentZoomIndex:(NSInteger)index {
    
    _currentZoomIndex = index;
    NSArray *point = [self anchorPoints][index];
    CGPoint archorPoint = CGPointMake([point[0] floatValue], [point[1] floatValue]);
    
    UIImageView *currentScroll = self.imageViews[_currentIndex];
    CGRect o_frame = currentScroll.frame;
    currentScroll.layer.anchorPoint = archorPoint;
    currentScroll.frame = o_frame;
    CALayer *contentLayer = currentScroll.layer;
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.delegate = self;
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    scaleAnimation.duration = 4.f;
    scaleAnimation.keyTimes = @[@0.0,@0.9,@1];
    scaleAnimation.cumulative = NO;
    scaleAnimation.repeatCount = 1;
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [contentLayer addAnimation:scaleAnimation forKey:@"zoomIn"];
    
    self.currentZoomAnimation = scaleAnimation;
}

- (void)stopCurrentZoomAnimation {
    if (self.currentZoomAnimation) {
        UIImageView *currentImageView = self.imageViews[_currentIndex];
        self.currentZoomAnimation = nil;
        [currentImageView.layer removeAllAnimations];
        currentImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [self refreshImageContainerViewCenter:self.scrollViews[_currentIndex] UIImageView:currentImageView];
    }
}

- (NSInteger)findCurrentIndex {
    
    CGFloat fltNum = self.scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
    int intNum = self.scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
    int currentIndex = 1;
    if (fltNum - intNum  >= 0.5) {
        currentIndex = intNum + 2;
    }else{
        currentIndex = intNum + 1;
    }
    return (currentIndex - 1);
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag && self.currentZoomAnimation) {
        _currentZoomIndex = ((_currentZoomIndex+1) < self.anchorPoints.count)?(_currentZoomIndex+1):0; // repeat
        [self zoomInWithCurrentZoomIndex:_currentZoomIndex];
    }
}

#pragma mark - UI function

- (void)configUI {
    
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
    
    self.pageCountLabel.frame = CGRectMake(10, UIScreen.mainScreen.bounds.size.height - 30, 150, 25);
    [self.view addSubview:self.pageCountLabel];
    
    // dimiss tap
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    self.dismissTap = dismissTap;
    [self.scrollView addGestureRecognizer:dismissTap];
    
}

- (void)configImageView {
    
    // local photo
    if (self.localPhotos.count > 0) {
        
        [self.localPhotos enumerateObjectsUsingBlock:^(UIImage * _Nonnull photo, NSUInteger idx, BOOL * _Nonnull stop) {
            // sub scroll view
            UIScrollView *subScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(idx*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            subScrollView.delegate = self;
            subScrollView.maximumZoomScale = 5.f;
            subScrollView.minimumZoomScale = 1.f;
            [self.scrollView addSubview:subScrollView];
            
            // imageView
            UIImageView *imageView = [[UIImageView alloc]initWithImage:photo];
            [imageView sizeToFit];
            [subScrollView addSubview:imageView];
            CGSize f_size = [self autoConfigImageScaleWithCurrentImageSize:imageView.bounds.size];
            imageView.bounds = CGRectMake(0, 0, f_size.width, f_size.height);
            imageView.center = CGPointMake(subScrollView.bounds.size.width/2, subScrollView.bounds.size.height/2);
            
            // Double tap
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
            doubleTap.numberOfTapsRequired = 2;
            [subScrollView addGestureRecognizer:doubleTap];
            [self.dismissTap requireGestureRecognizerToFail:doubleTap];
            
            [self.scrollViews addObject:subScrollView];
            [self.imageViews addObject:imageView];
        }];
    }
}

- (CGSize)autoConfigImageScaleWithCurrentImageSize:(CGSize)o_size {
    CGFloat scale = o_size.width / o_size.height;
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width/scale);
}

#pragma mark - Api

- (void)showWithIndex:(NSUInteger)index {
    
    _currentIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(netPhotoURLs)]) {
        self.netPhotoURLs = [[self.delegate netPhotoURLs] copy];
    }
    
    if ([self.delegate respondsToSelector:@selector(localPhotos)]) {
        self.localPhotos = [[self.delegate localPhotos] copy];
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*self.localPhotos.count, 0); // reconfig contentSize.
        [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width*index, 0)];
        
        self.pageCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex + 1,self.localPhotos.count];// config pageLabel
    }
    
    [self configImageView];
    
    
}

#pragma mark - ScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopCurrentZoomAnimation];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.scrollView]) {
        _currentIndex = [self findCurrentIndex];
        self.pageCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex + 1,self.localPhotos.count];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self startZoomAnimations];
}

// Zoom
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    for (UIView *view in scrollView.subviews) {
        return view;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    for (UIView *s_view in scrollView.subviews) {
        if ([s_view isKindOfClass:[UIImageView class]]) {
            [self refreshImageContainerViewCenter:scrollView UIImageView:(UIImageView *)s_view];
        }
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
}

#pragma mark -

- (void)refreshImageContainerViewCenter:(UIScrollView *)scrollView UIImageView:(UIImageView *)imgView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? ((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? ((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5) : 0.0;
    imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.view.frame.size.height / scale;
    zoomRect.size.width  = self.view.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

#pragma mark - Lazy

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = true;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}
- (NSMutableArray<UIImageView *> *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray new];
    }
    return _imageViews;
}

- (NSMutableArray<UIScrollView *> *)scrollViews {
    if (!_scrollViews) {
        _scrollViews = [NSMutableArray new];
    }
    return _scrollViews;
}

- (NSArray *)anchorPoints {
    return @[
              @[@0,@0],
              @[@1,@0],
              @[@1,@1],
              @[@0,@1],
  ];
}

- (UILabel *)pageCountLabel {
    if (!_pageCountLabel) {
        _pageCountLabel = [[UILabel alloc]init];
        _pageCountLabel.font = [UIFont systemFontOfSize:14.f];
        _pageCountLabel.textColor = [UIColor whiteColor];
    }
    return _pageCountLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
