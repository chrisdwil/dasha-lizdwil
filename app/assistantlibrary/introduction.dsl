library

node hello
{
	do 
	{
		var waitSpeechTime: number = 1000;
		var waitIdleTime: number = 10000;
		#phraseParse("libIntroductionHello", $sidekick.name);
		if ($greetFirst)
		{
			#waitForSpeech($waitSpeechTime);
			#say("libIntroductionHello", $sidekick.name);
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
		idleHello: goto hello on timeout $waitIdleTime;
	}
	
	onexit
	{
		idleHello:
		{
			set $guest.mood = "silent";
		}
	}
}
