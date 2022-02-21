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
	        #log($conversation);
	        	        
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
			idle: goto talker on true;
			helloForce: goto talker;
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
	
	node talker
	{
		do
		{
			var logNodeNameSub = "talker";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        #log($conversation);
			
	        if (!$greeted)
	        {
				#say("hello");
				set $greeted = true;
				wait *;
			}
	        
	        goto listener;
		}
		
		transitions
		{
			listener: goto talker;
		}
	}
	
	node listener
	{
		do
		{
			var logNodeNameSub = "listener";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        #log($conversation);
	        
	        wait *;
		}
		transitions
		{
			confusion: goto talker on #messageHasAnyIntent(["questions","confusion"]) priority 5;
			idle: goto talker on timeout 5000;
		}
	}
}