// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string = "sip:+12817829187@lizdwil.pstn.twilio.com;transport=udp";
	input sprint: boolean;
	
	// will use various moods like sentiment pos/neg, confusion, ending call
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
			wait {
				idleGreetAttempt
			};
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
			}

			if (attemptCur > max)
			{
				#sayText("Are you sure you want to continue this call?");
				wait
				{
					assistGreetHangUp
					idleHangUp
				};
			}

			/*
			if ($callMood == "confusion")
			{
				#say("assistGreetHangUpPrep");
				wait 
				{
					callHangUp
					idleHangUp
				};
			}
			*/
		}

		wait 
		{
			idleGreetAttempt
		};
	}
	
	transitions
	{
		assistGreetHangup: goto assistGreetAttempt on #messageHasSentiment("positve");
		callHangUp: goto @exit on #messageHasIntent("bye");
		idleHangUp: goto @exit on timeout 1000;
		idleGreetAttempt: goto assistGreetAttempt on timeout 8500;
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