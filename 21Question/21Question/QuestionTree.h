//
//  QuestionTree.h
//  21Question
//
//  Created by zxiao23 on 5/6/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#ifndef QuestionTree_h
#define QuestionTree_h
#import "TreeNode.h"

@interface QuestionTree : NSObject

//instance variables
@property TreeNode *root;
@property TreeNode *currentQuestion;
@property bool currentAnswer;

//constructors
-(instancetype)initWithBasicQuestion;

//methods
-(void)restart; //reset the starting point of the tree
//read from the file and create the tree
-(void)readFromFile;
//write to the file and store the tree
-(void)writeToFile;
//this method will ask the current question
-(NSString *)askQuestion;
//this method will take in the answer of the current question and process. Then it will return the string for the item if we reached a leaf (answer), NULL for not
-(NSString *)processAnswer : (bool) ans;
//pre: This method must only be called when we reach the last question (one away from leaf) it will return false otherwise
//This method will assume the current node is the leaf and will replace with the new question that the user just added and add the original item and the new item as answers under it
-(bool)addNewItem : (NSString *) item withQuestion : (NSString *) newQuestion andAnswer : (bool) ans;

@end

#endif /* QuestionTree_h */
