// Liz D. Wil 
import "sidekicklibrary/all.dsl";

context {
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
        
        var phonecallResult: interaction[] = [
                                              {
        	
        
        		name: "hello",
        		agenda: "confirm caller is present",
        		request: null,
        		behavior: null,
        		phrase: null,
        		host: $primary,
        		sidekick: $secondary,
        		guest: $tertiary,
        		journal: [{
        			text: null
        		}],
        		results: [{
        			name: null,
        			data: null
        		}]
                                              }
                                              ];
        
        set phonecallResult = blockcall hello(phonecallResult);
        
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
