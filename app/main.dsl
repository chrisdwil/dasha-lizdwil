// Liz D. Wil
context {
	input phone: string;
	input forward: string? = null;
	
	introductionSay: boolean = true;
	currentIntent: boolean = false;
	currentSentiment: boolean = false;
	
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
		else
		{
			#say("Just checking again, how are you today?");
		}

		wait *;
	}
	
	transitions 
	{
		positiveIntent: goto helloRepeatTimeout on #messageHasIntent("positive");
		negativeIntent: goto helloRepeatTimeout on #messageHasIntent("negative");
		helloStartTimeout: goto helloStart on timeout 5000;
	}
	
	onexit
	{
		positiveIntent: do
		{
			set $currentIntent = true;
		}
		
		negativeIntent: do
		{
			set $currentIntent = false;
		}
	}
}

node @helloRepeatTimeout
{
	do 
	{
        #log("-- node @helloRepeatTimeout -- repeating once more");
        #repeat();

        #say("helloRepeat");
        wait *;
	}
	
	transitions 
	{
		positiveIntent: goto helloRepeatTimeout on #messageHasIntent("positive") priority 3;
		negativeIntent: goto helloRepeatTimeout on #messageHasIntent("negative") priority 3;
		//helloStartTimeout: goto @helloRepeatTimeout on timeout 5000;
	}
	
	onexit
	{
		positiveIntent: do
		{
			set $currentIntent = true;
		}
		
		negativeIntent: do
		{
			set $currentIntent = false;
		}
	}
}

node helpOffer
{
	do
	{
		#log("-- node helpOffer -- offering assistance");
		if ($currentIntent)
		{
			#log("-- node helpOffer -- helpOffer positiveIntent match");
			#sayText("That's wonderful");
		} 
		else
		{
			#log("-- node helpOffer -- helpOffer negativeIntent match");
			#sayText("Aww I'm sorry to hear");
		}

		if (!$currentSentiment)
		{
			#log("-- node helpOffer -- helpOffer caller sentiment negative");
			#sayText("Are you sure you're having an okay day?");
		}
		else
		{
			#log("-- node helpOffer -- helpOffer caller sentiment maybe positive");
			#sayText ("Oh, apologize about the confusion.");
		}
		
		#sayText("So, what can I help you with?");
		wait *;
	}
	
	transitions
	{
		helpOfferTimeout: goto helpOffer on timeout 5000;
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

