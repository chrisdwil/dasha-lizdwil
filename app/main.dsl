// Liz D. Wil 
import "sidekicklibrary/all.dsl";

type Person = {
    name: string;
    age: number;
    phone: string?;
};

context {
	input phone: string;
	input forward: string;
	input reason: string;
	
	logNodeName: string = "main";

    persons: Person[] = [{name: "Bob", age: 20}];
}


start node main 
{
	do
	{	
		var logNodeNameSub = "@";
        #log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
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
        #log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
  	
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
        #log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
    	
    	exit;
	}
}


node handler
{
	do
	{
		var logNodeNameSub = "handler";
        #log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		                
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
