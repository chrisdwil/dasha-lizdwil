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
		
		#disconnect();
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
		
		#disconnect();
		exit;
	}
}
