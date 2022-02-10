// Liz D. Wil
import "lizdwilReactions/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
}

start node lizDWilRoot {
	do
	{
		#connectSafe($phone);
		#waitForSpeech(300);
		#say("helloStart");
		
		wait *;
	}
	
	transitions
	{
		helloStart: goto helloStart on timeout 5000;
	}
}

digression helloStart {
	conditions { on true; }

	var fullGreeting = true;
	var retriesLimit = 0;
	var retriesTimeout = 5000;
	var counter = 0;
	
	do {
		#log("-- node helloStart -- initializing helloStart");
		

	}
        
    transitions
    {
    }      
}		

node @exit 
{
    do 
    {
        #log("-- node @exit -- ending conversation");
        
        #say("hangUpRandom");
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

