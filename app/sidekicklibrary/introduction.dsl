library

block introduction(): boolean
{
	node hello
	{
		do 
		{
			#log($sidekick.name);
			if ($greetFirst)
			{
				set $greeFirst = false;
				#waitForSpeech(10000);
				#say("libIntroductionHello", {name: $sidekick.name});
				wait 
				{
					idleHello
				};
			}
			if (!$greetFirst) {
				return true;
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
}