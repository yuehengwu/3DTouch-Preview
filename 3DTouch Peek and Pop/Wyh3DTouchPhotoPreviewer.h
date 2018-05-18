//
//  WyhPhotoPreviewer.h
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wyh3DTouchPreviewerProtocol.h"

@class Wyh3DTouchPhotoPreviewer;

@protocol Wyh3DTouchPhotoPreviewerDataSource <NSObject>

@optional
- (NSString *)wyh3DTouchPhotoPathWithSourceView:(UIView *)sourceView;

- (NSArray<UIImage *>*)wyh3DTouchGifArrWithSourceView:(UIView *)sourceView;

@end

@interface Wyh3DTouchPhotoPreviewer : NSObject<Wyh3DTouchPreviewerProtocol>

/**
 Previewer must need a delegate to obtain the data-source.
 */
@property (nonatomic, weak) id<Wyh3DTouchPhotoPreviewerDataSource> dataSource;

+ (instancetype)previewerWithPeekController:(UIViewController *)controller;

- (void)registerForPreviewingWithSourceView:(UIView *)sourceView;



@end
