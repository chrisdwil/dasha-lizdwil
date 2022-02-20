// Liz D. Wil 
import "sidekicklibrary/all.dsl";

type human = 
{
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
	
	people: human[] = 
		{
		"host": 
		{
				name: "Liz, D. Wheel",
				nick: "Liz",
				phonetic: "Lizzz",
				gender: "female",
				mood: "",
				request: ""
		}
		};
			
	
/*
	{
				name: "Chris, D. Wheel",
				nick: "Chris",
				phonetic: "chris",
				gender: "male"	
	};
	sidekick: human =
	{
				name: "Liz, D. Wheel",
				nick: "Liz",
				phonetic: "Lizzz",
				gender: "female"
	};
	guest: human =
	{
				name: "",
				nick: "",
				phonetic: "",
				gender: ""
	};
*/
}

start node assist {
	do
	{	
		#log("call information: " + $phone + " " + $forward + " " + $reason);
		#connectSafe($phone);

		#log($people["host"]);
		wait *;
	}

	transitions
	{
		idle: goto assistGreetAttempt on timeout 300;
	}
}

node assistGreetAttempt {
	do
	{
		var logNodeName: string = "assistGreetAttempt";
		
		set $guest = blockcall introduction($sidekick, $guest, $reason);
		
		if ($reason != "busy")
		{	
			if ($guest.request == "transfer")
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