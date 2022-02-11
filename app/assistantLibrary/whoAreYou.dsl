library

digression whoAreYou
{
	condition { on #messageHasIntent("who_are_you"); }
	do
	{
		#say("digWhoAreYou");
		return;
	}
}