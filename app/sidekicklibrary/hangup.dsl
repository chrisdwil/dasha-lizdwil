library

digression digHangUp
{
	conditions 
	{ 
		on #messageHasIntent("bye");
		on #messageHasIntent("endcall");
	}
	do
	{
		exit;
	}
}