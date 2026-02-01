#!/usr/bin/env python3
"""
从用户提供的3张截图生成Google Play手机屏幕截图
"""

try:
    from PIL import Image
except ImportError:
    print("需要安装 Pillow: pip3 install Pillow")
    exit(1)

import os
import glob

# Google Play要求的手机截图尺寸（9:16比例）
TARGET_WIDTH = 1080
TARGET_HEIGHT = 1920

# 输出目录
output_dir = "assets/google_play"
os.makedirs(output_dir, exist_ok=True)

def find_source_images():
    """查找用户提供的截图文件"""
    # 在多个可能的位置查找
    search_paths = [
        "/Users/wilsony/.cursor/projects/Users-wilsony-AndroidStudioProjects-decibel-meter/assets/image-*.png",
        "assets/image-*.png",
        "*.png"
    ]
    
    image_files = []
    for pattern in search_paths:
        found = glob.glob(pattern)
        if found:
            image_files.extend(found)
    
    # 去重并排序
    image_files = sorted(list(set(image_files)))
    return image_files[:3]  # 只取前3张

def resize_and_save_screenshot(source_path, output_path, index):
    """调整截图尺寸并保存"""
    try:
        # 打开原始图片
        img = Image.open(source_path)
        original_width, original_height = img.size
        
        print(f"处理图片 {index + 1}: {os.path.basename(source_path)}")
        print(f"  原始尺寸: {original_width}x{original_height}")
        
        # 计算目标尺寸，保持宽高比
        # 如果原图是横向的，先旋转或裁剪
        if original_width > original_height:
            # 横向图片，可能需要裁剪或旋转
            # 这里我们保持原图比例，但以高度为准
            scale = TARGET_HEIGHT / original_height
            new_width = int(original_width * scale)
            new_height = TARGET_HEIGHT
            
            # 如果缩放后的宽度超过目标宽度，则以宽度为准
            if new_width > TARGET_WIDTH:
                scale = TARGET_WIDTH / original_width
                new_width = TARGET_WIDTH
                new_height = int(original_height * scale)
        else:
            # 纵向图片，直接缩放
            scale = min(TARGET_WIDTH / original_width, TARGET_HEIGHT / original_height)
            new_width = int(original_width * scale)
            new_height = int(original_height * scale)
        
        # 调整图片大小
        resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
        
        # 创建目标尺寸的画布（白色背景）
        canvas = Image.new('RGB', (TARGET_WIDTH, TARGET_HEIGHT), (255, 255, 255))
        
        # 将调整后的图片居中放置
        x_offset = (TARGET_WIDTH - new_width) // 2
        y_offset = (TARGET_HEIGHT - new_height) // 2
        
        # 如果原图有透明通道，需要处理
        if resized_img.mode == 'RGBA':
            canvas.paste(resized_img, (x_offset, y_offset), resized_img)
        else:
            canvas.paste(resized_img, (x_offset, y_offset))
        
        # 保存
        canvas.save(output_path, "PNG", optimize=True)
        print(f"  ✓ 已保存: {output_path} ({TARGET_WIDTH}x{TARGET_HEIGHT})")
        return True
        
    except Exception as e:
        print(f"  ✗ 处理失败: {e}")
        return False

def main():
    print("开始生成 Google Play 手机屏幕截图...")
    print("-" * 50)
    
    # 查找源图片
    source_images = find_source_images()
    
    if not source_images:
        print("错误: 未找到源图片文件")
        print("请确保图片文件存在于以下位置之一:")
        print("  - /Users/wilsony/.cursor/projects/Users-wilsony-AndroidStudioProjects-decibel-meter/assets/")
        print("  - assets/")
        return
    
    print(f"找到 {len(source_images)} 张源图片")
    print()
    
    # 处理每张图片
    success_count = 0
    for i, source_path in enumerate(source_images):
        output_path = f"{output_dir}/screenshot_phone_{i + 1}.png"
        if resize_and_save_screenshot(source_path, output_path, i):
            success_count += 1
        print()
    
    print("-" * 50)
    if success_count > 0:
        print(f"✓ 成功生成 {success_count} 张截图")
        print(f"输出目录: {output_dir}/")
    else:
        print("✗ 未能生成任何截图")

if __name__ == "__main__":
    main()
