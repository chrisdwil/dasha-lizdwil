// Liz D. Wil
import "lizdwilReactions/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
}

start node helloRoot {
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
		
/*


		{
		}

		if(digression.helloStart.fullGreeting)
		{
			#log("-- node helloStart -- introduction to caller");

			#waitForSpeech(500);
		}
		else
		{
			#log("-- node helloStart -- introduction rephrased to caller");
		
			#say("helloRepeat");
		}

        if (#getVisitCount("helloStart") < 3 && !#waitForSpeech(300))
        {
                #log("-- node helloStart -- waiting for speech");
                wait
                {
                positiveSentiment
                negativeSentiment
                confusedSentiment
                };
        }
        else
        {
        	wait
        	{
        		helloStartHangUp
        	};
        }
        */
	}
        
    transitions
    {
    		/*
    		 

    		positiveSentiment: goto helpStart on #messageHasSentiment("positive");
            negativeSentiment: goto helpStart on #messageHasSentiment("negative");

            helloStartHangUp: goto helpStart on timeout 500;
    }  
    
    onexit
    {
    	positiveSentiment: do
    	{
    		set $currentSentiment = "positive";
    		set $introductionSay = true;
    	}
    	
    	negativeSentiment: do
    	{
    		set $currentSentiment = "negative";
    		set $introductionSay = true;

    	}
    	
    	confusedSentiment: do
    	{
    		set $currentSentiment = "confused";
    	}
    }
    */
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

