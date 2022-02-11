// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
	
	assistGreetRetries = 0;
	assistGreetAttemptsMax = 3;
	assistGreetRepeat = false;
	
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
		assistGreetAttempts+=1;

		if ($assistGreetAttempts == 1)
		{
			#say("assistGreetAttempt");
		}
		else 
		{
			#say("assistGreetRepeat");
		}
		else if (assistGreetAttempts > 3) 
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