library

block introduction(me: human, them: human, greetFirst: boolean): human
{
	start node hello
	{
		do 
		{
			var logNodeName: string = "assistGreetAttempt";

			#log(logNodeName + " mood: " + $them.mood);
			#log(logNodeName + " requested: " + $them.request);
			#log(logNodeName + " responses: " + #stringify($them.responses));			
			#log(logNodeName + " errors: " + #stringify($them.errors));			

			
			if ($greetFirst && #waitForSpeech(2000))

			{
				set $greetFirst = false;
				#say("libIntroductionHello", {name: $me.phonetic});
				wait *;				
			}
			else
			{
				if ($them.mood == "idle")
				{
					#say("libIntroductionHelloIdle");
				}
				if (($them.mood == "positive") || ($them.mood == "negative") || ($them.mood == "confusion"))
				{
					#say("libIntroductionHelloConfusion");
				}
				wait *;
			}
			return $them;
		}

		transitions
		{
			confusion: goto hello on #messageHasAnyIntent(["questions","confusion"]) priority 3;
			guess: goto guess on true priority 1;
			idle: goto hello on timeout 10000;
			transfer: goto @return on #messageHasIntent("transfer") priority 3;
		}

		onexit 
		{
			confusion: do 
			{ 
				set $them.mood = "confusion"; 
				set $them.responses += 1;
			}
			idle: do 
			{ 
				set $them.mood = "idle"; 
				set $them.errors += 1;
			}
			transfer: do
			{
				set $them.request = "transfer";
			}
		}
	}
	
	node @return
	{
		do
		{
			return $them;
		}
		
	}
	
	node guess 
	{
		do
		{
			#log("testing unknown sentence types: " + #getSentenceType());
			goto hello;
		}
		
		transitions
		{
			hello: goto hello on true;
		}
	}
	
	node helloMenu
	{
		do
		{
			#say("libIntroductionHelloMenu");
			wait *;
		}
		
		transitions
		{
			confirmedYes: goto hello on #messageHasIntent("yes");

			confusion: goto helloMenu on #messageHasAnyIntent(["questions","confusion"]);
			idle: goto hello on timeout 10000;
			sentinmentYes: goto hello on #messageHasSentiment("positive");

			transfer: goto @return on #messageHasIntent("transfer");
		}

		onexit 
		{
			confusion: do 
			{ 
				set $them.mood = "confusion"; 
				set $them.responses += 1;
			}
			idle: do 
			{ 
				set $them.mood = "idle"; 
				set $them.errors += 1;
			}
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do { exit; }
	}
	
}