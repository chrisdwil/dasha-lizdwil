library

block introduction(name: string, greetFirst: boolean): boolean
{
	start node hello
	{
		do 
		{
			if ($greetFirst)
			{
				set $greetFirst = false;
				#waitForSpeech(10000);
				#say("libIntroductionHello", {name: $name});
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
		
		transitions
		{
			idleHello: goto hello on timeout 10000;
		}
	}
}