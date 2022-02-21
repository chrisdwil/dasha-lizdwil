// Liz D. Wil 
import "sidekicklibrary/all.dsl";


type discussion = {
		agenda: string;
		request: string; // examples: transfer, message, farewell, unknown
		behavior: string; // examples: positive, negative, idle, confused
		journal: string[];
};

type person = {
		name: string;
		nick: string;
		discussions: discussion[];
};

type people = {
		primary: person;
		sidekick: person;
		incoming: person;
};


context {
	input phone: string;
	input forward: string;
	input reason: string;
	
	logNodeName: string = "[main]";
	
	attendees: people = {
			primary: {
				name: "Chris D. Wil",
				nick: "Chris",
				discussions: [
				              {agenda: "", request: "", behavior: "", journal: []}
				]
			},
			sidekick: {
				name: "Liz D. Wil",
				nick: "Lizzz",
				discussions: [
				              {agenda: "", request: "", behavior: "", journal: []}
				]
			},
			incoming: {
				name: "",
				nick: "",
				discussions: [
				              {agenda: "", request: "", behavior: "", journal: []}
				]
			}
	};
}

start node assist 
{
	do
	{	
		var logNodeNameSub = "@";
        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
		#connect($phone);
		
		wait *;
	}
	
	transitions
	{
		idle: goto assistHandler on timeout 100;
	}
}

node @exit 
{
    do 
    {
		var logNodeNameSub = "@exit";
        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
    	#log($attendees["primary"]);
    	#log($attendees["sidekick"]);
    	#log($attendees["guest"]);
    	
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
			var logNodeNameSub = "@exit";
	        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
	    	#log($attendees["primary"]);
	    	#log($attendees["sidekick"]);
	    	#log($attendees["guest"]);
	    	
	    	exit;
		}
}

node assistHandler
{
	do
	{
		var conversation: discussion = {
				agenda: "hello",
				request: "", 
				behavior: "",
				journal: []
		};
		var logNodeNameSub = "@exit";
        #log($logNodeName + " - [" + logNodeNameSub + "] has been executed");
    	#log($attendees["primary"]);
    	#log($attendees["sidekick"]);
    	#log($attendees["guest"]);
		
		$attendees["incoming"]["discussions"]?.push(blockcall hello($attendees, conversation));
		
		wait *;
	}
	
	transitions 
	{
		idle: goto assistHandler on timeout 1000;
	}
}
