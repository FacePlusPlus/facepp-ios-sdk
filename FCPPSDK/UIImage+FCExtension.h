//
//  UIImage+FCExtension.h
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/14.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (FCExtension)

/**
 调整图片,使其不超过最大尺寸

 @param maxSize 最大尺寸
 @return UIImage *
 */
- (UIImage *)fixImageWithMaxSize:(CGSize)maxSize;


/**
 将图片转为二进制数据

 @return NSData
 */
- (NSData *)imageData;


/**
 将图片转为base64编码的字符串

 @return NSString *
 */
- (NSString *)base64String;


/**
 图片裁剪

 @param rect 裁剪范围
 @return UIImage *
 */
- (UIImage *)cropWithRect:(CGRect)rect;

/**
 将已知图片与灰度图进行合并

 @param grayImage 灰度图
 @param hexColor 16进制的背景色
 @return 返回抠图结果
 */
- (UIImage *)blendWithGrayImage:(UIImage *)grayImage backgroudColor:(long)hexColor;

@end
