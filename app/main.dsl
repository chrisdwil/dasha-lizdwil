// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string = "sip:+12817829187@lizdwil.pstn.twilio.com;transport=udp";
	input sprint: boolean;
	
	// will use various moods like sentiment pos/neg, confusion, ending 
	callMood: string = "positive";
}

start node assist {
	do
	{	
		#connect($phone);
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
			wait *;
		}
		else
		{	
			if ((attemptCur <= attemptMax))
			{
				#say("assistGreetRepeat", interruptible: true);
			}
			else
			{
				#say("assistGreetExplain", options: { emotion: "positive", speed: 0.7 });
				set $callMood = "confusion";
			}
				
			if ((attemptCur > attemptMax) && ($callMood == "confusion"))
			{
				#say("assistGreetHangUpPrep");
				exit;
			}
		}

		wait *;
	}
	
	transitions
	{
		callHangUp: goto @exit on #messageHasIntent("bye");
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