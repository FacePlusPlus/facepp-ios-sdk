//
//  UIImage+FCExtension.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/14.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "UIImage+FCExtension.h"

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

@implementation UIImage (FCExtension)

- (NSString *)base64String{
    return [self.imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSData *)imageData{
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    NSLog(@"图片大小: %.2f MB",data.length /1000.0 /1000.0);
    return data;
}

- (UIImage *)fixImageWithMaxSize:(CGSize)maxSize{
    //计算尺寸缩放比例
    CGSize size = self.size;
    CGFloat scaleW = size.width / maxSize.width;
    CGFloat scaleH = size.height / maxSize.height;
    CGFloat sizeScale = scaleW > scaleH ? scaleW : scaleH;
    
    //计算大小缩放比例
    CGFloat imageBytes = size.width * size.height *4.0;//图片大小
    CGFloat maxBytes = 2 * 1000.0 *1000.0;             //最大2M
    CGFloat byteScale = sqrtf(imageBytes /maxBytes);
    
    //取最大缩放比
    CGFloat scale = MAX(sizeScale, byteScale);
    
    BOOL orientationUp = self.imageOrientation == UIImageOrientationUp;//方向OK
    BOOL validSize = scale <= 1.0;//尺寸合适
    if (orientationUp && validSize){
        return self;
    }
    
    CGSize newSize = CGSizeMake(size.width/scale, size.height/scale);
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:(CGRect){0,0,newSize}];
    UIImage *fixImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fixImage;
}

- (UIImage *)cropWithRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)blendWithGrayImage:(UIImage *)grayImage backgroudColor:(long)hexColor{
    
    UInt32 * inputPixels;
    
    CGImageRef inputCGImage = [self CGImage];
    NSUInteger inputWidth   = CGImageGetWidth(inputCGImage);
    NSUInteger inputHeight  = CGImageGetHeight(inputCGImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    
    NSUInteger inputBytesPerRow = bytesPerPixel * inputWidth;
    
    inputPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
    
    CGContextRef context = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                                 bitsPerComponent, inputBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);
    CGImageRef ghostCGImage = [grayImage CGImage];
    
    // 2.1 Calculate the size & position of the ghost
    CGFloat ghostImageAspectRatio = grayImage.size.width / grayImage.size.height;
    NSInteger targetGhostWidth = inputWidth;
    CGSize ghostSize = CGSizeMake(targetGhostWidth, targetGhostWidth / ghostImageAspectRatio);
    CGPoint ghostOrigin = CGPointMake(0, 0);
    
    // 2.2 Scale & Get pixels of the ghost
    NSUInteger ghostBytesPerRow = bytesPerPixel * ghostSize.width;
    
    UInt32 * ghostPixels = (UInt32 *)calloc(ghostSize.width * ghostSize.height, sizeof(UInt32));
    
    CGContextRef ghostContext = CGBitmapContextCreate(ghostPixels, ghostSize.width, ghostSize.height,
                                                      bitsPerComponent, ghostBytesPerRow, colorSpace,
                                                      kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(ghostContext, CGRectMake(0, 0, ghostSize.width, ghostSize.height),ghostCGImage);
    
    // 2.3 Blend each pixel
    
    //background color
    //0x开头的十六进制转换成的颜色
    CGFloat R_back = ((float)((hexColor & 0xFF0000) >> 16));
    CGFloat G_back = ((float)((hexColor & 0xFF00) >> 8));
    CGFloat B_back = ((float)(hexColor & 0xFF));
    
    NSUInteger offsetPixelCountForInput = ghostOrigin.y * inputWidth + ghostOrigin.x;
    for (NSUInteger j = 0; j < ghostSize.height; j++) {
        for (NSUInteger i = 0; i < ghostSize.width; i++) {
            UInt32 * inputPixel = inputPixels + j * inputWidth + i + offsetPixelCountForInput;
            UInt32 inputColor = *inputPixel;
            
            UInt32 * ghostPixel = ghostPixels + j * (int)ghostSize.width + i;
            UInt32 ghostColor = *ghostPixel;
            
            CGFloat confidence = (R(ghostColor)+G(ghostColor)+B(ghostColor)) / 3.0 / 255.0;
            
            //用置信度标识透明度
            CGFloat alpha = confidence;
            UInt32 newR = R(inputColor) *alpha + R_back *(1 - alpha);
            UInt32 newG = G(inputColor) *alpha + G_back *(1 - alpha);
            UInt32 newB = B(inputColor) *alpha + B_back *(1 - alpha);
            
            //Clamp, not really useful here :p
            newR = MAX(0,MIN(255, newR));
            newG = MAX(0,MIN(255, newG));
            newB = MAX(0,MIN(255, newB));
            
            *inputPixel = RGBAMake(newR, newG, newB, A(inputColor));
        }
    }

    // 4. Create a new UIImage
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newCGImage];
    
    // 5. Cleanup!
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGContextRelease(ghostContext);
    free(inputPixels);
    free(ghostPixels);
    
    return newImage;
}
@end
