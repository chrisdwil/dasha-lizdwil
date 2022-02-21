// Liz D. Wil 
import "sidekicklibrary/all.dsl";

type human = {
	name: string;
};

type people = {
	hosts: human[];
	guests: human[];
};

context {
	input phone: string;
	input forward: string;
	input reason: string;
	attendees: people = {
			hosts: [{ name: "Chris D. Wil" }, { name: "Liz D. Wil" }],
			guests: [{ name: "" }]
	};
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

