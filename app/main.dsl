// Liz D. Wil
import "sidekicklibrary/all.dsl";

context
{
	input phone: string;
	input forward: string;
	input reason: string;

	greeted: boolean = false;
	
	logNodeName: string = "main";
	
	primary: talker =
	{
		name: "Chris D. Wil",
		nick: "Chris",
		phonetic: "Chris Dee Wil"
	}
	;
	
	secondary: talker =
	{
		name: "Elize D. Wil",
		nick: "Lizzz",
		phonetic: "Lizzz Dee Wil"
	}
	;
	
	tertiary: talker =
	{
		name: null,
		nick: null,
		phonetic: null
	}
	;
	
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
		guest: null,
		sentiment: null,
		text: null,
		sentenceType: null
	}
	;
}

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

		if (#getVisitCount("handler") < 2)
		{
			var helloMain: interaction =
			{
				name: "hello",
				agenda: "say hello to caller, confirm they exist",
				greet: true,
				request: null,
				behavior: null,
				phrase: null,
				host: $primary,
				sidekick: $secondary,
				guest: $tertiary,
				sentiment: null,
				text: null,
				sentenceType: null
			};

			set $phonecall = blockcall hello(helloMain);
		}
		#log($phonecall);

		if ($phonecall.request is not null)
		{
			if ($phonecall.request == "greeted")
			{
				var assistMain = 
				{
					name: "assist",
					agenda: "ask them how you can assist today",
					greet: true,
					request: null,
					behavior: null,
					phrase: null,
					host: $primary,
					sidekick: $secondary,
					guest: $tertiary,
					sentiment: null,
					text: null,
					sentenceType: null
				};

				set $phonecall = blockcall assist(assistMain);
			}
		}

		exit;
	}
	
	transitions
	{
		idle: goto handler on timeout 10000;
	}
}
