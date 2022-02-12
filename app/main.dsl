context {
    input phone: string;
    input name: string = "";
    input message: string;
    output leavedMessage: string = "";
    output status: string = "Failed";
}

start node root
{
    do
    {
        #preparePhrase("hello", {name: $name});
        #preparePhrase("message", {message: $message});
        var connected = #connectSafe($phone);
        #say("hello", {name: $name});
        wait *;
    }
    transitions
    {
        sayMessage: goto sayMessage on true;
    }
}

node sayMessage
{
    do
    {
        #say("message", {message: $message});
        wait *;
    } 
    transitions
    {
        yes: goto leaveMessage on #messageHasIntent("agreement", "positive");
        no: goto @exit on #messageHasIntent("agreement", "negative");
        @default: goto getMessage on true;
    }
}

<<<<<<< HEAD
node leaveMessage
{
    do
    {
        #say("listening");
        wait *;
    } transitions
    {
        @default: goto getMessage on true when confident;
    }
}
=======
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
			
			#say("assistGreetAttempt", interruptible: true);
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
			f ((($callMood == "positive") || ($callMood == "negative")) && ($callStepsCur < 3))
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
			if (($callMood == "confusion") || (($callStepsCur >= 3) && ($callMood != "positive"))
=======
			if (($callMood == "confusion") || (($callStepsCur >= 3) && ($callMood != "positive")))
>>>>>>> parent of f5bebce (.)
=======
			if (($callMood == "confusion") || (($callStepsCur >= 3) && ($callMood != "positive")))
>>>>>>> parent of f5bebce (.)
=======
			if (($callMood == "confusion") || (($callStepsCur >= 3) && ($callMood != "positive")))
>>>>>>> parent of f5bebce (.)
=======
			if (($callMood == "confusion") || (($callStepsCur >= 3) && ($callMood != "positive")))
>>>>>>> parent of f5bebce (.)
			{
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
>>>>>>> parent of 52bbe3d (.)

node getMessage
{
    do
    {
        set $leavedMessage = #getMessageText();
        goto @default;
    } transitions
    {
        @default: goto @exit;
    }
}

node @exit
{
    do
    {
        set $status = "Completed";
        #say("fine");
        exit;
    }
}

digression @exit
{
    conditions { on true tags: onclosed; }
    do
    {
        exit;
    }
}

digression repeat
{
    conditions { on #messageHasIntent("repeat"); }
    do
    {
        #repeat();
        return;
    }
}