//
//  TreeNode.m
//  BinarySearchTrees
//
//  Created by zxiao23 on 4/29/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"

@implementation TreeNode

//constructor
-(instancetype)init{
    self = [super self];
    if(self){
        self.item = @"";
        self.left = NULL;
        self.right = NULL;
    }
    return self;
}

-(instancetype)initWithQuestion : (NSString *) q{
    self = [super self];
    if(self){
        self.item = q;
        self.IsQuestion = true;
        self.left = NULL;
        self.right = NULL;
    }
    return self;
}

-(instancetype)initWithItem : (NSString *) i {
    self = [super self];
    if(self){
        self.item = i;
        self.IsQuestion = false;
        self.left = NULL;
        self.right = NULL;
    }
    return self;
}

//-(instancetype)initWithItem : (NSString *) q withParent : (TreeNode *) p{
//    self = [super self];
//    if(self){
//        self.item = q;
//        self.IsQuestion = true;
//        self.parent = p;
//        self.left = NULL;
//        self.right = NULL;
//    }
//    return self;
//}
//
//-(instancetype)initWithItem : (NSString *) i withParent : (TreeNode *) p{
//    self = [super self];
//    if(self){
//        self.item = i;
//        self.IsQuestion = false;
//        self.parent = p;
//        self.left = NULL;
//        self.right = NULL;
//    }
//    return self;
//}

@end
