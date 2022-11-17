library

// say hello if greeted
digression digressionHello
{
	conditions{on #messageHasIntent("hello");}
	do
	{
		var logNodeNameSub = "digressionHello";
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#say("sayHelloTextMulti");
		wait *;
	}
}

// say goodbye and hangup
digression digressionGoodbye
{
	conditions{on #messageHasIntent("goodbye");}
	do
	{
		var logNodeNameSub = "digressionGoodbye";
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#say("sayGoodbyeTextRandom");
        #disconnect();
		exit;
	}
}