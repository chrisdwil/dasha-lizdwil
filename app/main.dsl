// Liz D. Wil
context {
	input phone: string;
	input forward: string? = null;
	
	introductionSay: boolean = true;
	currentSentiment: string = "";
	
	callTimeout: number = 5000;
}

start node helloStart {
	do {
		#log("-- node helloStart -- introduction to caller");
		
		if(#getVisitCount("helloStart") < 2) 
		{
			#connectSafe($phone);
		}

		if($introductionSay)
		{
			#say("helloStart");
			set $introductionSay=false;
		}
				
		wait *;
	}
	
	transitions 
	{
		positive: goto offerAssistance on #messageHasSentiment("positive");
		negative: goto offerAssistance on #messageHasSentiment("negative");
		helloStartTimeout: goto @helloRepeatTimeout on timeout 5000;
	}
	
	onexit
	{
		positive: do
		{
			set $currentSentiment = "positive";
		}
		
		negative: do
		{
			set $currentSentiment = "negative";
		}
		
		helloStartTimeout: do
		{
			set $currentSentiment = "confused";
		}
	}
}

node @helloRepeatTimeout
{
	do 
	{
        #log("-- node @questionTimeout -- repeating once more");

        #say("helloRepeat");
        wait *;
	}
	
	transitions
	{
		helloRepeatTimeout: goto @exit on timeout 5000;
	}
}

node helpOfferPositive
{
	do
	{
		#sayText("That's wonderful");
		exit;
	}
}

node helpOfferNegative
{
	do
	{
		#sayText("Aww I'm sorry to hear");
		exit;
	}
}

node @exit 
{
    do 
    {
        #log("-- node @exit -- ending conversation");
        
        say("hangUpRandom");
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

