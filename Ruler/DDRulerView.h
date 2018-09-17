//
//  DDRulerView.h
//  Ruler
//
//  Created by Dvel on 2018/9/17.
//  Copyright © 2018 Dvel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDRulerView : UIView

/** 最小值 */
@property (nonatomic, assign) CGFloat minValue;
/** 最大值 */
@property (nonatomic, assign) CGFloat maxValue;
/** 默认值 */
@property (nonatomic, assign) CGFloat defaultValue;

// 两个大刻度之间的间距为：padding * 10
/** 小刻度之间的间距，像素 */
@property (nonatomic, assign) NSInteger padding;
/** 刻度的最小单位，数字 */
@property (nonatomic, assign) NSInteger minScale;

/** 获取当前刻度 */
@property (nonatomic, assign, readonly) NSInteger currentValue;
/** 滚到指定刻度 */
@property (nonatomic, assign) NSInteger gun;

/** style枚举：1->小刻度，2->大刻度 */
@property (nonatomic, assign) NSInteger style;


@end
