//
//  FCPPMergeface.m
//  FaceSDKDemo
//
//  Created by Yuan Le on 2018/1/9.
//  Copyright © 2018年 Yang Yunxing. All rights reserved.
//

#import "FCPPMergeface.h"
#import "FCPPFaceDetect.h"


@implementation FCPPMergeface
{
    FCPPMergeface*  _fuseImageObj;
}

-(instancetype)initWithImage:(UIImage*)image withImageRectangle:(NSString*)ImageRectangle{
    if (self = [super initWithImage:image]) {
        self.image = [image fixImageWithMaxSize:CGSizeMake(4096, 4096)];
        self.imageRectangle = ImageRectangle;
    }
    return self;
}

-(void)mergeWithFuseImageObj:(FCPPMergeface*)fuseImageObj withMergeRate:(int)mergeRate wtihCompletion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@%@",IMAGE_MERGEFACE,MERGEFACE];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _fuseImageObj = fuseImageObj;
    if (self.image) {
        NSString *baseStr = self.image.base64String;
        [param setObject:baseStr forKey:@"template_base64"];
    }else if (self.imageUrl) {
        [param setObject:self.imageUrl forKey:@"template_url"];
    }
    
    if (fuseImageObj.image) {
        NSString *baseStr = fuseImageObj.image.base64String;
        [param setObject:baseStr forKey:@"merge_base64"];
    }else if (fuseImageObj.imageUrl) {
        [param setObject:self.imageUrl forKey:@"merge_url"];
    }

    if (fuseImageObj.imageRectangle) {
        [param setObject:fuseImageObj.imageRectangle forKey:@"merge_rectangle"];
    }
    if (mergeRate>=0&&mergeRate<=100) {
        [param setObject:@(mergeRate) forKey:@"merge_rate"];//默认为50
    }
    //模板图人脸框位置是必传参数，如果有直接走融合接口，如果没有此参数走else先进行人人脸检测
    if (self.imageRectangle) {
        [param setObject:self.imageRectangle forKey:@"template_rectangle"];
        [FCPPApi POST:url param:param completion:completion];
    }else{
        [self beginDetechWtihUrl:url withParam:param withCompletion:completion];
    }
}
#pragma mark- private method
-(void)beginDetechWtihUrl:(NSString*)url withParam:(NSDictionary*)param withCompletion:(void(^)(id info,NSError *error))completion{
    if (!param) {
        param = [NSMutableDictionary new];
    }
    FCPPFaceDetect *templateDetect = [[FCPPFaceDetect alloc] initWithImage:self.image];
    [templateDetect detectFaceWithReturnLandmark:YES attributes:nil completion:^(id info, NSError *error) {
        if (info) {
            NSArray *templateArray = info[@"faces"];
            [param setValue:[self getRectangle:templateArray] forKey:@"template_rectangle"];
            if (templateArray.count) {
                //检测检融合图人脸
                FCPPFaceDetect *targetDetect = [[FCPPFaceDetect alloc] initWithImage:_fuseImageObj.image];
                [targetDetect detectFaceWithReturnLandmark:YES attributes:nil completion:^(id info, NSError *error) {
                    if (info) {
                        NSArray *targetArray = info[@"faces"];
                        [param setValue:[self getRectangle:targetArray] forKey:@"merge_rectangle"];
                        if (targetArray.count) {
                            [FCPPApi POST:url param:param completion:completion];
                        }else{
                            completion(@"融合图没有识别到人脸",nil);
                        }
                    }else{
                        completion(@"融合图没有识别到人脸",nil);
                    }
                }];
                
            }else{
                completion(@"模板图没有识别到人脸",nil);
            }
        }else{
            completion(nil,error);
        }
    }];
}

-(NSString*)getRectangle:(NSArray*)array{
    NSString* rectangle = nil;
    for (NSDictionary *dic in array) {
        NSDictionary *rect = dic[@"face_rectangle"];
        rectangle =  [NSString stringWithFormat:@"%@,%@,%@,%@",rect[@"top"],rect[@"left"],rect[@"width"],rect[@"height"]];
    }
    return rectangle;
}

@end
