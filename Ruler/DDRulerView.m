//
//  DDRulerView.m
//  Ruler
//
//  Created by Dvel on 2018/9/17.
//  Copyright © 2018 Dvel. All rights reserved.
//

#import "DDRulerView.h"

#define kScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight    [[UIScreen mainScreen] bounds].size.height


@interface DDRulerView ()<UIScrollViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *markLine;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) CGFloat scrollWidth;
@end



@implementation DDRulerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollWidth = kScreenWidth;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
        [self addSubview:self.bottomLine];
        [self addSubview:self.markLine];
        [self addSubview:self.textField];
        _minValue = 0;     //设置默认初始值
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}


#pragma mark - UIScrollViewDelegate
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"~~~~");

    
    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"%f", x);
    CGFloat value = (offsetX / _padding) * _minScale + self.minValue;
    if (value < self.minValue) {
        value = self.minValue;
    } else if (value > self.maxValue) {
        value = self.maxValue;
    }
    self.textField.text = [NSString stringWithFormat:@"%.f", value];
}

/** 滚停了 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation");
    // 有个BUG，如果设定滚到5401，他只会滚到5400，重写一遍防止这个BUG
    if (self.tag == 520) {
        self.textField.text = [NSString stringWithFormat:@"%zd", self.gun];
    }
    self.tag = 0;
}

// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    [self scrollViewDidEndDragging:scrollView willDecelerate:NO];
}

/** scrollView 结束拖动（无惯性状态下停止滚动）*/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"结束拖动");
    if(!decelerate){ // 避免惯性滚动时重复调用此方法
        NSLog(@"结束拖动 -> 减速停止");
        NSInteger value;
        value = round(scrollView.contentOffset.x * _minScale / _padding + self.minValue);

        
        CGFloat offsetX = (value - _minValue) * _padding / _minScale;
        // 大刻度滚法：
        if (self.style == 2) {
            offsetX = round(offsetX / (_padding * 10)) * (_padding * 10);
        }
        
        NSLog(@"value   = %zd", value);
        NSLog(@"offsetX = %f", offsetX);

        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        self.textField.text = [NSString stringWithFormat:@"%zd", value];
      
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.doubleValue < self.minValue) {
        textField.text = [NSString stringWithFormat:@"%.f",self.minValue];
    }
    if (textField.text.doubleValue > self.maxValue) {
        textField.text = [NSString stringWithFormat:@"%.f",self.maxValue];
    }

    [self.scrollView setContentOffset:CGPointMake((textField.text.doubleValue-_minValue)/_minScale*_padding, 0) animated:YES];
    self.textField.text = textField.text;
}

// 根据输入的数字变化
- (void)textDidChanged:(NSNotification *)info
{
    UITextField *textField = info.object;
    NSString *text = textField.text;
    if (textField.isEditing) {
        self.scrollView.contentOffset = CGPointMake((text.doubleValue-_minValue)/_minScale*_padding, 0);
        self.textField.text = text;
    }
}

# pragma mark - Getter
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth-100)*0.5, 10, 100, 20)];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.textColor = [UIColor blueColor];
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-5, kScreenWidth, 1)];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLine;
}


- (UIView *)markLine
{
    if (!_markLine) {
        _markLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, self.bottomLine.frame.origin.y-50, 1, 50)];
        _markLine.backgroundColor = [UIColor orangeColor];
        
        CGFloat circleWidth = 10;
        CGFloat circleHeight = 10;
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(_markLine.frame.size.width*0.5 - circleWidth*0.5,
                                                                  _markLine.frame.size.height - circleHeight*0.5,
                                                                  circleWidth, circleHeight)];
        circle.backgroundColor = _markLine.backgroundColor;
        circle.layer.cornerRadius = 5;
        [_markLine addSubview:circle];
    }
    return _markLine;
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (NSInteger)currentValue
{
    return self.textField.text.integerValue;
}


# pragma mark - Setter
- (void)setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.textField.text = [NSString stringWithFormat:@"%.f", _minValue];
}

- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    [self createIndicator];
}

- (void)setDefaultValue:(CGFloat)defaultValue
{
    if (defaultValue > _maxValue) {
        _defaultValue = _maxValue;
    } else if (defaultValue < _minValue) {
        _defaultValue = _minValue;
    } else {
        _defaultValue = defaultValue;
    }
    self.scrollView.contentOffset = CGPointMake((_defaultValue-_minValue)/_minScale*_padding, 0);
    self.textField.text = [NSString stringWithFormat:@"%.f", _defaultValue];
}

/** 滚动指定位置 */
- (void)setGun:(NSInteger)gun
{
    _gun = gun;
    self.tag = 520;

    NSInteger value = self.gun;
    CGFloat offsetX = (value - _minValue) * _padding / _minScale;
    offsetX = (offsetX / (_padding * 10)) * (_padding * 10);
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


# pragma mark - Functions
- (void)createIndicator
{
    for (NSUInteger i = self.minValue, j = 0; i <= self.maxValue; i+=_minScale, j++) {
        _scrollWidth += _padding;
        [self drawSegmentWithValue:i idx:j];
    }
    self.scrollView.contentSize = CGSizeMake(_scrollWidth-_padding, self.frame.size.height);
}

- (void)drawSegmentWithValue:(NSUInteger)value idx:(NSUInteger)idx
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat x = kScreenWidth*0.5 + _padding*idx;
    [path moveToPoint:CGPointMake(x, CGRectGetMinY(self.bottomLine.frame))];
    
    if (value % (_minScale*10) == 0 || value == _minValue) { //每10个刻度，do something
        [path addLineToPoint:CGPointMake(x, CGRectGetMinY(self.bottomLine.frame)-10-10)];
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(x-50*0.5, CGRectGetMinY(self.bottomLine.frame)-20-10-5, 50, 10)];
        numLabel.font = [UIFont systemFontOfSize:12];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor redColor];
        numLabel.text = [NSString stringWithFormat:@"%ld", value];
        [self.scrollView addSubview:numLabel];
    } else if (value % (_minScale*2) != 0) {   //每2个刻度，do something
        [path addLineToPoint:CGPointMake(x, CGRectGetMinY(self.bottomLine.frame)-5)];
    } else{
        [path addLineToPoint:CGPointMake(x, CGRectGetMinY(self.bottomLine.frame)-10)];
    }
    
    CAShapeLayer *line = [[CAShapeLayer alloc] init];
    //    line.frame = CGRectMake(0, 0, 20, 20);
    //    line.position = self.view.center;
    line.lineWidth = 1;
    line.strokeColor = [UIColor orangeColor].CGColor;
    line.path = path.CGPath;
    
    [self.scrollView.layer addSublayer:line];
}



- (void)dealloc
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
