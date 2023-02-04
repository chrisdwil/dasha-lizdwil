library

// say hello if greeted
digression digressionHello
{
	conditions{on #messageHasIntent("hello");}
	do
	{
		#log(#getMessageText());
		var logNodeNameSub = "digressionHello";
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#say("sayHelloTextMulti");
		wait *;
		#log(#getMessageText());
	}
}