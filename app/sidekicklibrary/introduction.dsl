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
				set $greetFirst = false;
				#waitForSpeech(10000);
				#say("libIntroductionHello", {name: $sidekick.name});
				wait 
				{
					idleHello
				};
			}
			if (!$greetFirst) 
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}