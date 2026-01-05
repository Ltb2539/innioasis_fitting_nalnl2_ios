# LmsToNalTest - 独立测试项目

这是一个专门用于测试 `lmsToNal` 函数的独立 Xcode 项目。

## 📁 项目结构

```
LmsToNalTest/
├── LmsToNalTest/              # 主项目代码
│   ├── TestModule.h          # TestModule 头文件
│   ├── TestModule.mm         # TestModule 实现（包含 lmsToNal 函数）
│   └── NAL_NL2_SDK/          # NAL_NL2 库文件
│       ├── NAL_NL2.framework
│       └── NALNL2Bundle.bundle
├── LmsToNalTestTests/        # 测试代码
│   └── LmsToNalTestTests.m   # 单元测试
└── LmsToNalTest.xcodeproj    # Xcode 项目文件
```

## 🚀 使用说明

### 1. 在 Xcode 中打开项目

1. 双击 `LmsToNalTest.xcodeproj` 打开项目
2. 等待 Xcode 索引完成

### 2. 配置项目（如果需要）

确保以下设置正确：
- **Framework Search Paths**: 包含 `$(PROJECT_DIR)/LmsToNalTest/NAL_NL2_SDK`
- **Header Search Paths**: 包含 `$(PROJECT_DIR)/LmsToNalTest`
- **Link Binary With Libraries**: 包含 `NAL_NL2.framework`

### 3. 运行测试

- 按 `⌘ + U` 运行所有测试
- 或点击测试方法旁边的 ▶️ 图标运行单个测试

## 📝 测试参数

默认测试参数：
```json
{
    "age": 20,
    "gender": 1,
    "ac": [45, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55],
    "isLeft": false,
    "level": 80
}
```

## ⚠️ 注意事项

1. 确保 `NAL_NL2.framework` 和 `NALNL2Bundle.bundle` 已正确复制到项目中
2. 如果遇到链接错误，检查 Framework Search Paths 设置
3. 测试代码会输出详细的调试信息到控制台

## 🔧 故障排除

### 问题：找不到 NAL_NL2.framework
**解决方案：**
- 检查 `NAL_NL2_SDK` 文件夹是否在正确位置
- 在 Build Settings 中检查 Framework Search Paths

### 问题：找不到 TestModule.h
**解决方案：**
- 检查 Header Search Paths 是否包含项目目录
- 确保 TestModule.h 已添加到 target

### 问题：运行时崩溃
**解决方案：**
- 检查 `NALNL2Bundle.bundle` 是否已添加到 Copy Bundle Resources
- 查看控制台的详细错误信息

