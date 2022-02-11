library

digression digTransfer
{
	conditions { on #messageHasIntent("transfer"); }
	do
	{
		#log("transferring to " + $number)
		if ($forward is not null)
		{
			#say("digTransfer");
			#forward($forward);
		}
		return;
	}
}