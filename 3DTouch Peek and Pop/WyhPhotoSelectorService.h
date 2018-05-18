//
//  WyhPhotoSelectorService.h
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/16.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WyhPhotoSelector.h"

@interface WyhPhotoSelectorService : NSObject

@property (nonatomic, strong) NSArray<UIImage *>*localImages;

+ (instancetype)service;

- (void)showPhotoWithIndex:(NSInteger)index SourceController:(UIViewController *)controller;

@end
