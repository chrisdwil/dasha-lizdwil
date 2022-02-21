// Liz D. Wil 
//import "sidekicklibrary/all.dsl";

type human = {
	role: string;
	name: string;
	nick: string;
	phonetic: string;
	gender: string;
	mood: string; // positive, negative, idle, confused
	request: string; // transfer, farewell
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

	attendees: human[] = 
		[{
		host: 
		[{ 	
			role: "host",
			name: "",
			nick: "",
			phonetic: "",
			gender: "",
			mood: "positive",
			request: "none"
		}]
		}];
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
		//idle: goto assistGreetAttempt on timeout 300;
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
/*
node assistGreetAttempt {
	do
	{
		var logNodeName: string = "assistGreetAttempt";
		
		set $attendees = blockcall introduction($attendees, $reason);
		#log($attendees);
		
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
*/
