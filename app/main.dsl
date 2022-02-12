// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string = "sip:+12817829187@lizdwil.pstn.twilio.com;transport=udp";
	input sprint: boolean;
	
	callMood: string = "positive";
	callStepsCur: number = 1;
	callStepsRisk: number = 5;
	callStepsIdle: number = 0;
	callRescued: false;
	assistGreetFull: boolean = true;
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
		
		#log(logNodeName + " mood " + $callMood + " mood);
		#log(logNodeName + " steps " + #stringify($callStepsCur) + " Attempt(s)");
		#log(logNodeName + " idle " + #stringify($callStepsIdle) + " Attempt(s)");
		
		if ($assistGreetFull)
		{
			set $assistGreetFull = false;
			set $callStepsCur += 1;
			
			#say("assistGreetAttempt", interruptible: true, options: { emotion: "from text: i love you" });
			wait 
			{
				greetAttemptIdle
				greetAttemptPos
				greetAttemptNeg
			};
		}
		else
		{	
			//repeat
			if (($callMood == "positive") || ($callMood == "negative") || ($callStepsCur == 3))
			{
				set $callStepsCur += 1;
				#say("assistGreetRepeat", interruptible: true, options: { emotion: $callMood });
				wait
				{
					greetAttemptIdle
					greetAttemptPos
					greetAttemptNeg
				};
			}
			
			//explanation
			if (($callMood == "confusion") || ($callStepsCur > 3)
			{
				#say("assistGreetExplain", options: { emotion: "positive", speed: 0.7 });
				wait
				{
					greetAttemptIdle
					greetConfusedPos
					greetConfusedNeg
				};
			}	
		}		

		wait 
		{
			greetAttemptIdle
		};
	}
	
	transitions
	{
		greetAttemptIdle: goto assistGreetAttempt on timeout 10000;
		greetAttemptPos: goto assistGreetAttempt on #messageHasSentiment("positive");
		greetAttemptNeg: goto assistGreetAttempt on #messageHasSentiment("negative");
		greetConfusedPos: goto assistGreetAttempt on #messageHasIntents("yes");
		greetConfusedNeg: goto assistGreetAttempt on #messageHasIntents("no");
	}
	
	onexit {
		greetAttemptIdle: do { set $callStepsIdle += 1; }
		greetAttemptPos: do 
		{ 
			set $callMood = "positive";
		}
		greetAttemptNeg: do 
		{ 
			set $callMood = "negative"; 
		}
		greetConfusedPos: do
		{
			set $callMood = "positive";
			set $callStepsCur = 1;
			set $callRescued = true;
		}
		greetConfusedNeg: do
		{
			set $callMood = "hangup";
			set $callStepsCur = 1;
			set $callRescued = false;
		}		
	}
}

node @exit 
{
    do 
    {
		var logNodeName: string = "assistGreetAttempt";
		
		#log(logNodeName + " mood " + $callMood + " mood);
		#log(logNodeName + " steps " + #stringify($callStepsCur) + " Attempt(s)");
		#log(logNodeName + " idle " + #stringify($callStepsIdle) + " Attempt(s)");
		#log(logNodeName + " idle " + #stringify($callRescued) + " Attempt(s)");
		
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