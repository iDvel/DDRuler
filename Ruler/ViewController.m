//
//  ViewController.m
//  Ruler
//
//  Created by Dvel on 2018/9/17.
//  Copyright © 2018 Dvel. All rights reserved.
//

#import "ViewController.h"
#import "DDRulerView.h"

@interface ViewController ()
@property (nonatomic, strong) DDRulerView *rulerView;
@property (nonatomic, strong) DDRulerView *rulerView2;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    
    
    self.rulerView = [[DDRulerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
    
    self.rulerView.minScale = 1;
    self.rulerView.padding = 30;
    
    self.rulerView.style = 1;
    
    self.rulerView.minValue = 0;
    self.rulerView.maxValue = 100;
    self.rulerView.defaultValue = 50;

    [self.view addSubview:self.rulerView];
    
    
    
    
    
    self.rulerView2 = [[DDRulerView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 100)];
    
    self.rulerView2.minScale = 100;
    self.rulerView2.padding = 5;
    
    self.rulerView2.style = 2;
    
    self.rulerView2.minValue = 0;
    self.rulerView2.maxValue = 50000;
    self.rulerView2.defaultValue = 5000;
    
    [self.view addSubview:self.rulerView2];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"当前数字：%zd", self.rulerView.currentValue);
    self.rulerView.gun = 50;
    self.rulerView2.gun = 5402;
}



@end
