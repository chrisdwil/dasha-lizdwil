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
		var AttemptCur: number = 0;
		var AttemptMax: number = 3;
		var AttemptRepeat: boolean = false;
		#log(logNodeName + " --- " + AttemptCur?.string + " Attempt(s)");
		
		set AttemptCur += 1;

		if (AttemptCur > 0)
		{
			if (!AttemptRepeat)
			{
				#say("assistGreetAttempt");
				set AttemptRepeat = true;
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