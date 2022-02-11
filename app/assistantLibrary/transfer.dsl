library

digression digTransfer
{
	conditions { on #messageHasIntent("transfer"); }
	do
	{
		if ($forward is not null)
		{
			#say("digTransfer");
			wait *;
			#sayText("it appears he's unavailable, you'll have to try again later");
		}
		return;
	}
	transitions
	{
		digTransferTimeout: goto digTransferUnavailable on timeout 8000;
	}
}

node digTransferUnavailable
{
	do
	{
		#disconnect();
		exit;
	}
}