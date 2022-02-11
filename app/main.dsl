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
		
		#log(logNodeName + " --- " + #stringify(attemptCur) + " Attempt(s)");

		if (attemptCur < 2)
		{
			#say("assistGreetAttempt",interruptible);
		}
		else  
		{
			#say("assistGreetRepeat",interruptible);
		}
			
		wait *;
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