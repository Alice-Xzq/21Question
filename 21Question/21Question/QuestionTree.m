//
//  QuestionTree.m
//  21Question
//
//  Created by zxiao23 on 5/6/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//  Cite https://www.geeksforgeeks.org/construct-tree-from-given-inorder-and-preorder-traversal/
//

#import <Foundation/Foundation.h>
#import "QuestionTree.h"

@implementation QuestionTree

//constructors
-(instancetype)init{
    self = [super init];
    if(self){
        self.root = NULL;
    }
    return self;
}

-(instancetype)initWithBasicQuestion{
    self = [super init];
    if(self){
        self.root = [[TreeNode alloc] initWithQuestion:@"Is it a creature?"];
        self.currentQuestion = self.root;
        self.root.right = [[TreeNode alloc] initWithItem:@"human"];
        self.root.left = [[TreeNode alloc] initWithItem:@"computer"];
    }
    return self;
}

//methods

//read from the file and create the tree
-(void)readFromFile{
    NSURL *url = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    NSError *error;
    url = [url URLByAppendingPathComponent:@"memory.txt"];
    NSString* content = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (content == nil) {
    // an error occurred
    NSLog(@"Error reading file at %@\n%@", url, [error localizedFailureReason]);
    }
    NSMutableArray *data = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
    NSMutableArray *preorder = [NSMutableArray arrayWithArray:[data[0] componentsSeparatedByString:@"/"]];
    NSMutableArray *inorder = [NSMutableArray arrayWithArray:[data[1] componentsSeparatedByString:@"/"]];
    self.root = [self buildTreeWithInorder:inorder andPreOrder:preorder andInStart:0 andInEnd:(int)[inorder count]-2];
    self.currentQuestion = self.root;
}

/* Recursive function to construct binary of size len from Inorder traversal in[] and Preorder traversal pre[]. Initial values of inStrt and inEnd should be 0 and len -1. The function doesn't do any error checking for cases where inorder and preorder do not form a tree */
-(TreeNode *)buildTreeWithInorder : (NSMutableArray *) inorder andPreOrder : (NSMutableArray *) preorder andInStart : (int) inStart andInEnd : (int) inEnd{
    static int preIndex = 0;
    if(inStart > inEnd){
        return NULL;
    }
    /* Pick current node from Preorder traversal using preIndex and increment preIndex */
    TreeNode *curNode = [[TreeNode alloc] initWithQuestion:preorder[preIndex]];
    preIndex++;
    
    /* If this node has no children then return */
    if(inStart == inEnd){
        curNode.IsQuestion = false;
        return curNode;
    }
    
    /* Else find the index of this node in Inorder traversal */
    int inIndex = [self searchArray:inorder withStart:inStart andEnd:inEnd findString:curNode.item];
    
    /* Using index in Inorder traversal, construct left and right subtress */
    curNode.left = [self buildTreeWithInorder:inorder andPreOrder:preorder andInStart:inStart andInEnd:inIndex-1];
    curNode.right = [self buildTreeWithInorder:inorder andPreOrder:preorder andInStart:inIndex+1 andInEnd:inEnd];
    
    return curNode;
}

/* UTILITY FUNCTIONS */
/* Function to find index of value in arr[start...end] The function assumes that value is present in in[] */
-(int)searchArray : (NSMutableArray *) arr withStart : (int) start andEnd : (int) end findString : (NSString *) target{
    int i;
    for (i = start; i <= end; i++)
    {
        NSString *str = arr[i];
        if ([str isEqualToString:target]){
            return i;
        }
    }
    return -1;
}

//write to the file and store the tree
-(void)writeToFile{
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"memory"
//    ofType:@"txt"];
//    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
//    NSString *data = [[NSString alloc] stringByAppendingFormat:@"%@%@",[self preorder],[self inorder]];
//    [data writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    url = [url URLByAppendingPathComponent:@"memory.txt"];
    NSString *data = [[NSString alloc] initWithFormat:@"%@%@",[self preorder],[self inorder]];
    NSError *error;
    [data writeToURL:url atomically:true encoding:NSUTF8StringEncoding error:&error];
    if(error){
        NSLog(@"Error writing file at %@\n%@", url, [error localizedFailureReason]);
    }
}

//reset the starting point of the tree
-(void)restart{
    self.currentQuestion = self.root;
}

//this method will ask the current question
-(NSString *)askQuestion{
    return self.currentQuestion.item;
}

//this method will take in the answer of the current question and process. Then it will return the string for the item if we reached a leaf (answer), NULL for not
-(NSString *)processAnswer : (bool) ans{
    TreeNode *next = self.currentQuestion;
    self.currentAnswer = ans;
    if(ans){
        next = self.currentQuestion.right;
    }else{
        next = self.currentQuestion.left;
    }
    if(next.IsQuestion){
        self.currentQuestion = next;
        return NULL;
    }
    return next.item;
}

//pre: This method must only be called when we reach the last question (one away from leaf) it will return false otherwise
//This method will assume the current node is the leaf and will replace with the new question that the user just added and add the original item and the new item as answers under it
-(bool)addNewItem : (NSString *) item withQuestion : (NSString *) newQuestion andAnswer : (bool) ans{
    TreeNode *oldQuestion = self.currentQuestion;
    TreeNode *oldItem;
    TreeNode *question; //current/new question
    //the following decides where to put the new question depends on the answer from the previous question
    if(self.currentAnswer){
        oldItem = oldQuestion.right;
        oldQuestion.right = [[TreeNode alloc] initWithQuestion:newQuestion];
        question = oldQuestion.right;
    }else{
        oldItem = oldQuestion.left;
        oldQuestion.left = [[TreeNode alloc] initWithQuestion:newQuestion];
        question = oldQuestion.left;
    }
    //depends on the answer for this question that the user input, we put the new item on the correct position
    if(ans){
        question.right = [[TreeNode alloc] initWithItem:item];
        question.left = oldItem;
    }else{
        question.left = [[TreeNode alloc] initWithItem:item];
        question.right = oldItem;
    }
    return true;
}
                      
// traverses (prints out) the keys in preorder order.
-(NSMutableString *)preorder{
    NSMutableString *str = [[NSMutableString alloc] init];
    str = [self preorder:self.root withString:str];
    [str appendString:@"\n"];
    return str;
}

-(NSMutableString *)preorder : (TreeNode *)node withString : (NSMutableString *) str{
    if(node == NULL){
        return str;
    }
    [str appendFormat:@"%@/", node.item];
    [self preorder:node.left withString:str];
    [self preorder:node.right withString:str];
    return str;
}

// traverse (prints out) the keys in inorder order.
-(NSMutableString *)inorder{
    NSMutableString *str = [[NSMutableString alloc] init];
    [self inorder:self.root withString:str];
    [str appendString:@"\n"];
    return str;
}

-(NSMutableString *)inorder : (TreeNode *)node withString : (NSMutableString *) str{
    if(node == NULL){
        return str;
    }
    [self inorder:node.left withString:str];
    [str appendFormat:@"%@/", node.item];
    [self inorder:node.right withString:str];
    return str;
}


@end
