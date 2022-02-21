library

block hello(group: people, conversation: discussion): discussion
{	
	context {
		logNodeName: string = "[hello]";
		greeted: boolean = false;
	}
	
	start node main
	{
		do
		{
			var logNodeNameSub = "@";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        #log($conversation);
	        	        
	        if (#waitForSpeech(5000))
	        {
				#say("hello");
				set $greeted = true;
				wait *;
	        }
	        else
	        {
	        	goto greet;
	        }
		}
		
		transitions
		{
			greeted: goto talk on true;
			greet: goto talk;
		}
	}
	
	node @return
	{
		do
		{
			var logNodeNameSub = "@return";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        
			return $conversation;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			var logNodeNameSub = "@digReturn";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        
			return $conversation;
		}
	}
	
	node talk
	{
		do
		{
			var logNodeNameSub = "talk";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        #log($conversation);
	        
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
			var logNodeNameSub = "listen";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        #log($conversation);
	        
	        wait *;
		}
		
		transitions
		{
			confusion: goto talk on #messageHasAnyIntent(["questions","confusion"]) priority 5;
			idle: goto talk on timeout 5000;
			listen: goto listen on true priority 1;
			transfer: goto @return on #messageHasAnyIntent(["transfer"]) priority 9;
		}
		
		onexit 
		{			
			transfer: do
			{
				set $conversation["request"] = "transfer";
				set $conversation["behavior"] = "neutral";
				$conversation["journal"].push(#getMessageText());
			}
		}
	}
}