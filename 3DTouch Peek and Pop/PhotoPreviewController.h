//
//  PhotoPreviewController.h
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoPreviewControllerDelegate <NSObject>

- (NSArray<NSURL*>*)netPhotosURL;

- (NSArray<UIImage *>*)localPhotos;

@end

@interface PhotoPreviewController : UIViewController

- (void)showWithIndex:(NSUInteger)index;

@end
