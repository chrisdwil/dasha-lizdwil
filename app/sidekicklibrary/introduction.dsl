library

block introduction(me: human, greetFirst: boolean): human
{
	start node hello
	{
		do 
		{
			#preparePhrase("libIntroductionHello", {name: "Lizzzz"});
			#waitForSpeech(1000);
			#say("libIntroductionHello", {name: "Lizzzz"});
			return $me;
		}
		
		transitions
		{
		}
	}
}