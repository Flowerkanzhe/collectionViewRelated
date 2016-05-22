//
//  CycleLayout.m
//  CycleLayout
//
//  Created by 孔伟 on 16/5/21.
//  Copyright © 2016年 孔伟. All rights reserved.
//

#import "CycleLayout.h"

@interface CycleLayout()

@property (nonatomic,assign) NSInteger cellCount;
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) CGFloat angle;
@property (nonatomic,assign)  CGPoint center;
@property (nonatomic,strong) NSMutableArray * attributes;

@end

@implementation CycleLayout

#define viewW self.collectionView.frame.size.width
#define viewH self.collectionView.frame.size.height

- (NSMutableArray *)attributes {
    if (_attributes == nil) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    self.radius = (viewW - 100) * 0.5;
    self.center = CGPointMake(viewW * 0.5, viewH * 0.5);
    self.angle = 2 * M_PI / self.cellCount;
    
    for (NSInteger i = 0; i < self.cellCount; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributes addObject:attribute];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat X = self.center.x + cos(self.angle * indexPath.row) * self.radius;
    CGFloat Y = self.center.y + sin(self.angle * indexPath.row) * self.radius;
    attribute.center = CGPointMake(X, Y);
    attribute.size = CGSizeMake(50, 50);
    attribute.transform = CGAffineTransformMakeRotation(self.angle * indexPath.row);
    
    return attribute;
}

- (CGSize)collectionViewContentSize {
    
    return self.collectionView.frame.size;
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attributes;
    
}



@end
