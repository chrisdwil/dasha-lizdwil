// Liz D. Wil - Final V2
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
		phonetic: "Chris Dee Wil",
		phone: null
	}
	;
	
	secondary: talker =
	{
		name: "Elize D. Wil",
		nick: "Lizzz",
		phonetic: "Lizzz Dee Wil",
		phone: null
	}
	;
	
	tertiary: talker =
	{
		name: null,
		nick: null,
		phonetic: null,
		phone:  null
	}
	;
	
	phonecall: interaction =
	{
		name: "initialize",
		agenda: "creating phone call object",
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
		set $primary.phone = $forward;
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

		if ($reason == "busy")
		{
			#sayText("Hey it's Lizzz again.");
			#sayText("it appears he's still busy, you'll have to try him again later.");
			#sayText(" ");
			#sayText("Good bye.");
			exit;
		}
		
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
			if ($phonecall.request == "farewell")
			{
				#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] is executing farewell");
				goto selfReturn;
			}

/*			
            if ($phonecall.request == "call")
            {
                #log("[" + $logNodeName + "] - [" + logNodeNameSub + "] is executing transfer");
                var transferMain = 
                {
                    name: "call",
                    agenda: "calling call to host",
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

                set $phonecall = blockcall transfer(transferMain);
                
                #log("[" + $logNodeName + "] - [" + logNodeNameSub + "] calling to" + $forward);
                #forward($forward);
            }

			if ($phonecall.request == "message")
			{
				#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] is executing message");
				var messageMain = 
				{
					name: "message",
					agenda: "sending message to host",
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

				set $phonecall = blockcall message(messageMain);

				#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] sending message to" + $forward);
			}
*/
		}
	goto selfRepeat;
	}
	
	transitions
	{
		selfRepeat: goto handler;
		selfReturn: goto @exit;
		idle: goto handler on timeout 1000;
		handler: goto handler on true priority 1;
	}
}