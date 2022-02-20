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
		responses: number;
		errors: number;
		errorsMax: number; // can change this value prior to going into a library call and set threshold on dasha's or guests max errors
}

context {
	input phone: string;
	input forward: string;
	input reason: string;

	people: human[]?;
	
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
				errorsMax: 4
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
				errorsMax: 4

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
				errors: 0,
				errorsMax: 4
	};
	
	assistGreetFull: boolean = true;
	greetFirst: boolean = true;
}

start node assist {
	do
	{	
		#log("call information: " + $phone + " " + $forward + " " + $reason);
		#connectSafe($phone);
		
		people["guest"] = {
				
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
		
		set $guest = blockcall introduction($sidekick, $guest, $reason);
		#log($guest);
		
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