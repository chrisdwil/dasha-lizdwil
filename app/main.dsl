// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
	
	currentSentiment: string = "positive";
}

start node assist {
	do
	{	
		#connectSafe($phone);
		wait *;
	}
	
	transitions
	{
		assistGreetAttempt: goto assistGreetAttempt on timeout 300;
	}
}

node assistGreetAttempt {
	do
	{
		var logNodeName: string = "assistGreetAttempt";
		var attemptCur: number = #getVisitCount(logNodeName);
		var attemptMax: number = 3;
		var attemptRepeat: boolean = false;
		var attemptTimeOut: number = 1500;
		
		#log(logNodeName + " --- " + #stringify(attemptCur) + " Attempt(s)");

		if (!attemptRepeat)
		{
			#say("assistGreetAttempt");
			set attemptRepeat = true;
		}
		
		if (!attemptTimeOut && (attemptRepeat == true))
		{
			#say("assistGreetRepeat",interruptible);
			wait *;
		}
	}
	
	transitions
	{
		repeatGreet: goto assistGreetAttempt on timeout 5000;
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