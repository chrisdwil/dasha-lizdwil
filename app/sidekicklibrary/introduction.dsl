library

block introduction(me: human, them: human, greetFirst: boolean): human
{
	start node hello
	{
		do 
		{
			if ($greetFirst)
			{
				#waitForSpeech(1000);
				#say("libIntroductionHello", {name: $me.phonetic});
				wait *;				
			}
			else
			{
				wait *;
			}
			return $them;
		}

		transitions
		{
			idle: goto hello on timeout 5000;
			confusion: goto helloConfused on #messageHasAnyIntent(["questions","confusion"]);
		}

		onexit 
		{
			idle: do { set $them.mood = "confusion"; }
			confusion: do { set $them.mood = "confusion"; }
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
			idle: goto @return on timeout 10000;
		}

		onexit
		{
			idle: do { set $them.mood = "silent"; }
		}
	}
	
	digression @return_dig
	{
			conditions
			{ 
				on true tags: onclosed; 
			}
			
			do 
			{
				return;
			}
	}
}