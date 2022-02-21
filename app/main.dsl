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
		
		set conversation = blockcall hello($attendees, conversation);
		#log("handler");
		
		wait *;
	}
	
	transitions 
	{
		idle: goto assistHandler on timeout 1000;
	}
}
