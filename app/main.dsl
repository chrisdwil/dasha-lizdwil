// Liz D. Wil - Beta V0
context
{
	input phone: string;
	input forward: string;
	input reason: string;

	greeted: boolean = false;
	
	logNodeName: string = "main";
}

external function messageForward(): boolean;

start node main
{
	do
	{
		var logNodeNameSub = "@";
		#log("---------------");
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#log($phone);
		#log($forward);
		#log($reason);
		#log("---------------");

		#connectSafe($phone);
		#waitForSpeech(5000);
		#say("sayHelloTextRandom");
		wait *;
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
	conditions{on true tags: onclosed;}
	do
	{
		var logNodeNameSub = "@digReturn";
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		
		exit;
	}
}

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

digression digressionGoodbye
{
	conditions{on #messageHasIntent("goodbye");}
	do
	{
		var logNodeNameSub = "digressionGoodbye";
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#say("sayGoodbyeTextRandom");
		exit;
	}
}