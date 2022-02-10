// Liz D. Wil
context {
	input phone: string;
	input forward: string? = null;
	
	introductionSay: boolean = true;
	currentIntent: string = false;
	currentSentiment: string = false;
	
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
		positiveIntent: goto helpOffer on #messageHasSentiment("positive") priority 3;
		negativeIntent: goto helpOffer on #messageHasSentiment("negative") priority 3;
		positiveSentiment: goto helpOffer on #messageHasSentiment("positive")priority 1;
		negativeSentiment: goto helpOffer on #messageHasSentiment("negative")priority 1;
		helloStartTimeout: goto @helloRepeatTimeout on timeout 5000;
	}
	
	onexit
	{
		positiveIntent: do
		{
			set $currentIntent = true;
		}
				
		positiveSentiment: do
		{
			set $currentSentiment = true;
		}
	}
}

node @helloRepeatTimeout
{
	do 
	{
        #log("-- node @helloRepeatTimeout -- repeating once more");

        #say("helloRepeat");
        wait *;
	}
	
	transitions
	{
		helloRepeatTimeout: goto @exit on timeout 5000;
	}
}

node helpOffer
{
	do
	{
		#log("-- node helpOffer -- offering assistance")
		if ($currentIntent)
		{
			#sayText("That's wonderful");
			exit;
		} 
		else
		{
			#sayText("Aww I'm sorry to hear");
			exit;
		}

		if ($currentSentiment)
		{
			#sayText("Are you sure you're having an okay day?");
		}
		
		#sayText("So, what can I help you with?");
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

