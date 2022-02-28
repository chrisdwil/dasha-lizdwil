// Liz D. Wil 
import "sidekicklibrary/all.dsl";
import "sidekicklibrary/_types.dsl";	

context {
	input phone: string;
	input forward: string;
	input reason: string;
	
	logNodeName: string = "[main]";
}

start node main 
{
	do
	{	
		var logNodeNameSub = "@";
        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
		#connectSafe($phone);
		
		wait *;
	}
	
	transitions
	{
		idle: goto handler on timeout 100;
	}
}

node @exit 
{
    do 
    {
		var logNodeNameSub = "@exit";
        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
  	
        exit;
    }
}

digression @digReturn
{
		conditions
		{ 
			on true tags: onclosed; 
		}
		
		do 
		{
			var logNodeNameSub = "@digReturn";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	    	
	    	exit;
		}
}

node handler
{
	do
	{
		var logNodeNameSub = "handler";
        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
		
		blockcall hello($attendees, conversation);
		
		if ($reason != "busy")
		{
			#forward($forward);
			exit;
		}	
	}
	
	transitions 
	{
		idle: goto handler on timeout 10000;
	}
}
