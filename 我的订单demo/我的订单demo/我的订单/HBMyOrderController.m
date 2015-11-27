//
//  HBMyOrderController.m
//  ShopperApp
//
//  Created by 李超 on 15/11/17.
//  Copyright © 2015年 清大世纪好班项目组. All rights reserved.
//

#import "HBMyOrderController.h"
#import "UIView+Extension.h"
#define kHeightOfTopScrollView 44.0f
#define BTNCOUNT 5
#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height          //包含状态bar的高度(e.g. 480)
#define kScreenHeightContent         [[UIScreen mainScreen] bounds].size.height-44          //包含状态bar的高度(e.g. 480)
#define FONT(SIZE) [UIFont systemFontOfSize:SIZE];
#define kMainBlueColor   [UIColor colorWithRed:4/255.0 green:152/255.0 blue:240/255.0 alpha:1]
//三色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:g/255.0 alpha:a]
@interface HBMyOrderController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic ,weak) UIScrollView *topScrollView;
@property (nonatomic ,weak) UIScrollView *bodyScrollView;
@property (nonatomic ,weak) UIView *bottomLine;
@property (nonatomic ,strong)NSMutableArray *btnArr;
@property (nonatomic ,assign) NSInteger userSelectedChannelID;
@property (nonatomic ,assign) NSInteger preIndex;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,assign)CGFloat btnW;
@property (nonatomic ,assign)CGFloat userContentOffsetX;
@property (nonatomic ,assign) BOOL isLeftScroll;

@end

@implementation HBMyOrderController

//-(NSMutableArray *)btnArr{
//    if (!_btnArr) {
//        _btnArr = [NSMutableArray array];
//    }
//    return _btnArr;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";

   // [self setLeftBackButton];
//    UITableView *MyOrderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
//    MyOrderTableView.delegate = self;
//    MyOrderTableView.dataSource = self;
//    [self.view addSubview:MyOrderTableView];
//    MyOrderTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];

    [self addAllViews];
}

- (void)addAllViews{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kHeightOfTopScrollView)];
    self.topScrollView = topScrollView;
    topScrollView.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomLine = [[UIView alloc]init];
    self.bottomLine = bottomLine;
    bottomLine.backgroundColor = kMainBlueColor;
    
    for(int i = 0; i < BTNCOUNT ; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnY = 0;
        CGFloat btnW = topScrollView.width / BTNCOUNT;
        CGFloat btnH = topScrollView.height;
        CGFloat btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        CGFloat bottomLineX = 0;
        CGFloat bottomLineY = btn.height -1;
        CGFloat bottomLineW = btn.width;
        CGFloat bottomLineH = 1;
        if (0 == i) {
        bottomLine.frame =CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
        btn.selected = YES;
        }
        [btn setTitleColor:RGBA(83, 160, 227, 1.0) forState:UIControlStateNormal];
        [btn setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         btn.titleLabel.font = FONT(14);
        NSMutableArray *btnArr =[NSMutableArray arrayWithObject:btn];;
        self.btnArr =btnArr;
        btn.tag =  i + 10000;
        [btn setTitle: @[@"全部",@"待确定",@"待支付",@"已确定",@"退款"][i] forState:UIControlStateNormal];
        topScrollView.contentSize = CGSizeMake(i*btn.width , 0);
        // 记录按钮的
        _userSelectedChannelID = 10000;
        [topScrollView addSubview:bottomLine];
        [topScrollView addSubview:btn];
        [self.view addSubview:topScrollView];
    }
        [self setMainScroll];

}
- (void)setMainScroll{
   
    
    UIScrollView *bodyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,  64 + self.topScrollView.height, kScreenWidth, kScreenHeight - 64 - self.topScrollView.height)];
    self.bodyScrollView = bodyScrollView;
    bodyScrollView.backgroundColor = [UIColor redColor];
    bodyScrollView.contentSize = CGSizeMake(BTNCOUNT * kScreenWidth, 0);
    bodyScrollView.pagingEnabled = YES;
    bodyScrollView.delegate = self;
    bodyScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bodyScrollView];
    for(int i = 0; i < BTNCOUNT ; i++){
      UITableView *MyOrderTableView = [[UITableView alloc]initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
            MyOrderTableView.delegate = self;
            MyOrderTableView.dataSource = self;
        [bodyScrollView addSubview:MyOrderTableView];
    }
}
- (void)topBtnClick:(UIButton *)btn{
    //如果更换按钮
    if (btn.tag != _userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID  >> 一定是把tag值赋值过去 反过来写就不行了
        _userSelectedChannelID =  btn.tag;
    }
       //按钮选中状态
    if (!btn.selected) {
        btn.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            [self.bottomLine setFrame:CGRectMake(btn.x, btn.height-1, btn.width, self.bottomLine.size.height)];
        }completion:^(BOOL finished) {
            [_bodyScrollView setContentOffset:CGPointMake((btn.tag - 10000)*self.view.width, 0) animated:YES];
        }];
        // 重复点击不做处理
     }else{
    }
    
    
    
}

#pragma mark - scroll方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float xxOffset =  scrollView.contentOffset.x *(self.btnW /scrollView.width) -self.btnW;
    [self.topScrollView scrollRectToVisible:CGRectMake(xxOffset, 0, self.topScrollView.width, self.topScrollView.height) animated:YES];
    _currentIndex = scrollView.contentOffset.x /self.view.width;
    
    if (_preIndex !=_currentIndex) {
        
    }
    _preIndex = _currentIndex;
 
    if (scrollView == self.bodyScrollView) {
        //判断用户是否左滚动还是右滚动
        if (_userContentOffsetX < scrollView.contentOffset.x) {
            _isLeftScroll = YES;
        }
        else {
            _isLeftScroll = NO;
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.bodyScrollView) {
        //调整顶部滑条按钮状态
        int tag = (int)scrollView.contentOffset.x/self.view.width + 10000;
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:tag];
        [self topBtnClick:button];
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.bodyScrollView) {
        _userContentOffsetX = scrollView.contentOffset.x;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *reuseID =@"reuseID";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.textLabel.font = FONT(14);
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            cell.textLabel.text = @"我的余额";
            UILabel *label = [[UILabel alloc]init];
            label.width = 200;
            label.x = CGRectGetMaxX(cell.frame)- label.width*0.8;
            label.height = cell.height;
            label.text = @"哈哈哈哈";
            
            label.textAlignment = NSTextAlignmentRight;
            label.font = FONT(14);
            [cell.contentView addSubview:label];
            return cell;
   
        }
     
    }

    return cell;


}





@end
