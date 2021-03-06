library

block hello ( discussion: interaction ): interaction
{	
	context
	{

	}

	start node main
	{
		do
		{
			var localFunctionName = "@";
	        #log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");

            set $discussion.request = "transfer";

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

	        goto listen;
		}
		
		transitions
		{
			listen: goto listen;
		}
	}
	
	node listen
	{
		do
		{
			var localFunctionName = "listen";
	        #log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
	        
	        wait *;
		}
		
		transitions
		{
			confusion: goto talk on #messageHasAnyIntent(["questions","confusion"]) priority 5;
			idle: goto talk on timeout 5000;
			listen: goto listen on true priority 1;
		}
	}
}