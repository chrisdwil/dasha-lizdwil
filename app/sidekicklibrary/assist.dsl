library

block assist ( discussion: interaction ): interaction
{
	context
	{
		lastIdleTime: number = 0;
		forgetTime: number = 15000;
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
			
			wait *;
		}
		
		transitions
		{
			listen: goto listen on true tags: ontick;
		}
		
		onexit
		{
			listen: do
			{
				set $discussion.sentenceType = null;
				set $discussion.text = null;
			}
			
			default: do
			{
				set $discussion.sentenceType = #getSentenceType();
				set $discussion.text = #getMessageText();
			}
		}
	}
	
	preprocessor digression action
	{
		conditions
		{
			on $discussion.request is null priority 2000 tags: ontick;
			on #messageHasSentiment("positive") priority 1999 tags: ontick;
			on #messageHasSentiment("negative") priority 1998 tags: ontick;
		}
		
		var actions: string[] = ["assist.greet", "assist.confirm", "assist.host", "assist.transfer", "assist.message", "farewell"];

		do
		{
			var localFunctionName = "action";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			if ($discussion.text is not null)
			{
				#log($discussion);
			}

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
		
		transitions
		{
			greetConfirm: goto listen on $discussion.request == "greet";
		}

		onexit
		{
			greetConfirm: do
			{
				set $discussion.request = "greetConfirm";
			}
		}
	}
}