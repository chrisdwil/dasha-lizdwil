// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
	
	assistGreetAttemptCur: number = 0;
	assistGreetAttemptMax: number = 3;
	assistGreetAttemptRepeat: string = false;
	
	currentSentiment = "positive";
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
		set assistGreetAttemptCur+=1;

		if (!$assistGreetRepeat)
		{
			#say("assistGreetAttempt");
			set assistGreetRepeat = true;
		}
		else 
		{
			#say("assistGreetRepeat");
		}
		else if (assistGreetAttemptCur > assistGreetAttemptMax) 
		{
			#sayText("Good bye");
			exit;
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