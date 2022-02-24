//
//  TreeNode.h
//  BinarySearchTrees
//
//  Created by zxiao23 on 4/29/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#ifndef TreeNode_h
#define TreeNode_h

@interface TreeNode : NSObject

@property NSString *item;
@property TreeNode *left;
@property TreeNode *right;
@property bool IsQuestion;

//methods
//I made 2 types of init methods here, one is for nodes that contain items and the other one is for nodes that contain questions.
-(instancetype)initWithItem : (NSString *) q;
//-(instancetype)initWithItem : (NSString *) q withParent : (TreeNode *) p;
-(instancetype)initWithQuestion : (NSString *) q;
//-(instancetype)initWithQuestion : (NSString *) q withParent : (TreeNode *) p;


@end

#endif /* TreeNode_h */
