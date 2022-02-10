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
		goto helloStart;
	}
}

digression helloStart {
	conditions { on false; }

	var fullGreeting = true;
	
	do {
		#log("-- node helloStart -- initializing helloStart");
		
		if(#getVisitCount("helloStart") < 2) 
		{
		}

		if()
		{
			#log("-- node helloStart -- introduction to caller");

			#waitForSpeech(500);
			#say("helloStart");
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
	}
        
    transitions
    {
    		confusedSentiment: goto helloStart on timeout 5000;

    		positiveSentiment: goto helpStart on #messageHasSentiment("positive");
            negativeSentiment: goto helpStart on #messageHasSentiment("negative");

            helloStartHangUp: goto helpStart on timeout 500;
            //self: goto helloStart on true priority -1000 tags: ontick;
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
}		

node transferStart {
	do
	{
		#log("-- node helpStart -- initializing helpStart");
		
		exit;
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

