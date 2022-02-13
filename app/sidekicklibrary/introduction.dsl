library

block introduction(name: string, greetFirst: boolean): boolean
{
	start node hello
	{
		do 
		{
			#say("libIntroductionHello", name: "Lizzzz");
			return false;
		}
		
		transitions
		{
		}
	}
}