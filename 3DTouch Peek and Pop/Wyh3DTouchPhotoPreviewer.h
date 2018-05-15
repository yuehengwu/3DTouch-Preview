//
//  WyhPhotoPreviewer.h
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Wyh3DTouchPhotoPreviewer;

@protocol Wyh3DTouchPhotoPreviewerDelegate <NSObject>

- (NSString *)wyh3DTouchPhotoPathWithSourceView:(UIView *)sourceView;

@end

@interface Wyh3DTouchPhotoPreviewer : NSObject

+ (instancetype)previewerWithDelegate:(UIViewController<Wyh3DTouchPhotoPreviewerDelegate> *)delegate;

- (void)registerForPreviewingWithSourceView:(UIView *)sourceView;



@end
