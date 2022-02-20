library

digression digFarewell
{
	conditions 
	{ 
		on #messageHasIntent("bye");
		on #messageHasIntent("endcall");
	}
	do
	{
		#say("libFarewell");
		exit;
	}
}