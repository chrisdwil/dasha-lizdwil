library

digression digHowAreYou
{
	conditions { on #messageHasIntent("how_do_you_do"); }
	do
	{
		#say("digHowAreYou");
		#say("digHowAreYouReturn", option)
		return;
	}
}