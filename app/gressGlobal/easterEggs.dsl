library

digression digressionSimCity
{
	conditions{on #messageHasIntent("simcity");}
	do
	{
		var logNodeNameSub = "digressionSimCity";
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#say("saySimCityTextMulti");
		#say("saySimCityTextRandom");
		wait *;
	}
}