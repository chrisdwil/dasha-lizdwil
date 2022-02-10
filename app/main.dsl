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

            if (#getVisitCount("lizDWilRoot") > 1)
            {
            	#say("helloRepeat");
            }
			
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
		positiveSentiment: goto helloRespond on #messageHasSentiment("positive");
		negativeSentiment: goto helloRespond on #messageHasSentiment("negative");
		confusedSentiment: goto lizDWilRoot on timeout 5000;
		
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
        if ($getVisitCount("helloRespond") == 1)
		{
    		set $currentSentiment = "";
		}
        
        if (#getVisitCount("helloRespond") < 4)
        {
			#log("-- node helloRespond -- introduction to caller");

			#waitForSpeech(500);
			set $introductionSay=false;

			if ($currentSentiment == "positive")
			{
				#say("helpOfferPositive");
			}
			else if ($currentSentiment == "negative")
			{
				#say("helpOfferPositive");
			} 
			else
			{
				#say("helpOfferConfused");
			}
			
			#say("helpOfferStart");
		}
		else
		{
			#log("-- node helloRespond -- introduction rephrased to caller");
	
			#sayText("So how may I be of asstance today?");
		}
        exit;
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

