library

block introduction(name: string, greetFirst: boolean): human
{
	start node hello
	{
		var fakeHuman: human;
		do 
		{
			#preparePhrase("libIntroductionHello", {name: "Lizzzz"});
			#say("libIntroductionHello", {name: "Lizzzz"});
			return fakeHuman;
		}
		
		transitions
		{
		}
	}
}