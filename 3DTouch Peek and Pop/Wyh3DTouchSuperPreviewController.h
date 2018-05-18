//
//  Wyh3DTouchSuperPreviewController.h
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Wyh3DTouchChildPreviewControllerDelegate <NSObject>



@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface Wyh3DTouchSuperPreviewController : UIViewController

@property (nonatomic, assign) BOOL isPreviewed;

- (void)startPreviewing;

- (void)stopPreviewing;

@end
