library

block hello(group: people, conversation: discussion): discussion
{	
	context {
		logNodeName: string = "[hello]";
		greeted: boolean = false;
	}
	
	start node hello
	{
		do
		{
			var logNodeNameSub = "@";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        #log(conversation);
	        	        
	        if (#waitForSpeech(5000))
	        {
				#say("hello");
				set $greeted = true;
				wait *;
	        }
	        wait *;
		}
		
		transitions
		{
			idle: goto handler on true;
			helloForce: goto handler;
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
	
	node handler
	{
		do
		{
			var logNodeNameSub = "handler";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        #log(conversation);
			
	        if (!greeted)
	        {
				#say("hello");
				set $greeted = true;
				wait *;
			}
	        
	        goto listen;
		}
		
		transitions
		{
			list: goto handler;
		}
	}
	
	node listen
	{
		do
		{
			var logNodeNameSub = "listen";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        #log(conversation);
	        
	        wait *;
		}
		transitions
		{
			confusion: goto handler on #messageHasAnyIntent(["questions","confusion"]) priority 5;
			idle: goto helloRepeat on timeout 5000;
		}
	}
}