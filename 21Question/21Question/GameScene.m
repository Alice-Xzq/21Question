//
//  GameScene.m
//  21Question
//
//  Created by zxiao23 on 5/4/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKLabelNode *_titleLabel;
    SKLabelNode *_instruction;
    SKLabelNode *_question;
    
    bool finalPhase;//this boolean is to record whether the game is in the final phase or not to determine what will the y and n keys do
    bool enteringMode;
    bool enteringItem;
    bool enteringAnswer;
    QuestionTree *myTree;
    NSMutableString *userInputItem;
    NSMutableString *userInputQuestion;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    myTree = [[QuestionTree alloc] initWithBasicQuestion];
    finalPhase = false;
    enteringMode = false;
    enteringAnswer = false;
    userInputItem = [[NSMutableString alloc]init];
    userInputQuestion = [[NSMutableString alloc]init];
    // Get label node from scene and store it for use later
    _titleLabel = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    _instruction = (SKLabelNode *)[self childNodeWithName:@"//instructionLabel"];
    _question = (SKLabelNode *)[self childNodeWithName:@"//questionLabel"];
    
    _titleLabel.alpha = 0.0;
    [_titleLabel runAction:[SKAction fadeInWithDuration:2.0]];
    _instruction.text = @"Press enter to start";
    _instruction.color = [NSColor blackColor];
    [_instruction runAction:[SKAction fadeInWithDuration:2.0]];
}


- (void)keyDown:(NSEvent *)theEvent {
    if(!enteringMode){
        switch (theEvent.keyCode) {
            case 0x31 /* SPACE */:
                // Run 'Pulse' action from 'Actions.sks'
                [_titleLabel runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
                break;
            case 0x24 /* ENTER */:
                _instruction.text = @"Do you want me to recall my memory? Press T for yes and F for no";
                _question.text = @"Please don't read if this is your first time running";
                [_instruction runAction:[SKAction fadeInWithDuration:2.0]];
                [_question runAction:[SKAction fadeInWithDuration:2.0]];
                break;
            case 0x11 /*t for true (reading file)*/:
                [myTree readFromFile];
                _instruction.text = @"Please press y for yes to the question and n for no";
                _question.text = [myTree askQuestion];
                break;
            case 0x03 /*f for false (not reading file)*/:
                _instruction.text = @"Please press y for yes to the question and n for no";
                _question.text = [myTree askQuestion];
                break;
            case 0x10 /*y for yes*/:
                if(enteringAnswer){//if entering answer is on, this is the answer the user had for the question
                    [myTree addNewItem:userInputItem withQuestion:userInputQuestion andAnswer:true];
                    [_question runAction:[SKAction fadeOutWithDuration:2.0]];
                    _instruction.text = @"Thank you for your input! Press r to restart or e to exit";
                    enteringAnswer = false;
                }
                else if(!finalPhase){//when we are not in the final phase (giving an answer to the user)
                    if([myTree processAnswer:true] == NULL){//when we didn't reach a leaf
                        _question.text = [myTree askQuestion];
                    }else{//when we reach a leaf
                        NSString *item = myTree.currentQuestion.right.item;
                        _question.text = [NSString stringWithFormat:@"Is your item %@?", item];
                        finalPhase = true;
                    }
                }else{//when we are asking the user if our final answer is correct
                    _instruction.text = @"Niceeeee I got it! Press r to restart or e to exit";
                    [_question runAction:[SKAction fadeOutWithDuration:2.0]];
                }
                break;
            case 0x2D /*n for no*/:
                if(enteringAnswer){//if entering answer is on, this is the answer the user had for the question
                    [myTree addNewItem:userInputItem withQuestion:userInputQuestion andAnswer:false];
                    [_question runAction:[SKAction fadeOutWithDuration:2.0]];
                    _instruction.text = @"Thank you for your input! Press r to restart or e to exit";
                    enteringAnswer = false;
                }
                else if(!finalPhase){//when we are not in the final phase (giving an answer to the user)
                    if([myTree processAnswer:false] == NULL){//when we didn't reach a leaf
                        _question.text = [myTree askQuestion];
                    }else{//when we reach a leaf
                        NSString *item = myTree.currentQuestion.left.item;
                        _question.text = [NSString stringWithFormat:@"Is your item %@?", item];
                        finalPhase = true;
                    }
                }else{//when we are asking the user if our final answer is correct
                    _question.text = @"Oh no... I didn't get the answer, what is the item you are thinking about?";
                    _instruction.text = @"Press a if you want to tell me and add it, press r otherwise";
                }
                break;
            case 0x00 /*a for add*/:
                enteringMode = true;
                enteringItem = true;
                userInputItem = [[NSMutableString alloc] init];
                userInputQuestion = [[NSMutableString alloc] init];
                _instruction.text = @"Please enter your item, press enter to enter";
                _question.text = @"";
                break;
            case 0x0F /*r for restart*/:
                [myTree restart];
                [_instruction runAction:[SKAction fadeInWithDuration:2.0]];
                [_question runAction:[SKAction fadeInWithDuration:2.0]];
                _instruction.text = @"Please press y for yes to the question and n for no";
                _question.text = [myTree askQuestion];
                finalPhase = false;
                break;
            case 0x0E /*e for exit*/:
                [myTree writeToFile];
                [_question runAction:[SKAction fadeOutWithDuration:2.0]];
                _instruction.text = @"Thank you for playing!";
                break;
            default:
                NSLog(@"keyDown:'%@' keyCode: 0x%02X", theEvent.characters, theEvent.keyCode);
                break;
        }
    }else{//in the entering mode
        switch (theEvent.keyCode) {
            case 0x24 /* ENTER */:
                if(enteringItem){
                    _instruction.text = @"Please enter your question, press enter to enter";
                    enteringItem = false;
                }else{
                    enteringMode = false;
                    _instruction.text = @"What is the answer for the item? y for yes, n for no";
                    enteringAnswer = true;
                }
                break;
            case 0x33 /* delete */:
                if(enteringItem){
                    [userInputItem deleteCharactersInRange:NSMakeRange([userInputItem length]-1, 1)];
                    _question.text = userInputItem;
                }else{
                    [userInputQuestion deleteCharactersInRange:NSMakeRange([userInputQuestion length]-1, 1)];
                    _question.text = userInputQuestion;
                }
                break;
        default:
                if(enteringItem){
                    [userInputItem appendFormat:@"%@", theEvent.characters];
                    _question.text = userInputItem;
                }else{
                    [userInputQuestion appendFormat:@"%@", theEvent.characters];
                    _question.text = userInputQuestion;
                }
                NSLog(@"keyDown:'%@' keyCode: 0x%02X", theEvent.characters, theEvent.keyCode);
                break;
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
   
}
- (void)mouseDragged:(NSEvent *)theEvent {
    
}
- (void)mouseUp:(NSEvent *)theEvent {
    
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
