//
//  TestModule.h
//  DCTestUniPlugin
//
//  Created by XHY on 2020/4/22.
//  Copyright © 2020 DCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCUniModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestModule : DCUniModule

#define MPO_MIN 50
#define MPO_MAX 150

@property (nonatomic, strong) NSArray<NSNumber *> *xs16;
@property (nonatomic, strong) NSArray<NSNumber *> *xs32;
@property (nonatomic, strong) NSArray<NSNumber *> *xs48;
@property (nonatomic, strong) NSArray<NSNumber *> *xs11;
@property (nonatomic, strong) NSArray<NSNumber *> *xs19;

- (NSString *)lmsToNal:(NSString *)json;

- (NSString *)uniMap11To64:(NSString *)json;

- (NSString *)uniMap64To11:(NSString *)json;

- (NSArray *)map19to11:(NSArray *)ys19;

- (NSArray *)map11To64:(NSArray *)ys11
    channelCount:(NSInteger)channelCount
    isMPO:(BOOL)isMPO;


- (NSArray *)mapXTo11:(NSArray *)ys
         channelCount:(NSInteger)channelCount
                isMPO:(BOOL)isMPO;

- (NSArray<NSNumber *>*)limitList:(NSArray<NSNumber *> *)list isMPO:(BOOL)isMPO;

- (double *)processAcArray:(NSArray *)acArr isLeft:(BOOL)isLeft;

- (float)linearWithX1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2 x:(int)x;

- (NSArray<NSNumber *> *)mapWithXs:(NSArray<NSNumber *> *)xs ys:(NSArray<NSNumber *> *)ys xs2:(NSArray<NSNumber *> *)xs2;

@end

NS_ASSUME_NONNULL_END
