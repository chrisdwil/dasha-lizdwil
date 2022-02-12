library

block introduction(me: human, greetFirst: boolean): human
{
	context
	{
		var waitSpeechTime: number = 1000;
		var waitIdleTime: number = 10000;
	}

	start node hello
	{
		do 
		{
			#phraseParse("libIntroductionHello" $me.name)
			if ($greetFirst)
			{
				#waitForSpeech($waitSpeechTime);
				#say("libIntroductionHello", $me.name);
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
				set $introduction.mood = "silent";
			}
		}
	}
}