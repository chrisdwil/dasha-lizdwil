// Liz D. Wil 
import "sidekicklibrary/all.dsl";

context 
{
	input phone: string;
	input forward: string;
	input reason: string;
		
	logNodeName: string = "main";
	
	primary: talker = 
	{
			name: "Chris D. Wil",
			nick: "Chris",
			phonetic: "Chris Dee Wil"
	};
	
	secondary: talker = 
	{
			name: "Elize D. Wil",
			nick: "Lizzz",
			phonetic: "Lizzz Dee Wil"
	};
	
	tertiary: talker = 
	{
			name: null,
			nick: null,
			phonetic: null
	};
	
	phonecall: interaction = 
	 	{
			name: "initialize",
			agenda: "creating phone call array",
			greet: true,
			request: null,
			behavior: null,
			phrase: null,
			host: null,
			sidekick: null,
			guest: null
	 	};
}

start node main
{
	do
	{	
		var logNodeNameSub = "@";
        #log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		set $phonecall.host = $primary;
		set $phonecall.sidekick = $secondary;
		set $phonecall.guest = $tertiary;
        #log($phonecall);

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

		var greetHello: interaction = 
		{
			name: "hello",
			agenda: "say hello to caller, confirm they exist",
			greet: true,
			request: null,
			behavior: null,
			phrase: null,
			host: $primary,
			sidekick: $secondary,
			guest: $tertiary
		};

		set $phonecall = blockcall hello(greetHello);
		#log($phonecall);
		#sayText("So what can I help you with?");

		#sayText("Actually, I gotta go");

        exit;
	}

	transitions 
	{
		idle: goto handler on timeout 10000;
	}
}