library

block hello(discussion: interaction?): interaction? //, restrictions: concerns): interaction
{	
	context 
	{
		//localDiscussion: interaction? = $discussion;
		localName:string = "hello";
		interactionExecuted: boolean = false;
		returnResult: interaction? = $discussion;
	}
	
	start node main
	{
		do
		{
			var localFunctionName = "@";
	        #log("[" + $localName + "] - [" + localFunctionName + "] has been executed");
	        
	        set $returnResult = 
	        	{
	        		name: "hello",
	        		agenda: "confirm caller is present",
	        		request: "transfer",
	        		behavior: "positive",
	        		phrase: null,
	        		host: $discussion["host"],
	        		sidekick: $discussion["sidekick"],
	        		guest: $discussion["guest"],
	        		journal: null,
	        		results: null
	        	};
	       
	        return $returnResult;
	        // go to talk 
		}
	}
	
	node @return
	{
		do
		{
			var localFunctionName = "@return";
	        #log("[" + $localName + "] - [" + localFunctionName + "] has been executed");
	        
			return $discussion;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			var localFunctionName = "@digReturn";
	        #log("[" + $localName + "] - [" + localFunctionName + "] has been executed");
	        
			return $discussion;
		}
	}
	
	node talk
	{
		do
		{
			var localFunctionName = "talk";
	        #log("[" + $localName + "] - [" + localFunctionName + "] has been executed");
	        
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
	        #log("[" + $localName + "] - [" + localFunctionName + "] has been executed");
	        
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