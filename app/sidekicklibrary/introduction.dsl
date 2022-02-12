library

node hello
{
	do 
	{
		//#preparePhrase("libIntroductionHello", $sidekick.name);
		#log($sidekick.name);
		if ($greetFirst)
		{
			#waitForSpeech(10000);
			//#say("libIntroductionHello", $sidekick.name);
			wait 
			{
				idleHello
			};
		}
		else
		{
			wait *;
		}
	}

	transitions
	{
		idleHello: goto hello on timeout 10000;
	}

	onexit
	{
		idleHello: do
		{
			set $guest.mood = "silent";
		}
	}
}