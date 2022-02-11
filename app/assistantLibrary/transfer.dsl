library

digression digTransfer
{
	conditions { on #messageHasIntent("transfer"); }
	do
	{
		#log("transferring to " + $forward)
		if ($forward is not null)
		{
			#say("digTransfer");
			#forward($forward);
		}
		return;
	}
}