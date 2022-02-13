library

block introduction(me: human, guest: human, greetFirst: boolean): boolean
{
	start node hello
	{
		do 
		{
			#log($me.name);
			if ($greetFirst)
			{
				set $greetFirst = false;
				#waitForSpeech(10000);
				#say("libIntroductionHello", {name: $me.name});
				wait 
				{
					idleHello
				};
			}
			if (!$greetFirst) 
			{
				return true;
			}
			return false;
		}
	}
}