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

