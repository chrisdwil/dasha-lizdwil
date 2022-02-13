library

block introduction(name: string, greetFirst: boolean): human
{
	start node hello
	{
		do 
		{
			var fakeHuman: human;

			#preparePhrase("libIntroductionHello", {name: "Lizzzz"});
			#say("libIntroductionHello", {name: "Lizzzz"});
			return fakeHuman;
		}
		
		transitions
		{
		}
	}
}