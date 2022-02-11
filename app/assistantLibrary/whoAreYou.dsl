library

digression whoAreYou
{
	conditions { on #messageHasIntent("who_are_you"); }
	do
	{
		#say("digWhoAreYou");
		return;
	}
}