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
		confusedSentiment: goto hellpStart on timeout 5000;

		positiveSentiment: goto helpStart;
		negativeSentiment: goto helpStart:
		
		helpStartTimeout: goto @exit on timeout 500;
        self: goto helpStart on true priority -1000 tags: ontick;
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