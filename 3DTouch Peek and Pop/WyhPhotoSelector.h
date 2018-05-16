//
//  PhotoPreviewController.h
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//


#import "Wyh3DTouchSuperPreviewController.h"

@protocol WyhPhotoSelectorDelegate <NSObject>

@optional

- (NSArray<NSURL*>*)netPhotoURLs;

- (NSArray<UIImage *>*)localPhotos;

@end

@interface WyhPhotoSelector : Wyh3DTouchSuperPreviewController

@property (nonatomic, weak) id<WyhPhotoSelectorDelegate> delegate;

- (instancetype)initWithDelegate:(id<WyhPhotoSelectorDelegate>)delegate;

- (void)showWithIndex:(NSUInteger)index;

@end
