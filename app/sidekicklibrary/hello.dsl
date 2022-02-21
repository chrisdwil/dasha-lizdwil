library

block hello(group: people, conversation: discussion): discussion
{	
	start node hello
	{
		do
		{
			#log($group);
			#log($conversation);
		}
	}
	
	node @return
	{
		do
		{
			var logNodeName: string = "@return";
	        #log(logNodeName + " has been executed");
	        
			return $conversation;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			return $conversation;
		}
	}
}