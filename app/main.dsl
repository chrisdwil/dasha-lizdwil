// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
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
	{
		repeatGreet: goto assistGreet on timeout 5000;
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
s