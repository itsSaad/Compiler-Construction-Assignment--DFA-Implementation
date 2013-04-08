//
//  main.m
//  TestingCC
//
//  Created by Tayyab Zahid on 4/7/13.
//  Copyright (c) 2013 Tayyab Zahid. All rights reserved.
//

#import <Foundation/Foundation.h>


int main(int argc, const char * argv[])
{


    @autoreleasepool {
        
		NSString* fileName = @"/Users/T1/Dropbox/Final Project Directory/CC/TestingCC/TestingCC/Code.txt";
		NSString *fileString = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray * allLexemes = [[NSMutableArray alloc] init];
		if (fileString != nil)
		{
			/* Comments DFA
			 **
			 **
			 **
			 */	
            
            /*
             *  Positive Numbers are state number
             *  -1 is no tansition
             *  0 is Accepting state.
             */
            int commentDfa  [3][3];
			int spaceDFA    [2][2];
            int identDFA    [3][3];
			
			
            /***********	commentDfa	***************/

            commentDfa[0][0]	= 1;
            commentDfa[0][1]	= -1;
            commentDfa[0][2]	= -1;
            
            commentDfa[1][0]	= -1;
            commentDfa[1][1]	= 1;
            commentDfa[1][2]	= 999;
            
            commentDfa[2][0]	= -1;
            commentDfa[2][1]	= -1;
            commentDfa[2][2]	= -1;
			
			/***********	SpaceDFA	***************/
			
			
			spaceDFA[0][0]		= 999;
            spaceDFA[0][1]      = -1;
			spaceDFA[1][0]      = 999;
			spaceDFA[1][1]      = -1;
        
			
            /***********	IdentifierDFA	***************/
            
            identDFA    [0][0] = 1;
            identDFA    [0][1] = -1;
            identDFA    [0][2] = -1;
            
            identDFA    [1][0] = 1;
            identDFA    [1][1] = 1;
            identDFA    [1][2] = 999;
            
            identDFA    [2][0] = -1;
            identDFA    [2][1] = -1;
            identDFA    [2][2] = -1;
            
            
            
            //Print File COntnt
            NSLog(@"%@", fileString);
            int codeLen = (int)[fileString length];
            NSLog(@"Code Total Length ==>%i \n\n\n",codeLen);
            
            int openBraceCount  =  0; // count for open brace
            int closeBraceCount = 0; // count for close brace
            NSString * lexemeFound = [[NSString alloc] init];

            int inputIndex  = 0;
            int stateIndex  = 0;
            int lexemeStart = 0;
            int lexemeEnd   = 0;
            int forward     = 0;
            int lexemeLength = 0;
            int currentDFAState = 0;
            
            NSRange lexemeBounds;
            
            BOOL flagDFAOK;
            BOOL flagDFAAccepted = FALSE;
            char currentChar;
            
            while (forward <=codeLen)
            {
                // Reading the file context text
                
                if (forward < [fileString length])
                {
                     currentChar = [fileString characterAtIndex:forward];
                }
                else
                {
                    break;
                }
				/***********	SpaceDFA	***************/
				stateIndex = 0;
                do
                {
					flagDFAOK = TRUE;
					
					if (currentChar == ' ')
					{
						inputIndex = 0;
						stateIndex = spaceDFA[stateIndex][inputIndex];
                        if (stateIndex == 999)
                        {
                            stateIndex = 1;
                            currentDFAState = 999;
                        }
						NSLog(@"Space Found");
                        
                        
                        forward++;
                        if (forward < [fileString length])
                        {
                            currentChar = [fileString characterAtIndex:forward];
                        }
                        else
                        {
                            break;
                        }
                        
					}
					else
					{
                        if(currentDFAState == 999)
                        {
                            NSLog(@"SpaceDFA Accepted");
                            flagDFAAccepted = TRUE;
                            flagDFAOK = FALSE;
                            forward--;
                            
                        }
                        else
                        {
                            flagDFAAccepted = FALSE;
                            flagDFAOK = FALSE;
                            NSLog(@"SpaceDFA Exiting");
                        }
					}
				}while(flagDFAOK);
				/***********	CommentDFA	***************/
				lexemeStart = forward;
                stateIndex = 0;
                currentDFAState = 0;
                //lexemeBounds.location = 0;
                //lexemeBounds.length = 0;
                lexemeLength        = 0;
                do
				{
                    if(flagDFAAccepted)
                    {
                        break;
                    }
					lexemeLength++;
					flagDFAOK = TRUE;
					
					if (currentChar == '{' && openBraceCount == 0)     //input is '{'
					{
						inputIndex = 0;
						stateIndex = commentDfa[stateIndex][inputIndex];
						NSLog(@"Open Brace");
						openBraceCount++;

                        forward++;
                        if (forward < [fileString length])
                        {
                            currentChar = [fileString characterAtIndex:forward];
                        }
                        else
                        {
                            break;
                        }
						
					}
					
					
					
					else if(currentChar != '}'&& closeBraceCount == 0  && openBraceCount == 1) //input is anything but }
					{
						inputIndex = 1;
						stateIndex = commentDfa[stateIndex][inputIndex];
						NSLog(@"%c",currentChar);
                        
                        
                        
                        forward++;
                        if (forward < [fileString length])
                        {
                            currentChar = [fileString characterAtIndex:forward];
                        }
                        else
                        {
                            break;
                        }
                        
					}
					
					else if (currentChar == '}'&& closeBraceCount == 0)
					{
						inputIndex = 2;
						stateIndex = commentDfa[stateIndex][inputIndex];
						NSLog(@"Close Brace");
						closeBraceCount++;
                        
                        if (stateIndex == 999)
                        {
                            stateIndex = 1;
                            currentDFAState = 999;
                        }
                        
                        forward++;
                        if (forward < [fileString length])
                        {
                            currentChar = [fileString characterAtIndex:forward];
                        }
                        else
                        {
                            break;
                        }
                        
					}
					
					else
					{
                        closeBraceCount = 0;
                        openBraceCount  = 0;
						if (currentDFAState == 999)
                        {
							NSLog(@"Accepted DFA Comments");
                            flagDFAAccepted = TRUE;
                            lexemeEnd = forward - 1;
                            
							lexemeBounds.location	= lexemeStart;
							lexemeBounds.length		= lexemeLength-1;
							
                            lexemeFound = [fileString substringWithRange:lexemeBounds];
							NSLog(@"Current Lexeme ==> %@", lexemeFound);
                            [allLexemes addObject:lexemeFound];
                            flagDFAOK = FALSE;
                            forward--;
                                                        
						}
						else
						{
							NSLog(@"CommentDFA not in accepting State. State is:  %i", currentDFAState);
                            
							flagDFAOK = FALSE;
						}
					}

				
				}while(flagDFAOK);
                
                /***********	IndentifierDFA	***************/
                /***********	IndentifierDFA	***************/
                /***********	IndentifierDFA	***************/
                
                lexemeStart     = forward;
                stateIndex      = 0;
                currentDFAState = 0;
                lexemeLength    = 0;
                flagDFAOK       = TRUE;
                do
                {
                    lexemeLength++;
                    
                    if(flagDFAAccepted)
                    {
                        break;
                    }
                    
                    if ((currentChar >= (char)65 && currentChar <= (char)90)
                                    || (currentChar >= (char)97 && currentChar <= (char)122)
                                    || (currentChar == 95))

                    {
                        NSLog(@"Letter Found %c", currentChar);
                        inputIndex = 0;
                        stateIndex = identDFA[stateIndex][inputIndex];
                        
                        
                        forward++;
                        if (forward < [fileString length])
                        {
                            currentChar = [fileString characterAtIndex:forward];
                        }
                        else
                        {
                            break;
                        }
                    }
                    else if ((currentChar >= (char)65 && currentChar <= (char)90)
                             || (currentChar >= (char)97 && currentChar <= (char)122)
                             || (currentChar >= (char)48 && currentChar<=(char)57)
                             || (currentChar == 95))
                    {
                        inputIndex = 1;
                        stateIndex = identDFA[stateIndex][inputIndex];
                        
                        
                        NSLog(@"Letter or Digit Found %c", currentChar);
                        
                        forward++;
                        if (forward < [fileString length])
                        {
                            currentChar = [fileString characterAtIndex:forward];
                        }
                        else
                        {
                            break;
                        }
                    }
                    //Accepting Chars
                    else if (((currentChar == 32)
                               || (currentChar == 33)
                               || (currentChar == 37)
                               || (currentChar == 38)
                               || (currentChar == 42)
                               || (currentChar == 43)
                               || (currentChar == 45)
                               || (currentChar == 47)
                               || (currentChar == 59)
                               || (currentChar == 60)
                               || (currentChar == 61)
                               || (currentChar == 62)))
                    {
                        inputIndex = 2;
                        stateIndex = identDFA[stateIndex][inputIndex];
                        
                        if (stateIndex == 999)
                        {
                            currentDFAState = 999;
                            stateIndex = 1;
                        }
                        if (currentDFAState == 999)
                        {
							NSLog(@"Accepted DFA Identifier");
                            flagDFAAccepted = TRUE;
                            lexemeEnd = forward - 1;
                            
							lexemeBounds.location	= lexemeStart;
							lexemeBounds.length		= lexemeLength-1;
							
                            lexemeFound = [fileString substringWithRange:lexemeBounds];
							NSLog(@"Current Lexeme ==> %@", lexemeFound);
                            [allLexemes addObject:lexemeFound];
                            flagDFAOK = FALSE;
                            forward--;
                            
						}
                        
                    }

                    
                    
                    //Non-Accepting Chars
                    else if (!((currentChar >= (char)65 && currentChar <= (char)90)
                             || (currentChar >= (char)97 && currentChar <= (char)122)
                             || (currentChar >= (char)48 && currentChar<=(char)57)
                             || (currentChar == 95)
                             || (currentChar == 32)
                             || (currentChar == 33)
                             || (currentChar == 37)
                             || (currentChar == 38)
                             || (currentChar == 42)
                             || (currentChar == 43)
                             || (currentChar == 45)
                             || (currentChar == 47)
                             || (currentChar == 59)
                             || (currentChar == 60)
                             || (currentChar == 61)
                             || (currentChar == 62)))
                    {
                        
                        
                        
                        NSLog(@"IdentifierDFA not in accepting State. State is:  %i", currentDFAState);
                        flagDFAOK = FALSE;
                        
                        
                    }
                } while (flagDFAOK);
                
				forward++;
            }
            
            
		}
		else        //incase code file not found.
            
		{
			NSLog(@"Nothing Written");
		}
        NSLog(@"%@", allLexemes);
        
    }
    
    return 0;
}

