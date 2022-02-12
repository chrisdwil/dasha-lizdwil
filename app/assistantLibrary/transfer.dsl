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
				#sayText("it appears he's unavailable, you'll have to try again later");
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