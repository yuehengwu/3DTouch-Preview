//
//  HS3DTouchPreviewerProtocol.h
//  Arm
//
//  Created by wyh on 2018/5/17.
//  Copyright © 2018年 iTalkBB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 All the 3DTouch previewer need to follow this protocol.
 */
@protocol Wyh3DTouchPreviewerProtocol <NSObject>

@property (nonatomic, weak) id dataSource;

/**
 The only init function.
 */
+ (instancetype)previewerWithPeekController:(UIViewController *)controller;

/**
 Regist 3DTouch preview function.
 */
- (void)registerForPreviewingWithSourceView:(UIView *)sourceView;

@end
