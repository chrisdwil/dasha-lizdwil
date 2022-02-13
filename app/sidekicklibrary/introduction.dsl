library

block introduction(name: string, greetFirst: boolean): boolean
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