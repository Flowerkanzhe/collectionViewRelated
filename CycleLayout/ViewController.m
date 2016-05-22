//
//  ViewController.m
//  CycleLayout
//
//  Created by 孔伟 on 16/5/21.
//  Copyright © 2016年 孔伟. All rights reserved.
//

#import "ViewController.h"
#import "CycleLayout.h"
#import "StackLayout.h"
#import "KVCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,weak) UICollectionView * collectionView;
@property (nonatomic,strong) CycleLayout * cycleLayout;
@property (nonatomic,strong) StackLayout * stackLayout;
@property (nonatomic,strong) UICollectionViewTransitionLayout * transitionLayout;
@property (nonatomic,assign) NSInteger count;


- (IBAction)changeItem:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)delete:(id)sender;

@end

@implementation ViewController

static NSString * cellReuseIdentifier = @"cellReuseIdentifier";

- (CycleLayout *)cycleLayout {
    if (_cycleLayout == nil) {
        _cycleLayout = [[CycleLayout alloc] init];
    }
    return _cycleLayout;
}

- (StackLayout *)stackLayout {
    if (_stackLayout == nil) {
        _stackLayout = [[StackLayout alloc] init];
    }
    return _stackLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 15;
    
    // 创建CollectionView
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.cycleLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.allowsSelection = YES;
    collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 设置背景颜色
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"KVCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellReuseIdentifier];
    
    UIScreenEdgePanGestureRecognizer * edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePan:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
    
    
// 增加菜单自定义选项
UIMenuItem * customItem = [[UIMenuItem alloc] initWithTitle:@"Custom" action:@selector(customItem:)];
[[UIMenuController sharedMenuController] setMenuItems:@[customItem]];
}

#pragma mark - UICollectionViewDataSources & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KVCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.indexLabel.text = [NSString stringWithFormat:@"我是国民好男人%ld", indexPath.row];
    
    // 给cell添加手势
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [cell addGestureRecognizer:panGesture];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KVCollectionViewCell * cell = (KVCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    UIView * backGroundView = [[UIView alloc] init];
    backGroundView.frame = cell.bounds;
    backGroundView.backgroundColor = [UIColor orangeColor];
    cell.selectedBackgroundView = backGroundView;
    
}




#pragma mark - 代码插入cell
- (IBAction)add:(id)sender {
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:10 inSection:0];
    self.count += 1;
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - 代码移动cell
- (IBAction)delete:(id)sender {
    
    NSIndexPath * fromIndexPath = [NSIndexPath indexPathForItem:10 inSection:0];
    NSIndexPath * toIndexPath = [NSIndexPath indexPathForItem:5 inSection:0];
    [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    
}


#pragma mark - 手势驱动移动cell
/**
 *  数据源方法，告知特定item是否可以移动
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    UIView * view = pan.view;
    
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:(KVCollectionViewCell *)view];
    
    CGPoint curentPoint = [pan locationInView:self.collectionView];
    
    if (pan.state == UIGestureRecognizerStateBegan) { // 手势开始
        // 告知collectionView开始交互移动
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
    } else if (pan.state == UIGestureRecognizerStateChanged) { // 手势进行
        // 告知collectionView更新交互移动
        [self.collectionView updateInteractiveMovementTargetPosition:curentPoint];
    } else if (pan.state == UIGestureRecognizerStateCancelled) { // 手势取消
        // 告知collectionView交互移动结束
        [self.collectionView cancelInteractiveMovement];
    } else if (pan.state == UIGestureRecognizerStateEnded) { // 手势结束
        // 告知collectionView交互移动结束
        [self.collectionView endInteractiveMovement];
    }
}

/**
 *  手势移动结束调动此方法，以最终确定目的地的IndexPath
 */
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    // 通常直接返回proposedIndexPath即可
    return proposedIndexPath;
}

/**
 *  手势移动结束，系统调用此方法告知移动的对象开始的IndexPath、移动结束的IndexPath
 */
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 在此处改变数据源中对应indexPath
}



#pragma mark - 代码改变layout对象
- (IBAction)changeItem:(id)sender {
    static BOOL isStack = NO;
    isStack = !isStack;
    if (isStack) {
        [self.collectionView setCollectionViewLayout:self.stackLayout animated:YES];
    } else {
        [self.collectionView setCollectionViewLayout:self.cycleLayout animated:YES];
    }
}

#pragma mark - 手势改变layout对象
- (void)edgePan:(UIScreenEdgePanGestureRecognizer *)edgePan {
    
    // 计算拖拽的进度
    CGFloat progress = [edgePan translationInView:self.view].x / 200;
    progress = MIN(1, MAX(0, progress));
    
    if (edgePan.state == UIGestureRecognizerStateBegan) { // 是手势开始
        // 告知collection开始交互变化Layout，以及交互变化layout完成调用的block
        self.transitionLayout = [self.collectionView startInteractiveTransitionToCollectionViewLayout:self.stackLayout completion:^(BOOL completed, BOOL finished) {
            NSLog(@"完成");
        }];
    } else if (edgePan.state == UIGestureRecognizerStateChanged) { // 如果是手势进行中，将进度告知collection的开始时返回的对象
        
        self.transitionLayout.transitionProgress = progress;
        [self.transitionLayout invalidateLayout];
    }  else if (edgePan.state == UIGestureRecognizerStateEnded) { // 如果是手势结束
        if (progress < 0.5) { // 如果完成进度小于0.5，就取消本次layout对象的转变
        
        [self.collectionView cancelInteractiveTransition];
    } else {
        
        [self.collectionView finishInteractiveTransition];
    }
    }
}



#pragma mark - 显示cell的编辑菜单
/**
 *  当我们长按cell的时候会调用此方法，告知是否可以显示编辑菜单
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/**
 *  此方法需实现，告知我们需要显示的item（即是否显示copy、cut等item，在ios7之后是在cell中告知的）
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return NO;
}

/**
 *  此方法也需实现，但实现类容可无
 */
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
}


@end
