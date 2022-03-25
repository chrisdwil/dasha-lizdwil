library

block hello(discussion: interaction): interaction
{	
	context
	{

	}

	start node main
	{
		do
		{
			var localFunctionName = "@";
	        #log("[" + $discussion.Name + "] - [" + localFunctionName + "] has been executed");
	        	        
	        goto selfReturn;
	        // go to talk 
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
	        #log("[" + $discussion.Name + "] - [" + localFunctionName + "] has been executed");
	        
			return $discussion;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			var localFunctionName = "@digReturn";
	        #log("[" + $discussion.Name + "] - [" + localFunctionName + "] has been executed");
	        
			return $discussion;
		}
	}
	
	node talk
	{
		do
		{
			var localFunctionName = "talk";
	        #log("[" + $discussion.Name + "] - [" + localFunctionName + "] has been executed");
	        
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
	        #log("[" + $discussion.Name + "] - [" + localFunctionName + "] has been executed");
	        
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