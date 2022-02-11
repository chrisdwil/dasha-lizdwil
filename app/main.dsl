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
		var assistGreetAttemptCur: number = 0;
		var assistGreetAttemptMax: number = 3;
		var assistGreetAttemptRepeat: boolean = false;
		
		set assistGreetAttemptCur += 1;

		if (!assistGreetRepeat)
		{
			#say("assistGreetAttempt");
			set assistGreetRepeat = true;
		}
		else if (assistGreetAttemptCur > assistGreetAttemptMax)
		{
			#sayText("Good bye");
			exit;
		}
		else
		{
			#say("assistGreetRepeat");
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