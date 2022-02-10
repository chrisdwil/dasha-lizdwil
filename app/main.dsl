// Liz D. Wil
context {
	input phone: string;
	input forward: string? = null;
	
	introductionSay: boolean = true;
	
	callTimeout: number = 5000;
}

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
		positive: goto @hangUpTimeout on #messageHasSentiment("positive");
		negative: goto @hangUpTimeout on #messageHasSentiment("negative");
		@hangUpTimeout: goto @hangUpTimeout on timeout 5000;
	}
}

// call wrapup
node @hangUpTimeout
{
	do 
	{
        #log("-- node @exit -- ending conversation");

        #say("hangUpTimeout");
        exit;
	}
}

node hangUpFast
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

