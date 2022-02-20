library

block introduction(me: human, them: human, greetFirst: boolean): human
{
	start node hello
	{
		do 
		{
			var logNodeName: string = "assistGreetAttempt";

			#log(logNodeName + " mood: " + them.mood);
			#log(logNodeName + " requested: " + them.request);			
			
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
		}

		onexit 
		{
			confusion: do { set $them.mood = "confusion"; }
			idle: do { set $them.mood = "idle"; }
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
			confusion: do { set $them.mood = "confusion"; }
			idle: do { set $them.mood = "idle"; }
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
			confusion: do { set $them.mood = "confusion"; }
			idle: do { set $them.mood = "idle"; }
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