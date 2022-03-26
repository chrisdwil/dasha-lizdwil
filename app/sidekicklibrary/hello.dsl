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

            if ($discussion.greet)
            {                
                #say("hello.greet");
                set $discussion.greet = false;
	            #log("[" + $discussion.name + "] - [" + localFunctionName + "] has been greeted");
            }

            if ($discussion.behavior == "idle")
            {
                #say("hello.idle");
				#log("[" + $discussion.name + "] - [" + localFunctionName + "] caller is idle");

            }

            if ($discussion.behavior == "confusion")
            {
                if ($discussion.request == "identity")
                {
                    #say("hello.identity");
                    #log("[" + $discussion.name + "] - [" + localFunctionName + "] caller requested identity");
					goto selfReturn;
                }
				if ($discussion.request == "repeat")
                {
                    #say("hello.confusion");
                    #log("[" + $discussion.name + "] - [" + localFunctionName + "] caller is confused");                    
                }
            }

			if ($discussion.behavior == "positive")
			{
				if ($discussion.request == "greeted")
				{
                    #say("hello.greeted");
                    #log("[" + $discussion.name + "] - [" + localFunctionName + "] caller greeted");
					goto selfReturn;	
				}
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
			identity: goto talk on #messageHasAnyIntent(["identity"]) priority 10;
			greeted: goto talk on #messageHasAnyIntent(["greeted"]) priority 10;
            confusion: goto talk on #messageHasAnyIntent(["questions","confusion"]) priority 5;
			idle: goto talk on timeout 10000;
			listen: goto listen on true priority 1;
		}

        onexit
        {
            identity: do
            {
                set $discussion.behavior = "confusion";
                set $discussion.request = "identity";
            }
            confusion: do
            {
                set $discussion.behavior = "confusion";
                set $discussion.request = "repeat";
            }
            idle: do
            {
                set $discussion.behavior = "idle";
                set $discussion.request = "repeat";
            }
			greeted: do
			{
				set $discussion.behavior = "positive";
				set $discussion.request = "greeted";
			}
        }
	}
}