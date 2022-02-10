// Liz D. Wil
context {
	input phone: string;
	input forward: string? = null;
	
	introductionSay: boolean = true;
	
	callTimeout: number = 5000;
}

start node helloStart {
	do {
		#log("-- node helloStart -- Introduction to caller");
		
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
		questionTimeout: goto @questionTimeout on timeout 5000;
	}
}

node @helloStartTimeout
{
	do 
	{
        #log("-- node @questionTimeout -- repeating once more");

        #say("hellRepeat");
        wait *;
	}
	
	transitions
	{
		questionTimeout: goto @exit on timeout 5000;
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

