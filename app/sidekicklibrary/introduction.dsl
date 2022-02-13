library

block introduction(sidekick: human, guest: human, greetFirst: boolean): human
{
	start node hello
	{
		do 
		{
			if (greetFirst)
			{
				#preparePhrase("libIntroductionHello", {name: $sidekick.phonetic});
				#waitForSpeech(1000);
				#say("libIntroductionHello", {name: $sidekick.phonetic});
				wait *;				
			}
			else
			{
				wait *;
			}
			return $guest;
		}
		
		transitions
		{
			idle: goto hello on timeout 5000;
			confusion: goto helloConfused on #messageHasAnyIntents(["questions","confusion"])
		}
	}
	
	node helloConfused
	{
		do
		{
			#sayText("are you there?");
		}
	}
}