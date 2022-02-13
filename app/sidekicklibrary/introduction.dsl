library

block introduction(sidekick: human, guest: human, greetFirst: boolean): human
{
	start node hello
	{
		do 
		{
			#preparePhrase("libIntroductionHello", {name: $sidekick.phonetic});
			#waitForSpeech(1000);
			#say("libIntroductionHello", {name: $sidekick.phonetic});
			return $guest;
		}
		
		transitions
		{
		}
	}
}