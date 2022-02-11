library

digression digTransfer
{
	conditions { on #messageHasIntent("transfer"); }
	do
	{
		if ($forward is not null)
		{
			#say("digTransfer");
			#connectSafe($forward);
			#sayText("Hey Chris do you want to this call?");
			wait *;
		}
		return;
	}
	transitions
	{
		digTransferTimeout: goto digTransferUnavailable on timeout 5000;
	}
}

node digTransferUnavailable