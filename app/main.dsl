// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
	
	repeatQuestionTimeout: number = 5000;
}

start node assist {
	do
	{		
		#connectSafe($phone);
		wait *;
	}
	transitions
	{
		assistGreet: goto assistGreet on timeout 300;
	}
}

node assistGreet {
	do
	{
		#say("assistGreet");
		wait *;
	}
	transitions
	{
		repeatGreet: goto assistGreet on timeout $repeatQuestionTimeout;
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