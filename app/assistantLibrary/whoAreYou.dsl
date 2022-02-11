library

digression whoAreYou
{
	condition { on #messageHasIntent("who_are_you"); }
	do
	{
		#sayText("My name is Liz D. Wil, but you can just call me Liz.");
		return;
	}
}