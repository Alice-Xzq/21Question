# 21Question

21 Questions (Adapted from Stanford CS106x)

In this problem you will implement a yes/no guessing game called "21 Questions." This problem uses your new knowledge of binary trees to create a game where the computer guesses an object a person is thinking of and learns from its mistakes.

This version of the game has the following new major features:

The computer stores its knowledge of questions and answers in a binary tree.
The computer updates its question tree after each game it loses by asking the human player for a new question and answer, and therefore it gets better at the game over time.
The computer can save and load its tree of questions and answers from the disk so that it will retain its improvements over time, even after the program exits and reloads later.
The computer will try to guess the object by asking the user a series of yes-or-no questions. Eventually the computer will have asked enough questions that it thinks it knows what object the user is thinking of, so it will make a final guess about what the object is. If this guess is correct, the computer wins; if not, the user wins. 
