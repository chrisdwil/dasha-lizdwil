// Liz D. Wil
import "lizdwilReactions/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
	phoneConnect: boolean = false;
}

start node lizDWilRoot {
	do
	{
		if (!$phoneConnect) {
			#connectSafe($phone);
			set $phoneConnect = true;
			
		}
		
		#waitForSpeech(300);
		#say("helloStart");
		wait {
			helloStart
		};
	}
	
	transitions
	{
		helloStart: goto self on timeout 5000;
	}
}

node helloRepeat {
	do
	{
		
	}
	
	transitions
	{
		
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

