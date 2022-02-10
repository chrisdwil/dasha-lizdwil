
context {
	input phone: string;
	input forward: string? = null;
	
	feelingResponse: string = "";
	intentConfused: boolean = null;
}
// core complex conversations
start node mainIntroduction {
	do {
		#log("-- node mainIntroduction -- Introduction to caller");
		$feelingResponse = "";
		intentConfused = null;
		
		if(#getVisitCount("mainIntroduction") < 2) 
		{
			#connectSafe($phone);
			#say("mainIntroduction");
		}
		
		if((#getVisitCount("mainIntroduction") >= 2) && ($intentConfused))
		{
			goto confusedDigression;
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
			confusedYes
			confusedNo
		};
	}
	
	transitions 
	{
		agree: goto offerAssistance on #messageHasSentiment("positive") priority 3;
		disagree: goto offerAssistance on #messageHasSentiment("negative") priority 3;
		
		confusedYes: goto mainIntroduction on #messageHasIntent("yes") priority 2;
		confusedNo: goto mainIntroduction on #messageHasIntent("no") priority 2;
		confusedDigression: goto mainIntroductionConfused;
		
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
		exit;
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

// digressions located here
digression demandTransfer 
{
	conditions 
	{
		on #messageHasIntent("transfer");
	}
	do 
	{
		#sayText("Okay let me check if he's available.");
		wait *;
	}
	
	transitions 
	{
		agree: goto mainIntroduction on #messageHasSentiment("positive");
		disagree: goto fastHangUp on #messageHasSentiment("positive");
	}
}

// create digression for wrong number scenarios

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

digression mainIntroductionConfused
{	
	conditions {
		on $intentConfused == true;
	}
	
	do
	{
		#sayText("Oh, hey,,, I was just interested in how your day is...");
		#sayText("However do you need help with being transferred to Chris???");
		return;
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
