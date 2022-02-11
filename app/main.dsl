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
		if (#getVisitCount(logNodeName) <= 1)
		{
			var attemptCur: number = 0;
			var attemptMax: number = 3;
			var attemptRepeat: boolean = false;
		}
		
		set attemptCur += 1;
		#log(logNodeName + " --- " + #stringify(attemptCur) + " Attempt(s)");

		if (attemptCur >= 1)
		{
			if (!attemptRepeat)
			{
				#say("assistGreetAttempt");
				set attemptRepeat = true;
			}
			else
			{
				#say("assistGreetRepeat");
			}
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