//
//  ViewController.m
//  PictureBrowser
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"


#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidht [UIScreen mainScreen].bounds.size.width

CGFloat kImageCount=10;
CGFloat scrollY=20;
CGFloat pageCtrlWidth=200;
@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScrollView];
    [self initPageControl];//页码器
    [self addTimer];//创建定时器
}

//创建滑动视图
- (void)initScrollView{
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollY, kScreenWidht, kScreenHeight-scrollY)];
    self.scrollView.delegate=self;
    
    for (int i=0; i<kImageCount; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidht*i, scrollY, kScreenWidht, kScreenHeight-scrollY)];
        NSString *imageName=[NSString stringWithFormat:@"huoying%d.jpg",i+1];
        NSString *path=[[NSBundle mainBundle]pathForResource:imageName ofType:nil];
        imageView.image=[UIImage imageWithContentsOfFile:path];
        [self.scrollView addSubview:imageView];
     
    }
    //设置视图滚动范围
    self.scrollView.contentSize=CGSizeMake(kScreenWidht*kImageCount, kScreenHeight-scrollY);
    self.scrollView.pagingEnabled=YES;//分页显示
    [self.view addSubview:self.scrollView];
}
- (void)initPageControl{
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWidht-pageCtrlWidth)/2, kScreenHeight-scrollY, pageCtrlWidth, scrollY)];
    self.pageControl.numberOfPages=kImageCount;
    self.pageControl.pageIndicatorTintColor=[UIColor redColor];
    self.pageControl.currentPageIndicatorTintColor=[UIColor yellowColor];
    [self.view insertSubview:self.pageControl aboveSubview:self.scrollView];
}
#pragma mark -<UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //x轴的偏移量除以瓶宽就是页码数
    NSInteger page=scrollView.contentOffset.x/kScreenWidht+0.5;
    //把这个页码数赋值给当前页码
    self.pageControl.currentPage=page;
}

//创建定时器
- (void)addTimer{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //多线程机制
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)nextPage{
    NSInteger page=self.pageControl.currentPage;
    page++;
    if (page==kImageCount) {
        page=0;
    }
    CGPoint point=CGPointMake(kScreenWidht*page, 0);
    [self.scrollView setContentOffset:point animated:YES];
}
#pragma mark =====代理方法
//当视图将要拖动的时候  使定时器关闭
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
//关闭定时器
- (void)removeTimer{
    [self.timer invalidate];//使定时器无效
    self.timer=nil;
}
//当视图停止拖拽的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //GCD
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addTimer];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
