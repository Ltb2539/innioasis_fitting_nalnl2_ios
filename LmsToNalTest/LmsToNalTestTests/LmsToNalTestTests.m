//
//  LmsToNalTestTests.m
//  LmsToNalTestTests
//
//  测试 lmsToNal 函数
//

#import <XCTest/XCTest.h>
#import "TestModule.h"

@interface LmsToNalTestTests : XCTestCase

@property (nonatomic, strong) TestModule *testModule;

@end

@implementation LmsToNalTestTests

- (void)setUp {
    [super setUp];
    self.testModule = [[TestModule alloc] init];
    XCTAssertNotNil(self.testModule, @"TestModule 初始化失败");
}

- (void)tearDown {
    self.testModule = nil;
    [super tearDown];
}

- (void)testLmsToNalWithProvidedParameters {
    // 准备测试数据 - 使用用户提供的参数
    NSDictionary *inputParams = @{
        @"age": @20,
        @"gender": @1,
        @"ac": @[
            @45, @55, @55, @55, @55, @55, @55, @55, @55, @55,
            @55, @55, @55, @55, @55, @55, @55, @55, @55, @55,
            @55, @55
        ],
        @"isLeft": @NO,
        @"level": @80
    };
    
    // 将字典转换为 JSON 字符串
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inputParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    XCTAssertNil(error, @"JSON 序列化不应该产生错误: %@", error.localizedDescription);
    XCTAssertNotNil(jsonData, @"JSON 数据不应该为 nil");
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    XCTAssertNotNil(jsonString, @"JSON 字符串不应该为 nil");
    
    NSLog(@"\n");
    NSLog(@"╔════════════════════════════════════════════════════════════╗");
    NSLog(@"║           开始测试 lmsToNal 函数                          ║");
    NSLog(@"╚════════════════════════════════════════════════════════════╝");
    NSLog(@"");
    NSLog(@"📥 输入参数详情:");
    NSLog(@"   ├─ age: %@ (岁)", inputParams[@"age"]);
    NSLog(@"   ├─ gender: %@ (1=男性, 0=女性)", inputParams[@"gender"]);
    NSLog(@"   ├─ isLeft: %@ (NO=右耳, YES=左耳)", inputParams[@"isLeft"]);
    NSLog(@"   ├─ level: %@ (dB)", inputParams[@"level"]);
    NSLog(@"   └─ ac数组:");
    NSArray *acArray = inputParams[@"ac"];
    NSLog(@"      长度: %lu 个频率点", (unsigned long)[acArray count]);
    NSLog(@"      内容: %@", acArray);
    NSLog(@"");
    NSLog(@"📄 输入 JSON 字符串:");
    NSLog(@"%@", jsonString);
    NSLog(@"");
    NSLog(@"⏱️  开始执行函数...");
    
    // 记录开始时间
    NSDate *startTime = [NSDate date];
    
    // 执行测试 - 调用 lmsToNal 函数
    @try {
        NSString *result = [self.testModule lmsToNal:jsonString];
        
        // 记录结束时间
        NSDate *endTime = [NSDate date];
        NSTimeInterval executionTime = [endTime timeIntervalSinceDate:startTime];
        
        // 验证结果
        XCTAssertNotNil(result, @"❌ lmsToNal 函数应该返回非空结果");
        XCTAssertTrue([result isKindOfClass:[NSString class]], @"❌ 返回结果应该是字符串类型");
        
        NSLog(@"");
        NSLog(@"╔════════════════════════════════════════════════════════════╗");
        NSLog(@"║           函数执行完成                                     ║");
        NSLog(@"╚════════════════════════════════════════════════════════════╝");
        NSLog(@"");
        NSLog(@"⏱️  执行时间: %.4f 秒", executionTime);
        NSLog(@"");
        NSLog(@"📤 返回结果 (JSON 字符串):");
        NSLog(@"%@", result);
        NSLog(@"");
        
        // 解析返回的 JSON 字符串
        NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
        XCTAssertNotNil(resultData, @"❌ 返回结果应该能够转换为 NSData");
        
        NSError *parseError = nil;
        id resultObject = [NSJSONSerialization JSONObjectWithData:resultData
                                                           options:0
                                                             error:&parseError];
        
        if (parseError) {
            NSLog(@"❌ JSON 解析错误: %@", parseError.localizedDescription);
            NSLog(@"   原始返回字符串: %@", result);
        }
        
        XCTAssertNil(parseError, @"❌ 返回的 JSON 应该能够正确解析: %@", parseError.localizedDescription);
        XCTAssertNotNil(resultObject, @"❌ 解析后的对象不应该为 nil");
        XCTAssertTrue([resultObject isKindOfClass:[NSArray class]], @"❌ 返回结果应该是数组类型，实际类型: %@", NSStringFromClass([resultObject class]));
        
        NSArray *resultArray = (NSArray *)resultObject;
        
        NSLog(@"╔════════════════════════════════════════════════════════════╗");
        NSLog(@"║           解析后的结果数组                                  ║");
        NSLog(@"╚════════════════════════════════════════════════════════════╝");
        NSLog(@"");
        NSLog(@"📊 数组信息:");
        NSLog(@"   ├─ 数组长度: %lu 个元素", (unsigned long)[resultArray count]);
        NSLog(@"   └─ 期望长度: 11 个元素 (NAL-NL2 标准频率点)");
        NSLog(@"");
        
        // 验证数组长度（应该是11个元素）
        XCTAssertEqual([resultArray count], 11, @"❌ 返回数组应该包含11个元素，实际包含 %lu 个", (unsigned long)[resultArray count]);
        
        // 打印每个元素的值
        NSLog(@"📋 详细数据:");
        NSArray *frequencyLabels = @[@"125Hz", @"250Hz", @"500Hz", @"750Hz", @"1000Hz", 
                                    @"1500Hz", @"2000Hz", @"3000Hz", @"4000Hz", @"6000Hz", @"8000Hz"];
        
        int minValue = INT_MAX;
        int maxValue = INT_MIN;
        double sumValue = 0.0;
        
        for (NSUInteger i = 0; i < [resultArray count]; i++) {
            NSNumber *value = resultArray[i];
            XCTAssertTrue([value isKindOfClass:[NSNumber class]], @"❌ 数组元素[%lu]应该是 NSNumber 类型", (unsigned long)i);
            
            int intValue = [value intValue];
            minValue = MIN(minValue, intValue);
            maxValue = MAX(maxValue, intValue);
            sumValue += intValue;
            
            NSString *label = (i < [frequencyLabels count]) ? frequencyLabels[i] : @"未知频率";
            NSLog(@"   [%2lu] %8s: %3d dB", (unsigned long)i, [label UTF8String], intValue);
            
            // 验证值在合理范围内（根据 limitList 函数，非 MPO 模式下应该在 [0, 60] 范围内）
            XCTAssertGreaterThanOrEqual(intValue, 0, @"❌ 值[%lu]应该 >= 0，实际值: %d", (unsigned long)i, intValue);
            XCTAssertLessThanOrEqual(intValue, 60, @"❌ 值[%lu]应该 <= 60，实际值: %d", (unsigned long)i, intValue);
        }
        
        double avgValue = sumValue / [resultArray count];
        
        NSLog(@"");
        NSLog(@"📈 统计信息:");
        NSLog(@"   ├─ 最小值: %d dB", minValue);
        NSLog(@"   ├─ 最大值: %d dB", maxValue);
        NSLog(@"   ├─ 平均值: %.2f dB", avgValue);
        NSLog(@"   └─ 总和: %.0f dB", sumValue);
        NSLog(@"");
        
        NSLog(@"╔════════════════════════════════════════════════════════════╗");
        NSLog(@"║         ✅ 测试完成 - 所有断言通过                         ║");
        NSLog(@"╚════════════════════════════════════════════════════════════╝");
        NSLog(@"\n");
        
    } @catch (NSException *exception) {
        NSLog(@"");
        NSLog(@"❌❌❌ 发生异常 ❌❌❌");
        NSLog(@"异常名称: %@", exception.name);
        NSLog(@"异常原因: %@", exception.reason);
        NSLog(@"调用堆栈: %@", exception.callStackSymbols);
        NSLog(@"");
        XCTFail(@"测试过程中发生异常: %@ - %@", exception.name, exception.reason);
    }
}

@end

