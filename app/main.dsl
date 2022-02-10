// Liz D. Wil
//import "lizdwilReactions/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
	phoneConnect: boolean = false;
	currentSentiment: string = "";
}

start node lizDWilRoot {
	do
	{		
		#log("-- node lizDWilRoot -- initializing lizDWilRoot");

		if (!$phoneConnect) {
            #log("-- node lizDWilRoot -- connecting phone and doing primary greeting");

			#connectSafe($phone);
			set $phoneConnect = true;
			#say("helloStart");			
		}
		
		if (#getVisitCount("lizDWilRoot") < 4 && !#waitForSpeech(300))
        {
            #log("-- node lizDWilRoot -- repeating random greeting");

				#say("helloRepeat");
				
				#log("-- node lizDWilRoot -- waiting for speech");
                wait
                {
	                positiveSentiment
	                negativeSentiment
	                confusedSentiment
                };
        }
        else
        {
            #log("-- node lizDWilRoot -- caller has timed out, hanging up");

        	wait
        	{
        		lizDWilRootHangup
        	};
        }
	}
	
	transitions
	{
		confusedSentiment: goto lizDWilRoot on timeout 5000;
		
		positiveSentiment: goto helloRespond on #messageHasSentiment("positive");
		negativeSentiment: goto helloRespond on #messageHasSentiment("negative");
		
		lizDWilRootHangup: goto @exit on timeout 500;
	}
	
	onexit
	{
    	positiveSentiment: do
    	{
    		set $currentSentiment = "positive";
    	}
    	
    	negativeSentiment: do
    	{
    		set $currentSentiment = "negative";

    	}
    	
    	confusedSentiment: do
    	{
    		set $currentSentiment = "confused";
    	}
	}
}

node helloRespond {
	do
	{
        #log("-- node lizDWilRoot -- initializing helloRespond");
	
	}
}

/*
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
*/	

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

