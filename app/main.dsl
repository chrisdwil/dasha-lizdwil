
context {
	input phone: string;
	input forward: string? = null;
	
	sayIntroduction: boolean = true; 
	feelingResponse: string = "";
	intentConfused: boolean = false;
}
// core complex conversations
start node mainIntroduction {
	do {
		#log("-- node mainIntroduction -- Introduction to caller");
		set $feelingResponse = "";
		set $intentConfused = false;
		
		if(#getVisitCount("mainIntroduction") < 2) 
		{
			#connectSafe($phone);
		}

		if($sayIntroduction)
		{
			#say("mainIntroduction");
			set $sayIntroduction=false;
		}
		
		if(#getVisitCount("mainIntroduction") > 5) 
		{		
			goto callerTimeout;
		}
	
		if(!#waitForSpeech(1000))
		{
			wait 
			{ 
				restartself
			};
		}
		
		wait 
		{
			agree
			disagree
		};
	}
	
	transitions 
	{
		agree: goto offerAssistance on #messageHasSentiment("positive") priority 3;
		disagree: goto offerAssistance on #messageHasSentiment("negative") priority 3;
		
		confusedYes: goto mainIntroduction on #messageHasIntent("yes") priority 2;
		confusedNo: goto mainIntroduction on #messageHasIntent("no") priority 2;
		
		callerTimeout: goto callerTimeout;
		restartself: goto mainIntroduction on timeout 1500;
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
		confusedYes: do
		{
			set $intentConfused = true;
		}
		confusedNo: do
		{
			set $intentConfused = true;
		}
	}
}

node offerAssistance 
{
	do 
	{
		#log("-- node offerAssistance -- offering assistance to caller");
		
		if($feelingResponse == "positive") 
		{
			#say("howAreYouPositive");
		}
		
		if($feelingResponse == "negative") 
		{
			#say("howAreYouNegative");
		}
		
		#say("offerAssistance");
		goto mainIntroduction;
	}
	transition {
		restartself: goto offerAssistance on timeout 1500;
		restartMainIntroduction: goto mainIntroduction on timeout 1500;
	}
}

node mainIntroductionConfused
{	
	do
	{
		#sayText("Oh, hey,,, I was just interested in how your day is...");
		#sayText("However do you need help with being transferred to Chris???");
		goto mainIntroduction;
	}
	transition {
		restartself: goto mainIntroductionConfused on timeout 1500;
		restartMainIntroduction: goto mainIntroduction on timeout 1500;
	}
}

/*
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
