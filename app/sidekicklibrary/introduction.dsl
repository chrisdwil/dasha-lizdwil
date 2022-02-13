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
				#say("libIntroductionHello");
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
			idle: do { set $them.mood = "confusion" }
			confusion: do { set $them.mood = "confusion" }
		}
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
			idle: goto hangUp on timeout 10000;
		}
	}
}