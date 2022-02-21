library

block hello(group: people, conversation: discussion): discussion
{	
	start node hello
	{
		do
		{
			var logNodeName: string = "-- hello: ";
	        #log(logNodeName + "has been executed");
		}
	}
	
	node @return
	{
		do
		{
			var logNodeName: string = "-- hello.@return: ";
	        #log(logNodeName + "has been executed");
	        
			return $conversation;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			var logNodeName: string = "-- hello.@digReturn: ";
	        #log(logNodeName + "has been executed");
	        
			return $conversation;
		}
	}
}