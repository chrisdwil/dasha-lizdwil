
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
		positive: goto @callerTimeout on #messageHasSentiment("positive");
		negative: goto @callerTimeout on #messageHasSentiment("negative");
		@callerTimeout: goto @callerTimeout on timeout 5000;
	}
}

// call wrapup
node @timeout
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

