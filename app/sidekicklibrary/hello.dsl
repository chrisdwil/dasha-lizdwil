library

block hello(discussion: interaction?): interaction? //, restrictions: concerns): interaction
{	
	context 
	{
		//localDiscussion: interaction? = $discussion;
		interactionExecuted: boolean = false;
	
		localName:string?;
		localAgenda: string?;
		localRequest: string?; // examples: transfer, message, farewell, unknown
		localBehavior: string?; // examples: positive, neutral, negative, idle, confused
		localPhrase: string?;
		
		// all people in discussion
		localHost: talker?;
		localSidekick: talker?;
		localGuest: talker?;
		
		localJournal: string[]?;
		localResults: result[]?;
}
	
	start node main
	{
		do
		{
			var localFunctionName = "@";
			#log($localName as string + "hi ");
	        //#log("[" + $localName + "] - [" + localFunctionName + "] has been executed");
	        /*
	        set $localName = $discussion.name;
	        set $localAgenda = $discussion.agenda;
	        set $localRequest = $discussion.request;
	        set $localBehavior = $discussion.behavior;
	        set $localPhrase = $discussion.phrase;
	        set $localHost = $discussion.host;
	        set $localSidekick = $discussion.sidekick;
	        set $localGuest = $discussion.guest;
	        set $localJournal = $discussion.journal;
	        set $localResults = $discussion.results;
	        */
	        	        
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