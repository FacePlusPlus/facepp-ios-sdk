//
//  NSMutableAttributedString+FCExtension.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/19.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "NSMutableAttributedString+FCExtension.h"

@implementation NSMutableAttributedString (FCExtension)
- (void)appendBoldString:(NSString *)string{
    if (string) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
        [self appendAttributedString:attString];
    }
}

- (void)appendLightString:(NSString *)string{
    if (string) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        [self appendAttributedString:attString];
    }
}
@end
