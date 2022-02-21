// Liz D. Wil 
import "sidekicklibrary/all.dsl";


type discussion = {
		agenda: string;
		request: string; // examples: transfer, message, farewell, unknown
		behavior: string; // examples: positive, neutral, negative, idle, confused
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

start node main 
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
		idle: goto handler on timeout 100;
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
    	#log($attendees["incoming"]);
    	
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
	    	#log($attendees["incoming"]);
	    	
	    	exit;
		}
}

node handler
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
    	#log($attendees["incoming"]);
		
		set conversation = blockcall hello($attendees, conversation);
		#log(conversation);
		
		if ($reason != "busy")
		{
			#forward($forward);
			//exit; for later
		}
		
		exit;
	}
	
	transitions 
	{
		idle: goto handler on timeout 10000;
	}
}
