// Liz D. Wil
context {
	input phone: string;
	input forward: string? = null;
	
	introductionSay: boolean = true;
	currentIntent: string = "";
	currentSentiment: string = "";
	currentConfusion: string = "";
	
	callTimeout: number = 5000;
}

start node helloStart {
	do {
		#log("-- node helloStart -- initializing helloStart");
		
		if(#getVisitCount("helloStart") < 2) 
		{
			#connectSafe($phone);
		}

		if($introductionSay)
		{
			#log("-- node helloStart -- introduction to caller");

			#waitForSpeech(500);
			#say("helloStart");
			set $introductionSay=false;
		}
		else
		{
			#log("-- node helloStart -- introduction rephrased to caller");
		
			#say("helloRepeat");
		}

        if (#getVisitCount("helloStart") < 4 && !#waitForSpeech(300))
        {
                #log("-- node helloStart -- waiting for speech");
                wait
                {
                positiveSentiment
                negativeSentiment
                helloStartTimeout
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
            positiveSentiment: goto helpOffer on #messageHasSentiment("positive");
            negativeSentiment: goto helpOffer on #messageHasSentiment("negative");
            helloStartTimeout: goto helloStart on timeout 5000;
            helloStartHangUp: goto helpOffer on timeout 500;
            self: goto helloStart on true priority -1000 tags: ontick;
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
    	
    	helloStartTimeout: do
    	{
    		set $currentConfusion = "confused";
    	}
    }
}		

node helpOffer
{
	do
	{
		#log("-- node helpOffer -- initializing helpOffer");
		
		if ($currentSentiment == "positive")
		{
			#sayText("That's wonderful, I'm doing great myself today.");
		}
		else if ($currentSentiment == "negative")
		{
			#sayText("Awwwww, well maybe Chris or I will be able to assist.");
		} 
		else
		{
			#sayText("I'm not sure I understand what you're communicating");
			#sayText("But hey I can transfer calls and leave messages for Chris");
		}
		
		#sayText("So how may I be of asstance today?");
		
		wait
		{
			helpOfferTimeout
		};
	}
	
	transitions
	{
		helpOfferTimeout: goto @exit on timeout 500;
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

