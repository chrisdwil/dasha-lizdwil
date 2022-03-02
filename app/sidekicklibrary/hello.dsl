library

block hello(discussion: interaction, restrictions: concerns): interaction
{	
	context {
		localAgenda: string = "hello";
		interactionExecuted: boolean = false;
	}
	
	start node main
	{
		do
		{
			var localFunctionName = "@";
	        #log("[" + $localAgenda + "] - [" + $localFunctionName + "] has been executed");
	        
	        // go to talk 
		}
	}
	
	node @return
	{
		do
		{
			var localFunctionName = "@return";
	        #log("[" + $localAgenda + "] - [" + $localFunctionName + "] has been executed");
	        
			return $interaction;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			var localFunctionName = "@digReturn";
	        #log("[" + $localAgenda + "] - [" + $localFunctionName + "] has been executed");
	        
			return $interaction;
		}
	}
	
	node talk
	{
		do
		{
			var localFunctionName = "talk";
	        #log("[" + $localAgenda + "] - [" + $localFunctionName + "] has been executed");
	        
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
	        #log("[" + $localAgenda + "] - [" + $localFunctionName + "] has been executed");
	        
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