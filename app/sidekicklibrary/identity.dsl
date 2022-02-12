library

digression digWhoAreYou
{
	conditions { on #messageHasIntent("who_are_you"); }
	do
	{
		#say("digWhoAreYou");
		return;
	}
}

digression digSelf
{
	conditions { on #messageHasIntent("self"); }
	do
	{
		#say("digSelf");
		return;
	}
}