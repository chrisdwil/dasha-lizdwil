library

block introduction(name: string, greetFirst: boolean): human
{
	start node hello
	{
		do 
		{
			#preparePhrase("libIntroductionHello", {name: "Lizzzz"});
			#say("libIntroductionHello", {name: "Lizzzz"});
			return false;
		}
		
		transitions
		{
		}
	}
}