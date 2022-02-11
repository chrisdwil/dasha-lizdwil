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
		var assistGreetAttemptCur: number = 0;
		var assistGreetAttemptMax: number = 3;
		var assistGreetAttemptRepeat: boolean = false;
		#log(logNodeName + "---"+ "initializing");
		
		set assistGreetAttemptCur += 1;

		if (assistGreetAttemptCur > 0)
		{
			if (!assistGreetAttemptRepeat)
			{
				#say("assistGreetAttempt");
				set assistGreetAttemptRepeat = true;
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