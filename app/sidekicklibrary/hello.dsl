library

block hello ( discussion: interaction ): interaction
{	
	context
	{
        defaultAttempts: number = 4;
	}

	start node main
	{
		do
		{
			var localFunctionName = "@";
	        #log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");

	        if ($discussion.greet)
            {
                goto talk;
            }
            else
            {
                goto listen;
            }
            
            goto selfReturn;
		}
		
		transitions
		{
			selfReturn: goto @return;
            talk: goto talk;
            listen: goto listen;
		}
	}
	
	node @return
	{
		do
		{
			var localFunctionName = "@return";
	        #log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
	        
			return $discussion;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			var localFunctionName = "@digReturn";
	        #log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
	        
			return $discussion;
		}
	}
	
	node talk
	{
		do
		{
			var localFunctionName = "talk";
	        #log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
            #log($discussion);
			set $discussion.sentiment = null;
			set $discussion.text = null;
			set $discussion.sentenceType = #getSentenceType();

            if ($discussion.greet)
            {                
                #say("hello.greet");
                set $discussion.greet = false;
	            #log("[" + $discussion.name + "] - [" + localFunctionName + "] has been greeted");
            }

            if ($discussion.sentenceType == "question")
            { 
                    #say("hello.confusion");
                    #log("[" + $discussion.name + "] - [" + localFunctionName + "] caller asked a question");                    
			}

			if ($discussion.sentenceType == "statement")
			{
            	#log("[" + $discussion.name + "] - [" + localFunctionName + "] caller made a statement");
			}

			if ($discussion.sentenceType == "request")
			{
				#log("[" + $discussion.name + "] - [" + localFunctionName + "] caller made a request");	
			}

			if ($discussion.behavior == "idle")
			{
				#say("hello.idle");
				#log("[" + $discussion.name + "] - [" + localFunctionName + "] caller is idle or not understandable");
			}

	        goto listen;
		}
		
		transitions
		{
            selfReturn: goto @return;
			listen: goto listen;
		}
	}
	
	node listen
	{
		do
		{
			var localFunctionName = "listen";
	        #log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
            #log($discussion);

	        wait *;
		}
		
		transitions
		{
			idle: goto talk on timeout 10000;
			listen: goto listen on true priority 1;
		}

        onexit
        {
			idle: do
			{	
				#log("transition idle");

                set $discussion.behavior = "idle";
                set $discussion.request = "repeat";
            }

			default: do
			{
				#log("transition default");				
				set $discussion.behavior = null;
				set $discussion.request = null;
			}
        }
	}
}