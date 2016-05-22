//
//  StackLayout.m
//  CycleLayout
//
//  Created by 孔伟 on 16/5/21.
//  Copyright © 2016年 孔伟. All rights reserved.
//

#import "StackLayout.h"

@interface StackLayout()

@property (nonatomic,assign) NSInteger cellCount;
@property (nonatomic,strong) NSMutableArray * attributes;

@end

@implementation StackLayout

#define viewW self.collectionView.frame.size.width
#define viewH self.collectionView.frame.size.height

static NSInteger numOfStack = 3;

- (NSMutableArray *)attributes {
    if (_attributes == nil) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < self.cellCount; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributes addObject:attribute];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.center = CGPointMake(indexPath.row / numOfStack % 2 * viewW * 0.5 + viewW * 0.25, (indexPath.row / numOfStack) / 2 * viewW * 0.5 + viewW * 0.25);
    attribute.size = CGSizeMake(viewW * 0.5 / 1.5, viewW * 0.5 / 1.5);
    attribute.transform = CGAffineTransformMakeRotation(indexPath.row % numOfStack * M_PI_2 / numOfStack);
    
    return attribute;
}

- (CGSize)collectionViewContentSize {
    
    return self.collectionView.frame.size;
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attributes;
    
}


@end
