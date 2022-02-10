
context {
	input phone: string;
	input forward: string? = null;
	
	introductionSay: boolean = true;
	introductionCount: number = 0; 

	feelingResponse: string = "";
	intentConfused: boolean = false;
}
// core complex conversations
start node mainIntroduction {
	do {
		set $introductionCount = #getVisitCount("mainIntroduction");
		set $feelingResponse = "";
		set $intentConfused = false;

		#log("-- node mainIntroduction -- Introduction to caller");
		#log("introductionCount: $introductionCount");
		#log("feelingResponse: $feelingResponse");
		
		if(#getVisitCount("mainIntroduction") < 2) 
		{
			#connectSafe($phone);
		}

		if($introductionSay)
		{
			#say("mainIntroduction");
			set $introductionSay=false;
		}
		
		if(#getVisitCount("mainIntroduction") > 5) 
		{		
			goto callerTimeout;
		}
	
		if(!#waitForSpeech(1000))
		{
			wait 
			{ 
				restartSelf
			};
		}
		
		exit;
	}
	
	transitions 
	{
		agree: goto offerAssistance on #messageHasSentiment("positive") priority 3;
		disagree: goto offerAssistance on #messageHasSentiment("negative") priority 3;
		
		callerTimeout: goto callerTimeout;
		restartSelf: goto mainIntroduction on timeout 1500;
	}
	
	onexit 
	{
		agree: do 
		{ 
			set $feelingResponse = "positive"; 
		}
		disagree: do 
		{ 
			set $feelingResponse = "negative"; 
		}
	}
}
node offerAssistance 
{
	do 
	{
		#log("-- node offerAssistance -- offering assistance to caller");

	}
}

/*
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
		wait {
			restartMainIntroduction
		};
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
node callerTimeout 
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
