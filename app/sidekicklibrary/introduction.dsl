library

node hello
{
	do 
	{
		var waitSpeechTime: number = 1000;
		var waitIdleTime: number = 10000;

		if ($greetFirst)
		{
			//#waitForSpeech($waitSpeechTime);
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

