library

import "_types.dsl"

block hello(interaction: thread): thread
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
	        
			return $interaction;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			var logNodeNameSub = "@digReturn";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        
			return $interaction;
		}
	}
	
	node talk
	{
		do
		{
			var logNodeNameSub = "talk";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	        
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
			}
		}
	}
}