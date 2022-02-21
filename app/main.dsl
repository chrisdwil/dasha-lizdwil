// Liz D. Wil 
import "sidekicklibrary/all.dsl";

/*
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
*/

context {
	input phone: string;
	input forward: string;
	input reason: string;
}

start node assist 
{
	do
	{	
		#connectSafe($phone);
		
		wait *;
	}
	
	transitions
	{
		idle: goto assistHandler on timeout 300;
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
		#log("repeat");
		
		wait *;
	}
	
	transitions 
	{
		idle: goto assistHandler on timeout 1000;
	}
}
