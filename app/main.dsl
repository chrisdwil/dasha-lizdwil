// Liz D. Wil
import "sidekicklibrary/all.dsl";

type human = 
{
		name: string;
		nick: string;
		phonetic: string;
		gender: string;
		mood: string;
		request: string;
		responses: number;
		errors: number;
};

context {
	input phone: string;
	input forward: string = "sip:+12817829187@lizdwil.pstn.twilio.com;transport=udp";
	input sprint: boolean;

	host: human =
	{
				name: "Chris, D. Wheel",
				nick: "Chris",
				phonetic: "chris",
				gender: "male",
				mood: "positive",
				request: "",
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
				request: "",
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
				request: "",
				responses: 0,
				errors: 0
	};
	
	callMood: string = "positive";
	callStepsCur: number = 1;
	callStepsRisk: number = 5;
	callStepsIdle: number = 0;
	callRescued: boolean = false;
	assistGreetFull: boolean = true;
	greetFirst: boolean = true;
}

start node assist {
	do
	{	
		#connectSafe($phone);
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
		
		set $guest = blockcall introduction($sidekick, $guest, true);
		#log("introduction: guest's mood was " + $guest.mood);		
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
		var logNodeName: string = "exit";
		
		#log(logNodeName + " mood " + $callMood + " mood");
		#log(logNodeName + " steps " + #stringify($callStepsCur) + " Attempt(s)");
		#log(logNodeName + " idle " + #stringify($callStepsIdle) + " Attempt(s)");
		
		if ($callMood == "negative")
		{
			#log(logNodeName + " call was not rescued");
		}
		
		#say("assistHangUp");
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