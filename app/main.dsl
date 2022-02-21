// Liz D. Wil 
import "sidekicklibrary/all.dsl";

type recognitions = {
	statement: string[];
    request: string[];
    question: string[];
    other: string[];
};

type human = {
	name: string;
	nick: string;
	said: recognitions; 
};

type people = {
	host: human;
	sidekick: human;
	guest: human;
};

context {
	input phone: string;
	input forward: string;
	input reason: string;

	attendees: people = 
	{
		host: { 
			name: "Chris D. Wil", 
			nick: "Chris'sz", 
			said: 
			{
				statement: [],
				request: [],
				question: [],
				other: []
			}
		},
		sidekick: 
		{ 
			name: "Liz D. Wil", 
			nick: "Lizzz", 
			said: 
			{
				statement: [],
				request: [],
				question: [],
				other: []
			}
		},
		guest: 
		{ 
			name: "", 
			nick: "", 
			said: 
			{
				statement: [],
				request: [],
				question: [],
				other: []
			}
		}
	}	
}

start node assist {
	do
	{	
		#log("call information: " + $phone + " " + $forward + " " + $reason + "with following attendees: ");
		#connectSafe($phone);

		wait *;
	}

	transitions
	{
		idle: goto assistGreetAttempt on timeout 300;
	}
}

node @exit 
{
    do 
    {
        exit;
    }

}

digression @exit_dig
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

node assistGreetAttempt {
	do
	{
		var logNodeName: string = "assistGreetAttempt";
		
		set $attendees = blockcall introduction($attendees, $reason);
		
		if ($reason != "busy")
		{	
				#forward($forward);
				exit;
		}
	}
	
	transitions
	{
		greetAttemptIdle: goto assistGreetAttempt on timeout 10000;
	}
}

