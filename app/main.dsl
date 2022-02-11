// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
	
	// will use various moods like sentiment pos/neg, confused later
	callerMood: string = "positive";
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
		var attemptTimeOut: number = 1500;
		
		#log(logNodeName + " --- " + #stringify(attemptCur) + " Attempt(s)");

		if (attemptCur < 2)
		{
			#say("assistGreetAttempt");
		}

		if ((attemptCur < attemptMax) && (!#waitForSpeech(attemptTimeOut)))
		{
			#say("assistGreetExplain");
			#say("assistGreetRepeat");
		}
		
		wait *;
	}
	
	transitions
	{
		idleGreetAttempt: goto assistGreetAttempt on timeout 5000;
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