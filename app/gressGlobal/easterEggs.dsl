library

digression digressionSimCity
{
	conditions{on #messageHasIntent("simcity");}
	do
	{
		var logNodeNameSub = "digressionSimCity";
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#sayText("Chris likes the video game Sim City 2000.");
		#sayText("His favorite part is remembering the loading game messages...");
		#sayText("Here's a loading message for you...");
		#say("saySimCityTextRandom");
		wait *;
	}
}