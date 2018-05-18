//
//  PhotoPreviewController.h
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//


#import "Wyh3DTouchSuperPreviewController.h"

@protocol WyhPhotoSelectorDataSource <NSObject>

@optional

- (NSArray<NSURL*>*)netPhotoURLs;

- (NSArray<UIImage *>*)localPhotos;

/* example:
 @[
 [NSNumber valueWithCGPoint:CGPointMake(0.5, 0.48)],
 [NSNumber valueWithCGPoint:CGPointMake(0.14, 0.3)]
 ]
 */
- (NSArray<NSNumber*>*)zoomAnchorPointsForIndex:(NSInteger)index;

@end

@interface WyhPhotoSelector : Wyh3DTouchSuperPreviewController

@property (nonatomic, weak) id<WyhPhotoSelectorDataSource> dataSource;

- (instancetype)initWithDataSource:(id<WyhPhotoSelectorDataSource>)dataSource;

- (void)showWithIndex:(NSUInteger)index;

@end
