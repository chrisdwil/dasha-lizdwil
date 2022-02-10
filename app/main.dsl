
context {
	input phone: string;
	input forward: string? = null;
	
	introductionSay: boolean = true;
	
	callTimeout: number = 5000;
}
// core complex conversations
start node mainIntroduction {
	do {
		#log("-- node mainIntroduction -- Introduction to caller");
		
		if(#getVisitCount("mainIntroduction") < 2) 
		{
			#connectSafe($phone);
		}

		if($introductionSay)
		{
			#say("mainIntroduction");
			set $introductionSay=false;
		}
				
		wait
		{
			positive
			negative
		};
	}
	
	transitions 
	{
		positive: goto callerTimeout on #messageHasSentiment("positive");
		negative: goto callerTimeout on #messageHasSentiment("negative");
		@callerTimeout: goto @callerTimeout on timeout 5000;
	}
}

/*
node @repeatTimeout
{
	do
	{
		#repeat();
		wait *;
	}

	transition
	{
		positive
	}
}

node offerAssistance 
{
	do 
	{
		#log("-- node offerAssistance -- offering assistance to caller");
		#log("prevTransitionCount: $prevTransitionCount");
		#log("feelingResponse:" + $feelingResponse);
		exit;
	
		if($feelingResponse == "positive") 
		{
			#say("howAreYouPositive");
		}
		
		if($feelingResponse == "negative") 
		{
			#say("howAreYouNegative");
		}
		
		if(!#waitForSpeech(1000))
		{
			wait 
			{ 
				restartSelf
			};
		}
		
		#say("offerAssistance");
		wait *;
	}
	
	transition {
		restartSelf: goto offerAssistance on timeout 1500;
		restartMainIntroduction: goto mainIntroduction on timeout 1500;
	}
}

node mainIntroductionConfused
{	
	do
	{
		#sayText("Oh, hey,,, I was just interested in how your day is...");
		#sayText("However do you need help with being transferred to Chris???");
		
		if(!#waitForSpeech(1000))
		{
			wait 
			{ 
				restartself
			};
		}
		
		goto mainIntroduction;
	}
	
	transition {
		restartself: goto mainIntroductionConfused on timeout 1500;
		restartMainIntroduction: goto mainIntroduction on timeout 1500;
	}
}

node respondToAssistance 
{
	do {
		#log("-- node respondToAssistance -- Introduction to caller");
	}
	
	transitions 
	{
	}
	
	onexit 
	{
	}
}
*/

// call wrapup
node @callerTimeout 
{
	do 
	{
        #log("-- node @exit -- ending conversation");

        #say("callerTimeout");
        exit;
	}
}

node fastHangUp
{
	do
	{
		#sayText("Goodbye");
		exit;
	}
}

node @exit 
{
    do 
    {
        #log("-- node @exit -- ending conversation");
        
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

