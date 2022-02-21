library

block hello(group: people, conversation: discussion): discussion
{	
	context {
		logNodeName: string = "[hello]";
	}
	
	start node hello
	{
		do
		{
			var logNodeNameSub = "@";
	        #log($logNodeName + " - [" + logNodeNameSub + "]" + "has been executed");
	        
	        set $conversation = {
	        		agenda: "agenda",
	        		request: "transfer",
	        		behavior: "positive",
	        		journal: ["hi", "i did a thing"]
	        };
	        
	        wait *;
		}
		
		transitions
		{
			idle: goto @return on timeout 100;
		}
	}
	
	node @return
	{
		do
		{
			var logNodeNameSub = "@return";
	        #log($logNodeName + " - [" + logNodeNameSub + "]" + "has been executed");
	        
	        
			return $conversation;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			var logNodeNameSub = "@digReturn";
	        #log($logNodeName + " - [" + logNodeNameSub + "]" + "has been executed");
	        
			return $conversation;
		}
	}
}