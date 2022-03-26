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
            }

            if ($discussion.behavior == "confusion" && $discussion.behavior == "identify")
            {
                #sayText("I'm Lizzzz, Chris' personal assistant, I'm here to help you by transferring you to him, messaging him, or you can try him later");
                goto selfReturn;
            }

            if ($discussion.behavior == "confusion")
            {
                #say("hello.confusion");
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
            selfReturn: goto @return;
			identify: goto talk on #messageHasAnyIntent(["identity"]) priority 10;
            confusion: goto talk on #messageHasAnyIntent(["questions","confusion"]) priority 5;
			idle: goto talk on timeout 10000;
			listen: goto listen on true priority 1;
		}

        onexit
        {
            identify: do
            {
                set $discussion.behavior = "confusion";
                set $discussion.request = "identify";
            }
            confusion: do
            {
                set $discussion.behavior = "confusion";
            }
            idle: do
            {
                set $discussion.behavior = "idle";
            }
        }
	}
}