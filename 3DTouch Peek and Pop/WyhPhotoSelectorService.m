//
//  WyhPhotoSelectorService.m
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/16.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "WyhPhotoSelectorService.h"

@interface WyhPhotoSelectorService()<WyhPhotoSelectorDataSource>

@end

@implementation WyhPhotoSelectorService

+ (instancetype)service {
    
    WyhPhotoSelectorService *service = [[WyhPhotoSelectorService alloc]init];
    
    return service;
}

- (void)showPhotoWithIndex:(NSInteger)index SourceController:(UIViewController *)controller{
    
    if (index >= self.localImages.count) {
        NSAssert(NO, @"confirm your index !!");
    }
    
    WyhPhotoSelector *photo = [[WyhPhotoSelector alloc]initWithDataSource:self];
    [photo showWithIndex:index];
    photo.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [controller presentViewController:photo animated:YES completion:nil];
    
}

#pragma mark - HSPhotoSelectorDataSource

- (NSArray<UIImage *> *)localPhotos {
    if (self.localImages.count > 0) {
        return self.localImages;
    }
    return nil;
}

- (NSArray<NSNumber *> *)zoomAnchorPointsForIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @[[NSNumber valueWithCGPoint:CGPointMake(0.5, 0.48)]];
            break;
        case 1:
            return @[[NSNumber valueWithCGPoint:CGPointMake(0.19, 0.49)]];
            break;
        case 2:
            return @[[NSNumber valueWithCGPoint:CGPointMake(0.75, 0.37)],[NSNumber valueWithCGPoint:CGPointMake(0.85, 0.41)]];
            break;
        case 3:
            return @[[NSNumber valueWithCGPoint:CGPointMake(0.81, 0.58)]];
            break;
        case 4:
            return @[[NSNumber valueWithCGPoint:CGPointMake(0.5, 0.43)]];
            break;
        case 5:
            return @[[NSNumber valueWithCGPoint:CGPointMake(0.14, 0.49)],[NSNumber valueWithCGPoint:CGPointMake(0.8, 0.68)]];
            break;
        default:
            NSAssert(NO, @"beyond over max-index !");
            return nil;
            break;
    }
}

@end
