// Liz D. Wil 
import "sidekicklibrary/_types.dsl";

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
	
	phonecall: interaction[] = 
	[
	 	{
			name: "initialize",
			agenda: "creating phone call array",
			request: null,
			behavior: null,
			phrase: null,
			host: null,
			sidekick: null,
			guest: null,
			journal: null,
			results: null
	 	}
	];			
}

start node main
{
	do
	{	
		var logNodeNameSub = "@";
        #log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
        #log($phonecall);
		#connectSafe($phone);
		
		goto exitSelf;
	}
	
	transitions
	{
		idle: goto handler on timeout 100;
		exitSelf: goto @exit;
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
    
        exit;
	}
	
	transitions 
	{
		idle: goto handler on timeout 10000;
	}
}