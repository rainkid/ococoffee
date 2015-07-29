//
//  NSString+Additional.m
//  weather
//
//  Created by imac on 13-11-8.
//  Copyright (c) 2013年 Gionee. All rights reserved.
//

#import "NSString+Additional.h"

@implementation NSString (Additional)

- (CGSize)measureText:(UIFont *)font andWithWidth:(CGFloat)width{
    
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:(NSString *)self];
    
    //创建字体及指定字体大小
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)font.fontName,
                                            
                                            font.pointSize,
                                            
                                            NULL);
    
    
    [attString addAttribute:(id)kCTFontAttributeName value:(id)ctFont range:NSMakeRange(0, [(NSString *)self length])];
    
    
    //创建文体对齐方式
    CTTextAlignment alignment = kCTTextAlignmentJustified;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize = sizeof(alignment);
    alignmentStyle.value = &alignment;
    
    
    CGFloat lineSpace = 5.0f;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value = &lineSpace;
    
    CTParagraphStyleSetting settings[] ={alignmentStyle, lineSpaceStyle};
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    //给字符串添加样式attribute
    [attString addAttribute:(id)kCTParagraphStyleAttributeName value:(id)paragraphStyle range:NSMakeRange(0, [(NSString *)self length])];
    
    //layout master
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    //计算文本绘制size
    CGSize tmpSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), NULL);
    
    //创建textBoxSize以设置view的frame
    CGSize textBoxSize = CGSizeMake((int)tmpSize.width + 1, (int)tmpSize.height + 1);
    DLog(@"textBoxSize = %@", NSStringFromCGSize(textBoxSize));
    CFRelease(attString);
    CFRelease(framesetter);
    CFRelease(ctFont);
    CFRelease(paragraphStyle);
    return CGSizeMake(textBoxSize.width, textBoxSize.height);
}


- (void)drawText:(CGContextRef)context andWithFont:(UIFont *)font andWithFontColor:(UIColor *)fontColor andWithFrame:(CGRect)frame {
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:(NSString *)self];
    
    //创建字体及指定字体大小
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)font.fontName,font.pointSize,NULL);
    [attString addAttribute:(id)kCTFontAttributeName value:(id)ctFont range:NSMakeRange(0, [(NSString *)self length])];
    
    
    [attString addAttribute:(id)kCTForegroundColorAttributeName value:(id)fontColor.CGColor range:NSMakeRange(0, [(NSString *)self length])];
    
    //创建文本对齐方式
    CTTextAlignment alignment = kCTJustifiedTextAlignment;//左对齐 kCTRightTextAlignment为右对齐
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
    //创建文本行间距
    CGFloat lineSpace=5.0f;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
    lineSpaceStyle.valueSize=sizeof(lineSpace);
    lineSpaceStyle.value=&lineSpace;
    
    //创建样式数组
    CTParagraphStyleSetting settings[]={
        alignmentStyle,lineSpaceStyle
    };
    
    //设置样式
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings)/ sizeof(settings[0]));
    
    //给字符串添加样式attribute
    [attString addAttribute:(id)kCTParagraphStyleAttributeName
                      value:(id)paragraphStyle
                      range:NSMakeRange(0, [attString length])];
    
    
    //layout master
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL, frame);
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), leftColumnPath, NULL);
    
    
    //draw
    CTFrameDraw(leftFrame, context);
    //cleanup
    CFRelease(leftFrame);
    CFRelease(paragraphStyle);
    CGPathRelease(leftColumnPath);
    CFRelease(ctFont);
    CFRelease(attString);
    CFRelease(framesetter);
    
}

@end
