//
//  CC_Tool+Color.m
//  bench_ios
//
//  Created by gwh on 2020/3/23.
//

#import "CC_Tool+Color.h"

@implementation CC_Tool (Color)

//颜色转字符串
- (NSString *)changeUIColorToRGB:(UIColor *)color {
    
    const CGFloat *cs = CGColorGetComponents(color.CGColor);

    NSString *r = [NSString stringWithFormat:@"%@",[self toHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[self toHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[self toHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
}

//十进制转十六进制
- (NSString *)toHex:(int)tmpid {
    NSString *endtmp = @"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig = tmpid%16;
    int tmp = tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue = [[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat = [[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp = [[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}

- (BOOL)isSameColor:(UIColor *)color1 andColor:(UIColor *)color2 {
    CGFloat red1,red2,green1,green2,blue1,blue2,alpha1,alpha2;
    //取出color1的背景颜色的RGBA值
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    //取出color2的背景颜色的RGBA值
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];

    if ((red1 == red2)&&(green1 == green2)&&(blue1 == blue2)&&(alpha1 == alpha2)) {
        YES;
    }
    return NO;
}

// 制定图片 特定位置获取颜色
- (UIColor *)pixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image {
    UIColor *color = nil;
    CGImageRef inImage = image.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:
                          inImage];
    
    if (cgctx == NULL) {
        return nil;
    }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    CGContextDrawImage(cgctx, rect, inImage);
    
    unsigned char *data = CGBitmapContextGetData (cgctx);
    
    if (data != NULL) {
        int offset = 4 * ((w*round(point.y)) + round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) {
        free(data);
    }
    return color;
    
}

// 获得图片中churc除白色最可能的特征色
- (UIColor *)colorOfImage:(UIImage *)image {
    float imgW = image.size.width;
    float imgH = image.size.height;
    
    NSMutableArray *chooseArr = [[NSMutableArray alloc]init];
    for (int i=0; i<10; i++) {
        CGPoint p = CGPointMake(imgW/2, imgH/2);
        
        p = CGPointMake(imgW*i/10, imgH/2);
        
        UIColor *myColor = [self pixelColorAtLocation:p inImage:image];
        const CGFloat* components = CGColorGetComponents(myColor.CGColor);
        CGFloat Red, Green, Blue, Alpha;
        Alpha = components[0];
        Red = components[0+1];
        Green = components[0+2];
        Blue = components[0+3];
        //white?
        if (((1-Red)<.1)&&((1-Green)<.1)&&((1-Blue)<.1)) {
            
        } else {
            [chooseArr addObject:myColor];
        }
        
    }
    if (chooseArr.count > 0) {
        return chooseArr[0];
    } else {
        return [UIColor whiteColor];
    }
}

- (UIColor *)colorOfImage2:(UIImage *)image {
    return [self mostColor:image];
}

//根据图片获取图片的主色调
- (UIColor *)mostColor:(UIImage *)image {
    return [self mostColor:image ignoreDeviation:0];
}

//获取图片主色调 可设定忽略颜色偏差
- (UIColor *)mostColor:(UIImage *)image ignoreDeviation:(NSUInteger)deviation {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(image.size.width, image.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char *data = CGBitmapContextGetData (context);
    if (data == NULL) return nil;
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (alpha>0) {//去除透明
                if (abs(red-green)<deviation && abs(red-blue)<deviation && abs(green-blue)<deviation) {//要忽略的颜色
                }else{
                    NSArray *clr = @[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
                
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    while ( (curColor = [enumerator nextObject]) != nil ) {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount = tmpCount;
        MaxColor = curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:(0.7)];
}

// 判断两个颜色是否相近
- (float)compareColorA:(UIColor *)colorA andColorB:(UIColor *)colorB {
    const CGFloat *components = CGColorGetComponents(colorA.CGColor);
    CGFloat Red, Green, Blue, Alpha;
    Alpha = components[0];
    Red = components[0+1];
    Green = components[0+2];
    Blue = components[0+3];
    
    const CGFloat *components2 = CGColorGetComponents(colorB.CGColor);
    CGFloat Red2, Green2, Blue2, Alpha2;
    Alpha2 = components2[0];
    Red2 = components2[0+1];
    Green2 = components2[0+2];
    Blue2 = components2[0+3];
    //向量比较
    float difference = pow( pow((Red - Red2), 2) + pow((Green - Green2), 2) +
                           pow((Blue - Blue2), 2), 0.5 );
    
    return difference;
}

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease(colorSpace);
    return context;
}

@end
