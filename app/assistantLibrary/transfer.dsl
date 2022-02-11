library

digression digTransfer
{
	conditions { on #messageHasIntent("transfer"); }
	do
	{
		if ($forward is not null)
		{
			#say("digTransfer");
			#forward($forward);
		}
		wait *;
		return;
	}
}