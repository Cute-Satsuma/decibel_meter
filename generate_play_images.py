#!/usr/bin/env python3
"""
生成 Google Play 商店所需的图片资源
- 应用图标：512x512（已存在）
- 置顶大图：1024x500
- 手机屏幕截图：多种尺寸
"""

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("需要安装 Pillow: pip3 install Pillow")
    exit(1)

import os

# 创建输出目录
output_dir = "assets/google_play"
os.makedirs(output_dir, exist_ok=True)

# 字体路径 - 支持中文的字体
CHINESE_FONT_PATHS = [
    "/System/Library/Fonts/STHeiti Light.ttc",
    "/System/Library/Fonts/Supplemental/Songti.ttc",
    "/System/Library/Fonts/PingFang.ttc",
]

def get_chinese_font(size):
    """获取支持中文的字体"""
    for font_path in CHINESE_FONT_PATHS:
        if os.path.exists(font_path):
            try:
                return ImageFont.truetype(font_path, size)
            except:
                continue
    # 如果都失败，返回默认字体（可能不支持中文）
    return ImageFont.load_default()

def get_english_font(size):
    """获取英文字体"""
    try:
        return ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", size)
    except:
        return ImageFont.load_default()

def draw_text_centered(draw, text, x, y, font, fill):
    """居中绘制文本，返回文本宽度和高度"""
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    # 计算文本的起始位置（左上角）
    text_x = x - text_width // 2
    text_y = y - text_height // 2
    draw.text((text_x, text_y), text, fill=fill, font=font)
    return text_width, text_height

# 颜色定义
GREEN_PRIMARY = (46, 125, 50)  # #2E7D32
GREEN_LIGHT = (76, 175, 80)    # #4CAF50
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
GRAY_LIGHT = (245, 245, 245)
GRAY_DARK = (66, 66, 66)

def create_feature_graphic():
    """创建置顶大图 1024x500 - 现代化设计风格"""
    width, height = 1024, 500
    img = Image.new('RGB', (width, height), WHITE)
    draw = ImageDraw.Draw(img)
    
    # 现代化背景 - 浅绿色渐变
    bg_start = (250, 255, 250)  # 浅绿色
    bg_end = (245, 250, 245)     # 更浅的绿色
    for y in range(height):
        ratio = y / height
        r = int(bg_start[0] + (bg_end[0] - bg_start[0]) * ratio)
        g = int(bg_start[1] + (bg_end[1] - bg_start[1]) * ratio)
        b = int(bg_start[2] + (bg_end[2] - bg_start[2]) * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    # 左侧应用图标区域 - 使用实际应用图标（无背景圆圈）
    icon_area_width = 400
    icon_x = icon_area_width // 2
    icon_y = height // 2
    
    # 加载并放置实际应用图标
    try:
        # 尝试加载512x512的图标
        app_icon_path = "assets/icons/icon_512.png"
        if not os.path.exists(app_icon_path):
            app_icon_path = "assets/icons/app_icon_1024.png"
        
        if os.path.exists(app_icon_path):
            app_icon = Image.open(app_icon_path)
            
            # 图标大小 - 根据可用空间调整（更大，因为不需要适应圆形）
            icon_target_size = 300  # 直接使用较大的尺寸
            
            # 保持宽高比
            icon_ratio = app_icon.width / app_icon.height
            if icon_ratio > 1:
                icon_width = icon_target_size
                icon_height = int(icon_target_size / icon_ratio)
            else:
                icon_height = icon_target_size
                icon_width = int(icon_target_size * icon_ratio)
            
            # 缩放图标
            app_icon = app_icon.resize((icon_width, icon_height), Image.Resampling.LANCZOS)
            
            # 将图标粘贴到主图像上（居中，保持原始形状，不添加圆形遮罩）
            icon_x_pos = icon_x - icon_width // 2
            icon_y_pos = icon_y - icon_height // 2
            
            if app_icon.mode == 'RGBA':
                # 如果有透明通道，使用透明通道
                img.paste(app_icon, (icon_x_pos, icon_y_pos), app_icon)
            else:
                # 如果没有透明通道，直接粘贴
                img.paste(app_icon, (icon_x_pos, icon_y_pos))
        else:
            print("警告: 找不到应用图标文件")
    except Exception as e:
        print(f"警告: 无法加载应用图标 ({e})")
    
    # 右侧文本区域 - 确保不超出边界
    text_area_left = icon_area_width + 60
    text_area_right = width - 60  # 右边距60像素，确保安全
    text_area_width = text_area_right - text_area_left
    text_center_x = text_area_left + text_area_width // 2
    
    # 字体设置 - 根据可用空间调整大小
    title_font_size = 44
    subtitle_font_size = 26
    db_font_size = 24
    
    app_name = "CS Decibel Meter"
    tagline = "Simple · No Cost · No Ads"
    db_text = "65.3 dB"
    
    # 创建临时draw来测量文本
    temp_img = Image.new('RGB', (100, 100), WHITE)
    temp_draw = ImageDraw.Draw(temp_img)
    
    # 检查并调整字体大小，确保文本不超出边界
    max_text_width = text_area_width - 40  # 留出边距
    
    # 应用名称
    title_font = get_english_font(title_font_size)
    app_name_bbox = temp_draw.textbbox((0, 0), app_name, font=title_font)
    app_name_width = app_name_bbox[2] - app_name_bbox[0]
    if app_name_width > max_text_width:
        title_font_size = int(title_font_size * max_text_width / app_name_width * 0.95)
        title_font = get_english_font(title_font_size)
    
    # 标语
    subtitle_font = get_english_font(subtitle_font_size)
    tagline_bbox = temp_draw.textbbox((0, 0), tagline, font=subtitle_font)
    tagline_width = tagline_bbox[2] - tagline_bbox[0]
    if tagline_width > max_text_width:
        subtitle_font_size = int(subtitle_font_size * max_text_width / tagline_width * 0.95)
        subtitle_font = get_english_font(subtitle_font_size)
    
    # 分贝值
    db_font = get_english_font(db_font_size)
    db_bbox = temp_draw.textbbox((0, 0), db_text, font=db_font)
    db_width = db_bbox[2] - db_bbox[0]
    if db_width > max_text_width:
        db_font_size = int(db_font_size * max_text_width / db_width * 0.95)
        db_font = get_english_font(db_font_size)
    
    # 应用名称（居中，确保在边界内）
    title_y = height // 2 - 50
    draw_text_centered(draw, app_name, text_center_x, title_y, title_font, GREEN_PRIMARY)
    
    # 标语（居中）
    tagline_y = height // 2 + 15
    draw_text_centered(draw, tagline, text_center_x, tagline_y, subtitle_font, GRAY_DARK)
    
    # 分贝值显示（居中，装饰性，稍微小一点）
    db_y = height // 2 + 65
    draw_text_centered(draw, db_text, text_center_x, db_y, db_font, GREEN_LIGHT)
    
    # 添加装饰性元素 - 右侧小图标或装饰
    # 可以在右侧添加一些装饰性的小元素
    
    img.save(f"{output_dir}/feature_graphic_1024x500.png", "PNG")
    print(f"✓ 已创建置顶大图: {output_dir}/feature_graphic_1024x500.png")

def create_phone_screenshot_1():
    """创建手机屏幕截图 1 - 主界面"""
    # 手机屏幕比例，使用常见的 1080x1920 (9:16)
    width, height = 1080, 1920
    img = Image.new('RGB', (width, height), WHITE)
    draw = ImageDraw.Draw(img)
    
    # 顶部状态栏区域（简化）
    draw.rectangle([0, 0, width, 100], fill=WHITE)
    
    # 标题和文本字体
    title_font = get_english_font(36)
    large_font = get_english_font(120)
    body_font = get_english_font(28)
    
    # 标题（居中）
    title_y = 150
    draw_text_centered(draw, "Decibel Meter", width // 2, title_y, title_font, GRAY_DARK)
    
    # 当前标签
    current_label_y = height // 2 - 300
    label_font = get_english_font(20)
    draw_text_centered(draw, "Current", width // 2, current_label_y, label_font, GRAY_DARK)
    
    # 当前分贝值显示（居中）
    db_value = "65.3"
    db_label = "dB"
    db_y = height // 2 - 200
    
    db_width, db_height = draw_text_centered(draw, db_value, width // 2, db_y, large_font, GREEN_PRIMARY)
    
    # dB 标签（在数字右侧，垂直居中）
    db_label_bbox = draw.textbbox((0, 0), db_label, font=body_font)
    db_label_height = db_label_bbox[3] - db_label_bbox[1]
    db_label_x = width // 2 + db_width // 2 + 20
    db_label_y = db_y - db_label_height // 2
    draw.text((db_label_x, db_label_y), db_label, fill=GRAY_DARK, font=body_font)
    
    # 分隔线（居中，左右留边距）
    divider_y = db_y + 150
    divider_margin = 100
    draw.line([(divider_margin, divider_y), (width - divider_margin, divider_y)], fill=GRAY_LIGHT, width=2)
    
    # 统计标题（居中）
    stats_title_y = divider_y + 50
    stats_title_font = get_english_font(24)
    draw_text_centered(draw, "Statistics", width // 2, stats_title_y, stats_title_font, GRAY_DARK)
    
    # 统计信息（第一行：Min/Avg/Peak）
    stats_y = stats_title_y + 80
    stats = [
        ("Min", "45.2"),
        ("Avg", "58.7"),
        ("Peak", "72.1")
    ]
    
    stat_width = width // 3
    stat_font = get_english_font(18)
    for i, (label, value) in enumerate(stats):
        x = i * stat_width + stat_width // 2
        stat_text = f"{label}\n{value}"
        # 计算多行文本高度
        lines = stat_text.split('\n')
        line_height = 30
        total_height = len(lines) * line_height
        for j, line in enumerate(lines):
            y = stats_y + j * line_height
            fill_color = GREEN_PRIMARY if j == 1 else GRAY_DARK
            draw_text_centered(draw, line, x, y, stat_font, fill_color)
    
    # 进度条（居中，左右留边距）
    progress_y = height - 450
    progress_margin = 100
    progress_width = width - 2 * progress_margin
    progress_height = 12
    progress_value = 0.5  # 50%
    progress_radius = 8
    
    # 进度条标签（左右对齐）
    label_font = get_english_font(16)
    draw.text((progress_margin, progress_y - 30), "30", fill=GRAY_DARK, font=label_font)
    label_120_bbox = draw.textbbox((0, 0), "120", font=label_font)
    draw.text((width - progress_margin - (label_120_bbox[2] - label_120_bbox[0]), progress_y - 30), 
              "120", fill=GRAY_DARK, font=label_font)
    
    # 进度条背景（圆角矩形）
    progress_bg = Image.new('RGB', (progress_width, progress_height), GRAY_LIGHT)
    mask = Image.new('L', (progress_width, progress_height), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([(0, 0), (progress_width, progress_height)], radius=progress_radius, fill=255)
    img.paste(progress_bg, (progress_margin, progress_y), mask)
    
    # 进度条填充（圆角矩形）
    fill_width = int(progress_width * progress_value)
    if fill_width > 0:
        progress_fill = Image.new('RGB', (fill_width, progress_height), GREEN_PRIMARY)
        fill_mask = Image.new('L', (fill_width, progress_height), 0)
        fill_mask_draw = ImageDraw.Draw(fill_mask)
        fill_mask_draw.rounded_rectangle([(0, 0), (fill_width, progress_height)], radius=progress_radius, fill=255)
        img.paste(progress_fill, (progress_margin, progress_y), fill_mask)
    
    # 提示文本（居中）
    hint_y = progress_y + 50
    hint_text = "Tap to start"
    hint_font = get_english_font(20)
    draw_text_centered(draw, hint_text, width // 2, hint_y, hint_font, GRAY_DARK)
    
    # 开始测量按钮（居中，带图标）
    button_y = height - 200
    button_width = 400
    button_height = 80
    button_x = width // 2 - button_width // 2
    
    # 按钮背景（圆角）
    button_bg = Image.new('RGB', (button_width, button_height), GREEN_PRIMARY)
    button_mask = Image.new('L', (button_width, button_height), 0)
    button_mask_draw = ImageDraw.Draw(button_mask)
    button_mask_draw.rounded_rectangle([(0, 0), (button_width, button_height)], radius=12, fill=255)
    img.paste(button_bg, (button_x, button_y), button_mask)
    
    # 按钮文本（居中）
    button_text = "Start Measuring"
    button_text_font = get_english_font(24)
    draw_text_centered(draw, button_text, width // 2, button_y + button_height // 2, button_text_font, WHITE)
    
    img.save(f"{output_dir}/screenshot_phone_1.png", "PNG")
    print(f"✓ 已创建屏幕截图 1: {output_dir}/screenshot_phone_1.png")

def create_phone_screenshot_2():
    """创建手机屏幕截图 2 - 统计视图"""
    width, height = 1080, 1920
    img = Image.new('RGB', (width, height), WHITE)
    draw = ImageDraw.Draw(img)
    
    # 字体设置
    title_font = get_english_font(36)
    large_font = get_english_font(100)
    body_font = get_english_font(24)
    label_font = get_english_font(20)
    stat_font = get_english_font(18)
    
    # 标题（居中）
    title_y = 150
    draw_text_centered(draw, "Decibel Meter", width // 2, title_y, title_font, GRAY_DARK)
    
    # 当前标签（居中）
    current_label_y = 350
    draw_text_centered(draw, "Current", width // 2, current_label_y, label_font, GRAY_DARK)
    
    # 当前值（居中）
    db_value = "72.5"
    db_label = "dB"
    db_y = 450
    
    db_width, db_height = draw_text_centered(draw, db_value, width // 2, db_y, large_font, GREEN_PRIMARY)
    
    # dB 标签（在数字右侧，垂直居中）
    db_label_bbox = draw.textbbox((0, 0), db_label, font=body_font)
    db_label_height = db_label_bbox[3] - db_label_bbox[1]
    db_label_x = width // 2 + db_width // 2 + 20
    db_label_y = db_y - db_label_height // 2
    draw.text((db_label_x, db_label_y), db_label, fill=GRAY_DARK, font=body_font)
    
    # 分隔线（居中，左右留边距）
    divider_y = db_y + 150
    divider_margin = 100
    draw.line([(divider_margin, divider_y), (width - divider_margin, divider_y)], fill=GRAY_LIGHT, width=2)
    
    # 统计标题（居中）
    stats_title_y = divider_y + 50
    stats_title_font = get_english_font(24)
    draw_text_centered(draw, "Statistics", width // 2, stats_title_y, stats_title_font, GRAY_DARK)
    
    # 详细统计（两行：第一行 Min/Avg/Peak，第二行 P50/P90/P95）
    stats_y = stats_title_y + 80
    stats_row1 = [
        ("Min", "42.1"),
        ("Avg", "61.3"),
        ("Peak", "78.9")
    ]
    stats_row2 = [
        ("P50", "59.2"),
        ("P90", "73.5"),
        ("P95", "76.8")
    ]
    
    cell_width = width // 3
    cell_height = 150
    
    # 第一行
    for i, (label, value) in enumerate(stats_row1):
        x = i * cell_width + cell_width // 2
        y = stats_y
        stat_text = f"{label}\n{value}"
        lines = stat_text.split('\n')
        for j, line in enumerate(lines):
            line_y = y + j * 30
            fill_color = GREEN_PRIMARY if j == 1 else GRAY_DARK
            draw_text_centered(draw, line, x, line_y, stat_font, fill_color)
    
    # 第二行
    for i, (label, value) in enumerate(stats_row2):
        x = i * cell_width + cell_width // 2
        y = stats_y + cell_height
        stat_text = f"{label}\n{value}"
        lines = stat_text.split('\n')
        for j, line in enumerate(lines):
            line_y = y + j * 30
            fill_color = GREEN_PRIMARY if j == 1 else GRAY_DARK
            draw_text_centered(draw, line, x, line_y, stat_font, fill_color)
    
    # 停止按钮（居中，红色）
    button_y = height - 200
    button_width = 400
    button_height = 80
    button_x = width // 2 - button_width // 2
    button_color = (220, 53, 69)  # 红色
    
    # 按钮背景（圆角）
    button_bg = Image.new('RGB', (button_width, button_height), button_color)
    button_mask = Image.new('L', (button_width, button_height), 0)
    button_mask_draw = ImageDraw.Draw(button_mask)
    button_mask_draw.rounded_rectangle([(0, 0), (button_width, button_height)], radius=12, fill=255)
    img.paste(button_bg, (button_x, button_y), button_mask)
    
    # 按钮文本（居中）
    button_text = "Stop"
    button_text_font = get_english_font(24)
    draw_text_centered(draw, button_text, width // 2, button_y + button_height // 2, button_text_font, WHITE)
    
    img.save(f"{output_dir}/screenshot_phone_2.png", "PNG")
    print(f"✓ 已创建屏幕截图 2: {output_dir}/screenshot_phone_2.png")

def create_phone_screenshot_3():
    """创建手机屏幕截图 3 - 深色模式"""
    width, height = 1080, 1920
    # 深色背景
    dark_bg = (18, 18, 18)
    img = Image.new('RGB', (width, height), dark_bg)
    draw = ImageDraw.Draw(img)
    
    # 字体设置
    title_font = get_english_font(36)
    large_font = get_english_font(120)
    body_font = get_english_font(28)
    label_font = get_english_font(20)
    stat_font = get_english_font(18)
    
    light_text = (255, 255, 255)
    gray_text = (170, 170, 170)
    dark_gray = (60, 60, 60)
    dark_surface = (40, 40, 40)
    
    # 标题（居中）
    title_y = 150
    draw_text_centered(draw, "Decibel Meter", width // 2, title_y, title_font, light_text)
    
    # 当前标签（居中）
    current_label_y = height // 2 - 300
    draw_text_centered(draw, "Current", width // 2, current_label_y, label_font, gray_text)
    
    # 当前分贝值（居中）
    db_value = "58.7"
    db_label = "dB"
    db_y = height // 2 - 200
    
    db_width, db_height = draw_text_centered(draw, db_value, width // 2, db_y, large_font, GREEN_LIGHT)
    
    # dB 标签（在数字右侧，垂直居中）
    db_label_bbox = draw.textbbox((0, 0), db_label, font=body_font)
    db_label_height = db_label_bbox[3] - db_label_bbox[1]
    db_label_x = width // 2 + db_width // 2 + 20
    db_label_y = db_y - db_label_height // 2
    draw.text((db_label_x, db_label_y), db_label, fill=gray_text, font=body_font)
    
    # 分隔线（深色模式下的浅色，居中）
    divider_y = db_y + 150
    divider_margin = 100
    draw.line([(divider_margin, divider_y), (width - divider_margin, divider_y)], fill=dark_gray, width=2)
    
    # 统计标题（居中）
    stats_title_y = divider_y + 50
    stats_title_font = get_english_font(24)
    draw_text_centered(draw, "Statistics", width // 2, stats_title_y, stats_title_font, gray_text)
    
    # 统计信息（第一行：Min/Avg/Peak）
    stats_y = stats_title_y + 80
    stats = [
        ("Min", "45.2"),
        ("Avg", "58.7"),
        ("Peak", "72.1")
    ]
    
    stat_width = width // 3
    for i, (label, value) in enumerate(stats):
        x = i * stat_width + stat_width // 2
        stat_text = f"{label}\n{value}"
        lines = stat_text.split('\n')
        for j, line in enumerate(lines):
            line_y = stats_y + j * 30
            fill_color = GREEN_LIGHT if j == 1 else gray_text
            draw_text_centered(draw, line, x, line_y, stat_font, fill_color)
    
    # 进度条（深色模式，居中，圆角）
    progress_y = height - 450
    progress_margin = 100
    progress_width = width - 2 * progress_margin
    progress_height = 12
    progress_value = 0.45
    progress_radius = 8
    
    # 进度条标签（左右对齐）
    label_small_font = get_english_font(16)
    draw.text((progress_margin, progress_y - 30), "30", fill=gray_text, font=label_small_font)
    label_120_bbox = draw.textbbox((0, 0), "120", font=label_small_font)
    draw.text((width - progress_margin - (label_120_bbox[2] - label_120_bbox[0]), progress_y - 30), 
              "120", fill=gray_text, font=label_small_font)
    
    # 进度条背景（圆角矩形）
    progress_bg = Image.new('RGB', (progress_width, progress_height), dark_surface)
    mask = Image.new('L', (progress_width, progress_height), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([(0, 0), (progress_width, progress_height)], radius=progress_radius, fill=255)
    img.paste(progress_bg, (progress_margin, progress_y), mask)
    
    # 进度条填充（圆角矩形）
    fill_width = int(progress_width * progress_value)
    if fill_width > 0:
        progress_fill = Image.new('RGB', (fill_width, progress_height), GREEN_LIGHT)
        fill_mask = Image.new('L', (fill_width, progress_height), 0)
        fill_mask_draw = ImageDraw.Draw(fill_mask)
        fill_mask_draw.rounded_rectangle([(0, 0), (fill_width, progress_height)], radius=progress_radius, fill=255)
        img.paste(progress_fill, (progress_margin, progress_y), fill_mask)
    
    # 提示文本（居中）
    hint_y = progress_y + 50
    hint_text = "Measuring"
    hint_font = get_english_font(20)
    draw_text_centered(draw, hint_text, width // 2, hint_y, hint_font, gray_text)
    
    # 开始测量按钮（居中，深色模式）
    button_y = height - 200
    button_width = 400
    button_height = 80
    button_x = width // 2 - button_width // 2
    
    # 按钮背景（圆角）
    button_bg = Image.new('RGB', (button_width, button_height), GREEN_LIGHT)
    button_mask = Image.new('L', (button_width, button_height), 0)
    button_mask_draw = ImageDraw.Draw(button_mask)
    button_mask_draw.rounded_rectangle([(0, 0), (button_width, button_height)], radius=12, fill=255)
    img.paste(button_bg, (button_x, button_y), button_mask)
    
    # 按钮文本（居中）
    button_text = "Start Measuring"
    button_text_font = get_english_font(24)
    draw_text_centered(draw, button_text, width // 2, button_y + button_height // 2, button_text_font, dark_bg)
    
    img.save(f"{output_dir}/screenshot_phone_3.png", "PNG")
    print(f"✓ 已创建屏幕截图 3 (深色模式): {output_dir}/screenshot_phone_3.png")

def copy_app_icon():
    """复制应用图标到输出目录"""
    import shutil
    source = "assets/icons/icon_512.png"
    dest = f"{output_dir}/app_icon_512x512.png"
    if os.path.exists(source):
        shutil.copy(source, dest)
        print(f"✓ 已复制应用图标: {dest}")
    else:
        print(f"⚠ 未找到应用图标: {source}")

if __name__ == "__main__":
    print("开始生成 Google Play 图片资源...")
    print("-" * 50)
    
    copy_app_icon()
    create_feature_graphic()
    create_phone_screenshot_1()
    create_phone_screenshot_2()
    create_phone_screenshot_3()
    
    print("-" * 50)
    print("✓ 所有图片已生成完成！")
    print(f"输出目录: {output_dir}/")
