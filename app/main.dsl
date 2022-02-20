// Liz D. Wil 
import "sidekicklibrary/all.dsl";

type human = 
{
		name: string;
		nick: string;
		phonetic: string;
		gender: string;
		mood: string; // positive, negative, idle, confusion
		request: string;
		responses: number;
		errors: number;
};

context {
	input phone: string;
	input forward: string;
	input sprint: boolean;
	input unavailable: boolean;

	host: human =
	{
				name: "Chris, D. Wheel",
				nick: "Chris",
				phonetic: "chris",
				gender: "male",
				mood: "positive",
				request: "none",
				responses: 0,
				errors: 0
	};
	sidekick: human =
	{
				name: "Liz, D. Wheel",
				nick: "Liz",
				phonetic: "Lizzz",
				gender: "female",
				mood: "positive",
				request: "none",
				responses: 0,
				errors: 0
	};
	guest: human =
	{
				name: "",
				nick: "",
				phonetic: "",
				gender: "",
				mood: "positive",
				request: "none",
				responses: 0,
				errors: 0
	};
	
	assistGreetFull: boolean = true;
	greetFirst: boolean = true;
}

start node assist {
	do
	{	
		#connectSafe($phone);

		if ($unavailable)
			{
			#say("assistUnavailable");
			exit;
			}
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
		
		set $guest = blockcall introduction($sidekick, $guest);
		
		if ($guest.request == "transfer")
		{
			#say("assistTransfer");
			#forward($forward);
			exit;
		}
	}
	
	transitions
	{
		greetAttemptIdle: goto assistGreetAttempt on timeout 10000;
	}
	
	onexit 
	{

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