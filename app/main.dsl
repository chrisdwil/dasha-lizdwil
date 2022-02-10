// Liz D. Wil
// import "lizdwilReactions/all.dsl";

context {
	input phone: string;
	input forward: string? = null;
	
	introductionSay: boolean = true;
	currentSentiment: string = "";
	
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
    		set $currentConfusion = "confused";
    		set $introductionSay = true;
    	}
    }
}		

node helpStart
{
	do
	{
		#log("-- node helpStart -- initializing helpStart");
				
		if($introductionSay)
		{
			#log("-- node helpStart -- introduction to caller");

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
		
			set $introductionSay=false;
		}
		else
		{
			#log("-- node helloStart -- introduction rephrased to caller");

			#sayText("So how may I be of asstance today?");
		}
		
        if (#getVisitCount("helpStart") < 3 && !#waitForSpeech(300))
        {
                #log("-- node helpStart -- waiting for speech");
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
        		helpStartHangUp
        	};
        }
    }
	
	transitions
	{
		confusedSentiment: goto transferStart on timeout 5000;

		positiveSentiment: goto transferStart on #messageHasSentiment("positive");
        negativeSentiment: goto transferStart on #messageHasSentiment("negative");
		
		helpStartTimeout: goto @exit on timeout 500;
        //self: goto helpStart on true priority -1000 tags: ontick;
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
    		set $currentConfusion = "confused";
    		set $introductionSay = true;
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

