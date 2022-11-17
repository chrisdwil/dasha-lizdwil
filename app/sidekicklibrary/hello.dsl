library

block hello ( discussion: interaction ): interaction
{
	context
	{
		functionname: string = "hello";
		lastIdleTime: number = 0;
		forgetTime: number = 15000;
		actions: string[] = ["goodbye","hello","message"];
	}
	
	start node main
	{
		do
		{
			var localFunctionName = "@";
			#log("---------------");
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log("---------------");

			goto handler;
		}
		
		transitions
		{
			handler: goto handler;
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
	
	node handler
	{
		do
		{
			var localFunctionName = "handler";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");

			wait *;
		}

		transitions
		{
			question: goto question on #getSentenceType() == "question" priority 10;
			request: goto request on #getSentenceType() == "request" priority 9;
			statement: goto statement on #getSentenceType() == "statement" priority 8;
			handler: goto handler on true priority 1;
		}

		onexit
		{
			default: do
			{
				var logText = "";
				#log(logText.concat(["unsure of caller intent: ", #getMessageText()]));
			}
		}
	}

	node question
	{
		do
		{
			var localFunctionName = "question";
			var logText = "";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");		
			#log(logText.concat(["caller has asked question with text: ", #getMessageText()]));
		}
	}	

	node request 
	{
		do
		{
			var localFunctionName = "request";
			var logText = "";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log(logText.concat(["caller has requested with text: ", #getMessageText()]));
		}		
	}

	node statement
	{
		do
		{
			var localFunctionName = "statement";
			var logText = "";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");	
			#log(logText.concat(["caller has stated with text: ", #getMessageText()]));	
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