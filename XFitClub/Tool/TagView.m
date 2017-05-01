//
//  TypeView.m
//  SingaporeBusiness
//
//  Created by Mike on 16/6/7.
//  Copyright © 2016年 Julian. All rights reserved.
//

#import "TagView.h"
#import "Header.h"

//static NSInteger line = 0;
//static CGFloat originX = 0;

//static NSInteger font = 12;


@interface TagView ()
{
    CGFloat height;
    CGFloat width;
    NSInteger font;
    CGFloat originX;
    NSInteger line;
}
@end

@implementation TagView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        height = 20;//初始化每个item的高度
        width = 40;//初始化每个item的宽度
        font = 12;//字体
        originX = 0;//记录x坐标偏移多少
        line = 0;//行数
    }
    return self;
}

-(void)viewWithButtons:(NSArray *)array{
    NSArray *items = self.subviews;
    for (UIView *item in items) {
        [item removeFromSuperview];
    }
    
    if (array.count>0) {
        for (int i =0; i<array.count; i++) {
            
            NSString *name = array[i];
            UIButton *button = [[UIButton alloc] init];
            [self setCornersView:button];
            
            //设置边框颜色
            if (self.borderColor) {
                button.layer.borderColor = [self.borderColor CGColor];
            }else{
                button.layer.borderColor = [RGBCOLOR(153, 153, 153, 1) CGColor];
            }
            //设置标签颜色
            if (self.titleColor) {
                [button setTitleColor:self.titleColor forState:UIControlStateNormal];
            }else{
                [button setTitleColor:RGBCOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
            }
            //设置标签字体
            if (self.textFont) {
                font = self.textFont;
            }
            
            if (self.itemWidth) {
                width = self.itemWidth;
            }
            if (self.itemHeight) {
                height = self.itemHeight;
            }
            
            button.titleLabel.font = [UIFont systemFontOfSize:font];
            
            [button setTitle:name forState:UIControlStateNormal];
            
            if (name&&name.length>0) {
                CGSize size = [name sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:(font+2)]}];
                //如果一行大于容器的宽度，就换行
                if((originX + size.width+10)>WIDTH(self)){
                    line += 1;
                    originX = 0;
                    CGRect frame = self.frame;
                    frame.size.height = (line+1)*(height+10);
                    self.frame = frame;
                }

                [button setFrame:CGRectMake(originX, (height+10)*line, size.width+10, height)];
                [button addTarget:self action:@selector(tagBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                originX += WIDTH(button)+20;
                [self addSubview:button];
            }
        }
    }
}

-(void)dealloc{
    line = 0;
    originX = 0;
    height = 20;
    width = 40;
    font = 12;
}

-(void)setTypes:(NSArray<NSString *> *)types{
    [self viewWithButtons:types];
}

-(void)tagBtnClicked:(UIButton *)button{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tagClicked:)]) {
        [self.delegate tagClicked:button.titleLabel.text];
    }
}

-(void)setCornersView:(UIView *)view{
    
    [view.layer setMasksToBounds:YES];
    view.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    view.layer.borderWidth=1;
    view.layer.cornerRadius=4;
}
@end
