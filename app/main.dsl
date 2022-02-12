// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string = "sip:+12817829187@lizdwil.pstn.twilio.com;transport=udp";
	input sprint: boolean;
	
	name: string = "Liz";

	callMood: string = "positive";
	callStepsCur: number = 1;
	callStepsRisk: number = 5;
	callStepsIdle: number = 0;
	callRescued: boolean = false;
	assistGreetFull: boolean = true;
}

start node assist {
	do
	{	
		#preparePhrase("introduction", {name: $name});
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
		
		#log(logNodeName + " mood " + $callMood + " mood");
		#log(logNodeName + " steps " + #stringify($callStepsCur) + " Attempt(s)");
		#log(logNodeName + " idle " + #stringify($callStepsIdle) + " Attempt(s)");
		
		if ($assistGreetFull)
		{
			set $assistGreetFull = false;
			set $callStepsCur += 1;
			
			#say("introduction", {name: $name});
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
			if ((($callMood == "positive") || ($callMood == "negative")) && ($callStepsCur < 3))
			{
				set $callStepsCur += 1;
				#say("assistGreetRepeat", interruptible: true);
				wait
				{
					greetAttemptIdle
					greetAttemptPos
					greetAttemptNeg
				};
			}
			
			//explanation
			if (($callMood == "confusion") || (($callStepsCur > 3) && ($callMood != "positive")))
			{
				set $callStepsCur += 1;
				#say("assistGreetExplain");
				wait
				{
					greetAttemptIdle
					greetConfusedPos
					greetConfusedNeg
				};
			}
			
			//hangup
			if (($callMood == "hangup") && ($callStepsCur >= 3))
			{
				#say("assistGreetHangUpPrep");
				exit;
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
		greetConfusedPos: goto assistGreetAttempt on #messageHasIntent("yes");
		greetConfusedNeg: goto assistGreetAttempt on #messageHasIntent("no");
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
			set $callRescued = false;
		}		
	}
}

node @exit 
{
    do 
    {
		var logNodeName: string = "exit";
		
		#log(logNodeName + " mood " + $callMood + " mood");
		#log(logNodeName + " steps " + #stringify($callStepsCur) + " Attempt(s)");
		#log(logNodeName + " idle " + #stringify($callStepsIdle) + " Attempt(s)");
		
		if ($callMood == "negative")
		{
			#log(logNodeName + " call was not rescued");
		}
		
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