library

block assist ( discussion: interaction ): interaction
{
	context
	{
		lastIdleTime: number = 0;
		forgetTime: number = 15000;
		actions: string[] = ["callHost","message","farewell"];
	}
	
	start node main
	{
		do
		{
			var localFunctionName = "@";
			#log("---------------");
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log("---------------");
			
			goto listen;
		}
		
		transitions
		{
			listen: goto listen;
		}
	}
	
	node @return
	{
		do
		{
			var localFunctionName = "@return";
			#log("---------------");
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log("---------------");
			
			return $discussion;
		}
	}
	
	digression @digReturn
	{
		conditions
		{
			on true tags: onclosed;
		}
		do
		{
			var localFunctionName = "@digReturn";
			#log("---------------");
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log("---------------");
			
			exit;
		}
	}
	
	node listen
	{
		do
		{
			var localFunctionName = "listen";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log(#getSentenceType());
			#log(#getMessageText());

			wait *;
		}

		transitions
		{
			listen: goto listen on true priority 1;
		}
	}
	
	preprocessor digression action
	{
		conditions 
		{
			on #messageHasAnyIntent($actions) tags: ontick;
		}

		do
		{
			var localFunctionName = "action";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");

			return;
		}
	}
	
	preprocessor digression idle
	{
		conditions
		{
			on #getIdleTime() - $lastIdleTime > 2000 tags: ontick;
		}
		
		do
		{
			var localFunctionName = "idle";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log($discussion);
			
			set $lastIdleTime = #getIdleTime();
			return;
		}
	}
}