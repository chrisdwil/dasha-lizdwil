library

digression digTransfer
{
	conditions { on #messageHasIntent("transfer"); }
	do
	{
		if ($forward is not null)
		{
			if ($sprint) 
			{
				#say("digTransferCell");
				exit;
			}
			else
			{
				#say("digTransfer");
				#forward($forward);
				#disconnect();
				exit;
			}
		}
		return;
	}
}