library

block hello(group: people, conversation: discussion): discussion
{
	context {
		
	}
	
	start node hello
	{
		do
		{
			#log($group);
			#log($conversation);
		}
	}
}