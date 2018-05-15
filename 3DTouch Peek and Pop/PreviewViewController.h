//
//  PreviewViewController.h
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewViewController : UIViewController

- (CGSize)setGifImages:(NSArray<UIImage *>*)gifImages;

- (void)stopPreviewing;

@end
