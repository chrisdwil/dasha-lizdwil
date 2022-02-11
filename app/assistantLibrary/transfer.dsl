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
			wait *;
			#sayText("It appears he's unavailable.");
		}
		return;
	}
	transitions
	{
		digTransferTimeout: goto digTransferUnavailable on timeout 5000;
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