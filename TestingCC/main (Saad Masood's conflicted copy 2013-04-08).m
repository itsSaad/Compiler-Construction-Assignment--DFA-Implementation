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
        
		NSString* fileName = @"/Volumes/Personal/Dropbox/Final Project Directory/CC/TestingCC/TestingCC/Code.txt";
		NSString *fileString = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
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
            int commentDfa[3][3];
			int spaceDFA [2][2];
			
			
            /***********	commentDfa	***************/

            commentDfa[0][0]	= 1;
            commentDfa[0][1]	= -1;
            commentDfa[0][2]	= -1;
            
            commentDfa[1][0]	= -1;
            commentDfa[1][1]	= 1;
            commentDfa[1][2]	= 0;
            
            commentDfa[2][0]	= -1;
            commentDfa[2][1]	= -1;
            commentDfa[2][2]	= 0;
			
			/***********	SpaceDFA	***************/
			
			
			spaceDFA[0][0]		= 0;
            spaceDFA[0][1]		= -1;
			
			spaceDFA[1][0]		= 0;
			spaceDFA[1][1]		= -1;
			
            //Print File COntnt
            NSLog(@"%@", fileString);
            int codeLen = (int)[fileString length];
            NSLog(@"%i \n\n\n",codeLen);
            
            int openBraceCount  =  0; // count for open brace
            int closeBraceCount = 0; // count for close brace
            
            int inputIndex  = 0;
            int stateIndex  = 0;
            int lb          = 0;
            int forward     = 0;
            //int braceCount  = 0;               //to detect a {{ in comments which is not allowed.
            int lexStart    = 0;
            BOOL flagDFAOK;
            char currentChar;
            
            while (1)
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
				do
                {
					flagDFAOK = TRUE;
					stateIndex = 0;
					if (currentChar == ' ')
					{
						inputIndex = 0;
						stateIndex = spaceDFA[stateIndex][inputIndex];
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
						flagDFAOK = FALSE;
                        NSLog(@"SpaceDFA Exiting");
					}
				}while(flagDFAOK);
				/***********	CommentDFA	***************/
				do
				{
					flagDFAOK = TRUE;
					stateIndex = 0;
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
					
					
					
					else if(currentChar != '}'&& closeBraceCount == 0) //input is anything but }
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
						if (stateIndex == 0) {
							NSLog(@"Accespted DFA Comments");
                            break;
						}
						else
						{
							NSLog(@"DFA not in accepting State. State is:  %i", stateIndex);
							flagDFAOK = FALSE;
						}
					}

				
				}while(flagDFAOK);
				forward++;
            }
            
            
		}
		else        //incase code file not found.
            
		{
			NSLog(@"Nothing Written");
		}
        
    }
    
    return 0;
}