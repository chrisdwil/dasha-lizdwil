library

block introduction(me: human, greetFirst: boolean): human
{
	start node hello
	{
		do 
		{
			#preparePhrase("libIntroductionHello", {name: "Lizzzz"});
			#say("libIntroductionHello", {name: "Lizzzz"});
			return $me;
		}
		
		transitions
		{
		}
	}
}