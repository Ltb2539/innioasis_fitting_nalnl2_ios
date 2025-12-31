
//
//  TestModule.m
//  DCTestUniPlugin
//
//  Created by XHY on 2020/4/22.
//  Copyright © 2020 DCloud. All rights reserved.
//

#import "TestModule.h"
#import <NAL_NL2/NAL-NL2.h>

@implementation TestModule


- (instancetype)init{
    self = [super init];
    if (self) {
        // xs16
        self.xs16 = @[
            @(93.7), @(187.5), @(375), @(562.5), @(750), @(937.5), @(1218.75),
            @(1593.75), @(1968.75), @(2437.5), @(3093.75), @(3750), @(4687.5),
            @(6093.75), @(7500), @(8812.5)
        ];
        
        // xs32
        self.xs32 = @[
            @(93.7), @(187.5), @(375), @(562.5), @(750), @(937.5), @(1218.75),
            @(1500), @(1781.25), @(2062.5), @(2343.75), @(2625), @(2906.25),
            @(3187.5), @(3468.75), @(3750), @(4031.25), @(4312.5), @(4593.75),
            @(4781.25), @(5062.5), @(5343.75), @(5625), @(5906.25), @(6187.5),
            @(6468.75), @(6750), @(7031.25), @(7312.5), @(7875), @(8625), @(9187.5)
        ];
        
        // xs48
        self.xs48 = @[
            @(93.7), @(187.5), @(375), @(562.5), @(750), @(937.5), @(1125),
            @(1312.5), @(1500), @(1687.5), @(1875), @(2062.5), @(2250), @(2437.5),
            @(2625), @(2812.5), @(3000), @(3187.5), @(3375), @(3562.5), @(3750),
            @(3937.5), @(4125), @(4312.5), @(4500), @(4687.5), @(4875), @(5062.5),
            @(5250), @(5437.5), @(5625), @(5812.5), @(6000), @(6187.5), @(6375),
            @(6562.5), @(6750), @(6937.5), @(7125), @(7312.5), @(7500), @(7687.5),
            @(7875), @(8062.5), @(8250), @(8531.25), @(8906.25), @(9187.5)
        ];
        
        // xs11
        self.xs11 = @[
            @(125), @(250), @(500), @(750), @(1000), @(1500), @(2000), @(3000),
            @(4000), @(6000), @(8000)
        ];
        
        // xs19
        self.xs19 = @[
            @(125), @(160), @(200), @(150), @(315), @(400), @(500), @(630), @(800),
            @(1000), @(1250), @(1600), @(2000), @(2500), @(3150), @(4000), @(5000),
            @(6300), @(8000)
        ];
    }
    return self;
}



UNI_EXPORT_METHOD_SYNC(@selector(lmsToNal:))
UNI_EXPORT_METHOD_SYNC(@selector(uniMap11To64:))
UNI_EXPORT_METHOD_SYNC(@selector(uniMap64To11:))


- (NSString *)lmsToNal:(NSString *)json {
    // 将json转为对象   调用NSJSONSerialization 类的 JSONObjectWithData 方法  传递三个参数
    // 将json转为NSData UTF-8对象
    // options 无配置0
    // error忽略nil
    NSDictionary *inputData = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    // 读取各个参数
    NSInteger age = [inputData[@"age"] integerValue];//年龄
    NSInteger gender = [inputData[@"gender"] integerValue];
    NSArray *acArr = inputData[@"ac"];
    BOOL isLeft = [inputData[@"isLeft"] boolValue];
    NSInteger level = [inputData[@"level"] integerValue];
    
    // 获取当前年份  生成生日一月一号
    NSInteger currentYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger birthYear = currentYear - age;
    NSInteger birth = birthYear * 10000 + 101; // xxxx0101
    
    
    NSInteger isChild = (age > 18) ? 0:1;   //0成人 1小孩
    // 区分左右耳 这是一个耳朵的参数
    //气导
    double *ac = [self processAcArray:acArr isLeft:isLeft];
    //骨导
    double bc[19] = {999.0};
    // 声调语言，中文是声调语言 0 - non-tonal; 1 - tonal
    NSInteger tonal = 1;
    // 是否有佩戴经验 0 - experienced; 1 - new
    NSInteger experience = 1;
    // 0 - very slow; 1 - very fast; 2 - dual
    NSInteger compSpeed = 1;
    // 助听器是单个还是双个 0 - unilateral; 1 - bilateral
    NSInteger numAids = 1;
    // 0 - Undisturbed field; 1 - Head Surface
    NSInteger mic = 1;
    // 0 - 0; 1 - 45
    NSInteger direction = 0;
    // 0 - off; 1 - wideband; 2 - multichannel
    NSInteger limiting = 0;
    // 声道数量
    NSInteger channels = 4;
    // WBCT
    NSInteger WBCT = 52;
    // 带宽 0 - broadband; 1 - narrowband
    NSInteger bandwidth = 0;
    // 原来代码是0 0 - REIG; 1 - REAG; 2 - 2ccCoupler; 3 - EarSimulator
    NSInteger selection = 1;
    // 助听器类型 0 - CIC; 1 - ITC; 2 - ITE; 3 - BTE
    NSInteger haType = 3;
    // 创建一个长度为19的数组，所有元素初始化为1
    int calcCh[19] = {1};
    
    // 调用库方法
    SetAdultChild((int)isChild, (int)birth); // 设置是否成年 生日
    
    
    SetExperience((int)experience);// 设置佩戴经验
    SetCompSpeed((int)compSpeed);// 设置比较速度
    SetTonalLanguage((int)tonal);// 设置声调
    SetGender(-(int)gender+2);//设置性别
    
    double CFArray[19];
    int freqInCh[19];
    
    CrossOverFrequencies_NL2(CFArray, 19, ac, bc, freqInCh);
    
    setBWC((int)channels, CFArray);
    
    double ct[19];
    CompressionThreshold_NL2(ct, (int)bandwidth, (int)selection, (int)WBCT, (int)haType, (int)direction, (int)mic, calcCh);
    
    
    double data[19] = {};
    RealEarInsertionGain_NL2(data, ac, bc, level, (int)limiting, (int)channels, (int)direction, (int)mic, ac, (int)numAids);
    
    RealEarAidedGain_NL2(data, ac, bc, level, (int)limiting, (int)channels, (int)direction, (int)mic, ac, (int)numAids);
    
    NSMutableArray<NSNumber *> *data2 = [NSMutableArray arrayWithCapacity:19];
    for (int i = 0;  i<19; i++) {
        // Round each value in data, convert it to an integer, and wrap it into an NSNumber
        // 对该值进行四舍五入
        NSNumber *roundedValue = @(round(data[i]));
        [data2 addObject:roundedValue];
    }
    
    NSArray<NSNumber *> *data11 = [self map19to11:data2];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data11
                                                       options:NSJSONWritingPrettyPrinted  // 使用 PrettyPrinted 使 JSON 可读
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}



- (NSString *)uniMap11To64:(NSString *)json {
    NSDictionary *inputData = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSArray *ys11 = inputData[@"ys11"];
    NSInteger channelCount = [inputData[@"channelCount"] integerValue];
    BOOL isMPO = [inputData[@"isMPO"] boolValue];
    
    NSArray *mappedData = [self map11To64:ys11 channelCount:channelCount isMPO:isMPO];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mappedData options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)uniMap64To11:(NSString *)json {
    NSDictionary *inputData = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSArray *ys64 = inputData[@"ys64"];
    NSInteger channelCount = [inputData[@"channelCount"] integerValue];
    BOOL isMPO = [inputData[@"isMPO"] boolValue];
    
    NSArray *mappedData = [self mapXTo11:ys64 channelCount:channelCount isMPO:isMPO];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mappedData options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSArray *)map19to11:(NSArray *)ys19 {
    return [self mapWithXs:self.xs19 ys:ys19 xs2:self.xs11];
}

- (NSArray *)map11To64:(NSArray *)ys11 channelCount:(NSInteger)channelCount isMPO:(BOOL)isMPO {
    NSArray *values = [NSArray array];
    switch (channelCount) {
        case 16:
            values =[self mapWithXs:self.xs11 ys:ys11 xs2:self.xs16];
            break;
        case 32:
            values =[self mapWithXs:self.xs11 ys:ys11 xs2:self.xs32];
            break;
        case 48:
            values =[self mapWithXs:self.xs11 ys:ys11 xs2:self.xs48];
            break;
        default:
            values =[self mapWithXs:self.xs11 ys:ys11 xs2:self.xs16];
            break;
    }
//    NSMutableArray<NSNumber *> *data2 = [NSMutableArray arrayWithCapacity:64];
//    for (int i = 0;  i<64; i++) {
//        NSNumber *roundedValue = 0;
//        if (i<channelCount) {
//            roundedValue = values[i];
//        }
//        if (roundedValue) {
//            [data2 addObject:roundedValue];
//        }
//    }
//
//    return [self limitList:data2 isMPO:isMPO ];
    NSMutableArray<NSNumber *> *data2 = [NSMutableArray arrayWithCapacity:64];
    for (int i = 0; i < 64; i++) {
        if (i < channelCount) {
            [data2 addObject:values[i]];
        } else {
            [data2 addObject:@(0)];
        }
    }

    return [self limitList:data2 isMPO:isMPO];

}

- (NSArray *)mapXTo11:(NSArray *)ys channelCount:(NSInteger)channelCount isMPO:(BOOL)isMPO {
    NSArray *values = [NSArray array];
    NSRange r = NSMakeRange(0, channelCount);
    NSArray *ysSub = [ys subarrayWithRange:r];
    
    switch (channelCount) {
        case 16:
            values =[self mapWithXs:self.xs16 ys:ysSub xs2:self.xs11];
            break;
        case 32:
            values =[self mapWithXs:self.xs32 ys:ysSub xs2:self.xs11];
            break;
        case 48:
            values =[self mapWithXs:self.xs48 ys:ysSub xs2:self.xs11];
            break;
        default:
            values =[self mapWithXs:self.xs16 ys:ysSub xs2:self.xs11];
            break;
    }
    return [self limitList:values isMPO:isMPO ];
}




- (NSArray<NSNumber *>*)limitList:(NSArray<NSNumber *> *)list isMPO:(BOOL)isMPO{
    NSMutableArray<NSNumber *> *result  = [NSMutableArray array];
    for(NSNumber *num in list){
        int value = [num intValue];
        if (isMPO) { // 范围[50, 180]
            if (value < MPO_MIN) {
                [result addObject:@(MPO_MIN)];
            } else if (value > MPO_MAX) {
                [result addObject:@(MPO_MAX)];
            } else {
                [result addObject:num];  // 直接加入原值
            }
        } else { // 范围[0, 60]
            if (value < 0) {
                [result addObject:@(0)];
            } else if (value > 60) {
                [result addObject:@(60)];
            } else {
                [result addObject:num];  // 直接加入原值
            }
        }
    }
    return [result copy];
}


- (double *)processAcArray:(NSArray *)acArr isLeft:(BOOL)isLeft {
    // 创建一个可变数组的副本
    NSMutableArray *mutableAcArr = [acArr mutableCopy];
    
    // 根据 isLeft 的值设置 acArr 的范围
    if (isLeft) {
        mutableAcArr = [[acArr subarrayWithRange:NSMakeRange(0, 11)] mutableCopy];
    } else {
        mutableAcArr = [[acArr subarrayWithRange:NSMakeRange(11, 11)] mutableCopy];
    }
    
    // 删除索引 0 和 3 的元素
    [mutableAcArr removeObjectAtIndex:3];
    [mutableAcArr removeObjectAtIndex:0];
    
    // 创建一个长度为 9 的 double 数组
    double *doubleArray = (double *)malloc(sizeof(double) * mutableAcArr.count);  // 动态分配内存
    
    // 将 mutableAcArr 的值转换并存储到 double 数组中
    for (int i = 0; i < mutableAcArr.count; i++) {
        doubleArray[i] = [mutableAcArr[i] doubleValue];
    }
    
    return doubleArray; // 返回 double 数组
}

// 计算两点之间的直线插值
- (float)linearWithX1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2 x:(int)x {
    float k = (float)(y2 - y1) / (x2 - x1);
    return k * x - k * x1 + y1;
}

// 使用参考折线计算给定的 xs2 对应的 ys2 值
- (NSArray<NSNumber *> *)mapWithXs:(NSArray<NSNumber *> *)xs ys:(NSArray<NSNumber *> *)ys xs2:(NSArray<NSNumber *> *)xs2 {
    NSMutableArray<NSNumber *> *ys2 = [NSMutableArray array];
    
    for (NSNumber *xValue in xs2) {
        int x = [xValue intValue];
        BOOL find = NO;
        
        for (int i = 0; i < xs.count; i++) {
            int currentX = [xs[i] intValue];
            
            if (currentX >= x) {
                int prevX = (i == 0) ? [xs[0] intValue] : [xs[i-1] intValue];
                int prevY = (i == 0) ? [ys[0] intValue] : [ys[i-1] intValue];
                int nextX = [xs[i] intValue];
                int nextY = [ys[i] intValue];
                
                // 调用 linear 函数来计算 y 值
                float y = [self linearWithX1:prevX y1:prevY x2:nextX y2:nextY x:x];
                [ys2 addObject:@((int)roundf(y))];
                find = YES;
                break;
            }
        }
        
        // 如果没有找到匹配的区间，使用最后的区间进行计算
        if (!find) {
            int lastIndex = (int)xs.count - 1;
            int prevX = [xs[lastIndex - 1] intValue];
            int prevY = [ys[lastIndex - 1] intValue];
            int lastX = [xs[lastIndex] intValue];
            int lastY = [ys[lastIndex] intValue];
            
            // 调用 linear 函数来计算 y 值
            float y = [self linearWithX1:prevX y1:prevY x2:lastX y2:lastY x:x];
            [ys2 addObject:@((int)roundf(y))];
        }
    }
    
    return ys2;
}

@end
