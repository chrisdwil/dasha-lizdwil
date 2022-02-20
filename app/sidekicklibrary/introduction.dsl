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
			#log(logNodeName + " errors: " + $them.responses);			
			#log(logNodeName + " errors: " + $them.errors);			

			
			if ($greetFirst)
			{
				#waitForSpeech(1000);
				#say("libIntroductionHello", {name: $me.phonetic});
				wait *;				
			}
			else
			{
				if ($them.mood == "idle")
				{
					#say("libIntroductionHelloIdle");
				}
				wait *;
			}
			return $them;
		}

		transitions
		{
			confusion: goto helloConfused on #messageHasAnyIntent(["questions","confusion"]);
			idle: goto hello on timeout 10000;
			transfer: goto helloTransfer on #messageHasIntent("transfer");
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

	node @return 
	{
		do { return $them; }
	}
	
	node helloConfused
	{
		do
		{
			#say("libIntroductionHelloConfusion");
			wait *;
		}

		transitions
		{
			confusion: goto helloMenu on #messageHasAnyIntent(["questions","confusion"]);
			idle: goto @return on timeout 10000;
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
	
	node helloIdle
	{
		do
		{
			#say("libIntroductionHelloTransfer");
			$them.request = "transfer";
			@return;
		}
	}
	
	node helloIdle
	{
		do
		{
			#say("libIntroductionHelloIdle");
			wait *;
		}

		transitions
		{
			confusion: goto helloMenu on #messageHasAnyIntent(["questions","confusion"]);
			idle: goto @return on timeout 10000;
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
	
	node helloMenu
	{
		do
		{
			#say("libIntroductionHelloMenu");
			wait *;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do { exit; }
	}
	
}