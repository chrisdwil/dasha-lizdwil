// Liz D. Wil 
import "sidekicklibrary/all.dsl";

type human = {
	role: string;
	name: string;
	nick: string;
	phonetic: string;
	gender: string;
	mood: string; // positive, negative, idle, confused
	request: string; // transfer, farewell
};

context {
	input phone: string;
	input forward: string;
	input reason: string;
	
	attendees: human[] = 
	[
		{	
			role: "host",
			name: "",
			nick: "",
			phonetic: "",
			gender: "",
			mood: "",
			request: ""
		},
		{	
			role: "sidekick",
			name: "Liz, D. Wheel",
			nick: "Liz",
			phonetic: "Lizzz",
			gender: "female",
			mood: "",
			request: ""
		},
		{	
			role: "guest",
			name: "",
			nick: "",
			phonetic: "",
			gender: "",
			mood: "",
			request: ""
		}
	];
}

start node assist {
	do
	{	
		#log("call information: " + $phone + " " + $forward + " " + $reason);
		#connectSafe($phone);

		#log($attendees);
		exit;
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
		
		set $attendees[2] = blockcall introduction($attendees, $reason);
		
		if ($reason != "busy")
		{	
				#forward($forward);
				exit;
			}
			else
			{
				exit;
			}
		}
	}
	
	transitions
	{
		greetAttemptIdle: goto assistGreetAttempt on timeout 10000;
	}
}
