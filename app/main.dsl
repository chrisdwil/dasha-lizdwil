// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string = "sip:+12817829187@lizdwil.pstn.twilio.com;transport=udp";
	
	// will use various moods like sentiment pos/neg, confusion, ending 
	callMood: string = "positive";
}

start node assist {
	do
	{	
		#connectSafe($phone);
		wait *;
	}
	
	transitions
	{
		assistGreetAttempt: goto assistGreetAttempt on timeout 300;
	}
}

node assistGreetAttempt {
	do
	{
		var logNodeName: string = "assistGreetAttempt";
		var attemptCur: number = #getVisitCount(logNodeName);
		var attemptMax: number = 3;
		var attemptTimeOut: number = 500;
		
		#log(logNodeName + " --- " + #stringify(attemptCur) + " Attempt(s)");

		if (attemptCur < 2)
		{
			#say("assistGreetAttempt", interruptible: true, options: { emotion: "from text: i love you" });
		}
		else 
		{	
			if ((attemptCur < attemptMax) && ($callMood == "positive"))
			{
				#say("assistGreetRepeat", interruptible: true);
			}
			
			if (attemptCur == attemptMax)
			{
				#say("assistGreetExplain", options: { emotion: "positive", speed: 0.7 });
				set $callMood = "confusion";
			}
	
			if ((attemptCur > attemptMax) && ($callMood == "confusion"))
			{
				#say("assistGreetHangUpPrep", interruptible: true, options: { emotion: "negative", speed: 0.9 });
				wait {
					assistMessageForward
					assistHangUp
				};
				
				exit;
			}
		}

		wait *;
	}
	
	transitions
	{
		assistHangUp: goto @exit on #messageHasIntent("bye");
		assistMessageForward: goto @exit on timeout 30000;
		idleGreetAttempt: goto assistGreetAttempt on timeout 7500;
	}
}

node @exit 
{
    do 
    {
        #say("assistHangUp");
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