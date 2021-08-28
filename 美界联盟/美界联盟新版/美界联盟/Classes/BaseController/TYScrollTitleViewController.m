//
//  TYScrollTitleViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYScrollTitleViewController.h"

//宽度
#define SWidth [UIScreen mainScreen].bounds.size.width
//高度
#define SHeight [UIScreen mainScreen].bounds.size.height
#define color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface TYScrollTitleViewController ()<UIScrollViewDelegate, TYGlobalSearchViewDelegate>{
    
    UIScrollView *_tableScroll;//中间的scroller
    UIView *_titleView;//类网易新闻的下面的红条框框
}

//所要添加的视图
@property(nonatomic,strong)NSMutableArray *viewControllerArray;
//每一个视图的名字
@property(nonatomic,strong)NSMutableArray *titleArray;

@property(nonatomic,assign)NSInteger selectNum;
@property (nonatomic, assign) BOOL lll;

@end

@implementation TYScrollTitleViewController

-(instancetype)initWithViewControllerArray:(NSMutableArray *)ViewControllerArray withTitleArray:(NSMutableArray *)titleArray SelectNum:(NSInteger)selectNum{
    
    self =[super init];
    if (self) {
       
        self.viewControllerArray = ViewControllerArray;
        self.titleArray = titleArray;
        self.selectNum = selectNum;
        
        self.automaticallyAdjustsScrollViewInsets=NO;
        [self setupScrollView];
        //添加内容容器
        [self addtableScroll];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self addNavigationBackBtn:@"back"];
    [self setNavigationRightBtnImage:@"search"];
}

#pragma mark -- 搜索
- (void)navigationRightBtnClick:(UIButton *)btn{
    TYGlobalSearchView *SearchView = [TYGlobalSearchView CreatTYGlobalSearchView];
    SearchView.delegate = self;
    SearchView.frame = CGRectMake(0, 20, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:SearchView];
}

#pragma mark -- <TYGlobalSearchViewDelegate>
-(void)ClickSearch:(NSString *)KeyWord andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime{
    //通知传值
    NSNotification *not = [[NSNotification alloc] initWithName:@"searchRefresh" object:nil userInfo:@{@"keyWord":KeyWord,@"startTime":startTime,@"endTime":endTime}];
    [[NSNotificationCenter defaultCenter] postNotification:not];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchRefresh" object:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    
}

- (void)navigationBackBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


//设置上面标题栏的scrollView
- (void)setupScrollView
{
    _scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SWidth, 45)];
    _scrollView.backgroundColor=[UIColor whiteColor];
    //设置滑动范围
    _scrollView.contentSize = CGSizeMake(SWidth, 45);
    [self.view addSubview:_scrollView];
    _scrollView.showsVerticalScrollIndicator = NO;
    //添加点击按钮
    for (int i = 0; i < [_titleArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( SWidth/_titleArray.count * i, 0, SWidth/[_titleArray count], 45);
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        //默认选中第一个分页
        if (i==0) {
            button.selected=YES;
        }
        //设定按钮文字颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设定文字颜色
        [button setTitleColor:RGB(45, 56, 251) forState:UIControlStateSelected];
        //设置点击事件
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = i+1;
        //文字大小
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [_scrollView addSubview:button];
        
        //UIView *doutView=[[UIView alloc]initWithFrame:CGRectMake((SWidth/_titleArray.count)/2*(2*i+1)+15, 13, 6, 6)];
        //doutView.layer.masksToBounds =YES;
        //doutView.layer.cornerRadius =3.0f;
        //doutView.tag = 201 + i;
        //doutView.backgroundColor = RGB(85, 190, 42);
        //[_scrollView addSubview:doutView];
    }
    _scrollView.bounces = NO;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 45-2, SWidth, 2)];
    view.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:view];
    //设置提示条目
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 45-2, SWidth/[_titleArray count], 2)];
    
    NSInteger count = [_titleArray count];
    CGFloat height = 2;
    //提示线条
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake((SWidth/count - SWidth/count)/count, 0, SWidth/count, height)];
    contentView.backgroundColor = RGB(45, 56, 251);
    [_titleView addSubview:contentView];
    [_scrollView addSubview:_titleView];
}
-(void)addtableScroll{
    //添加滑动视图
    _tableScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), SWidth, SHeight-CGRectGetMaxY(_scrollView.frame))];
    
    _tableScroll.contentSize = CGSizeMake(SWidth*[_titleArray count],SHeight-CGRectGetMaxY(_scrollView.frame) );
    [self.view addSubview:_scrollView];
    _tableScroll.delegate=self;
    _tableScroll.showsVerticalScrollIndicator = NO;
    _tableScroll.showsHorizontalScrollIndicator = NO;
    //设置整页滑动
    _tableScroll.pagingEnabled=YES;
    
    [self.view addSubview:_tableScroll];
    //添加选中视图
    if (_viewControllerArray.count) {
        if (_selectNum>0) {
            UIViewController *willShowVc = self.viewControllerArray[_selectNum];
            [self addChildViewController:willShowVc];
            willShowVc.view.frame = CGRectMake(_tableScroll.frame.size.width * _selectNum, 0, _tableScroll.frame.size.width, _tableScroll.frame.size.height);
            _tableScroll.contentOffset=CGPointMake(_selectNum*SWidth, 0);
            _titleView.frame = CGRectMake(_tableScroll.contentOffset.x/SWidth*SWidth/[_titleArray count], 45-2,SWidth/[_titleArray count], 2);
            [_tableScroll addSubview:willShowVc.view];
            
        }else{
            UIViewController *willShowVc = self.viewControllerArray[0];
            [self addChildViewController:willShowVc];
            willShowVc.view.frame = CGRectMake(_tableScroll.frame.size.width * 0, 0, _tableScroll.frame.size.width, _tableScroll.frame.size.height);
            _tableScroll.contentOffset=CGPointMake(0*SWidth, 0);
            _titleView.frame = CGRectMake(_tableScroll.contentOffset.x/SWidth*SWidth/[_titleArray count], 45-2,SWidth/[_titleArray count], 2);
            [_tableScroll addSubview:willShowVc.view];
        }
    }
}
- (void)titleClick:(UIButton *)button{
    //移动主视图 移动滑块
    [_tableScroll setContentOffset:CGPointMake((button.tag-1)*SWidth, 0) animated:YES];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //设定滑动主视图时候滑块随主视图滑动
    _titleView.frame = CGRectMake(scrollView.contentOffset.x/SWidth*SWidth/[_titleArray count], 45-2,SWidth/[_titleArray count], 2);
    //确定Scroller不为0
    if (scrollView.contentOffset.x/SWidth>=0) {
        //将其他已经select状态设置为NO
        int contentOffsetX = scrollView.contentOffset.x;
        int width=SWidth;
        //减少不必要操作 整数时候控制
        if (contentOffsetX % width==0) {
            //设置其他点击按钮不选中
            for (int i=1;i<[_titleArray count]+1; i++) {
                if (i!=scrollView.contentOffset.x/SWidth+1) {
                    UIButton *button=(UIButton *)[_scrollView viewWithTag:i];
                    button.selected=NO;
                }
            }
            //点击按钮选中
            UIButton *button=(UIButton *)[_scrollView viewWithTag:scrollView.contentOffset.x/SWidth+1];
            button.selected=YES;
            //为减少内存损耗使用懒加载
            //添加视图为空不作处理
            if (_viewControllerArray) {
                
                //获得contentScrollView 的长，宽 和偏移坐标X
                CGFloat width = scrollView.frame.size.width;
                CGFloat offsetX = scrollView.contentOffset.x;
                // 向contentScrollView上添加控制器的View 偏移到第几个视图
                NSInteger index = offsetX / width;
                
                // 取出要显示的控制器
                UIViewController *willShowVc = self.viewControllerArray[index];
                if (willShowVc.parentViewController) {
                    return;
                }
                
                [self addChildViewController:willShowVc];
                CGFloat height = scrollView.frame.size.height;
                willShowVc.view.frame = CGRectMake(width * index, 0, width, height);
                [scrollView addSubview:willShowVc.view];
                [willShowVc didMoveToParentViewController:self];
                
            }
        }
    }
    
}
@end
