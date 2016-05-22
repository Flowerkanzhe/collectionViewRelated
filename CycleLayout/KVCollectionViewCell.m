//
//  KVCollectionViewCell.m
//  CycleLayout
//
//  Created by 孔伟 on 16/5/21.
//  Copyright © 2016年 孔伟. All rights reserved.
//

#import "KVCollectionViewCell.h"

@implementation KVCollectionViewCell

- (void)awakeFromNib {
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    // 显示系统自带的copy item
    if (action == @selector(copy:)) {
        return YES;
    }
    
    if (action == @selector(customItem:)) {
        return YES;
    }
    
    return NO;
}

- (void)customItem:(UIMenuController *)sender {
}

- (void)copy:(UIMenuController *)sender {
    NSLog(@"%s", __func__);
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
