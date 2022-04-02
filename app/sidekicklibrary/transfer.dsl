library

block transfer ( discussion: interaction ): interaction
{
	context
	{

	}
	
	start node main
	{
		do
		{
			var localFunctionName = "@";
			#log("---------------");
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log("---------------");

			if ($discussion.greet)
			{
				goto talk;
			}
			else
			{
				goto listen;
			}
			
			goto selfReturn;
		}
		
		transitions
		{
			selfReturn: goto @return;
			talk: goto talk;
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
	
	node talk
	{
		do
		{
			var localFunctionName = "talk";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log($discussion);
			#log("break 1");
			
			//#say("transfer.greet");
			goto transfer;
		}
		
		transitions
		{
			transfer: goto action;
		}
	}
	
	node listen
	{
		do
		{
			var localFunctionName = "listen";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log($discussion);
			
			wait *;
		}
		
		transitions
		{
			idle: goto action on timeout 100;
		}
		
		onexit
		{
			idle: do
			{
				#log("transition idle");
				
				set $discussion.behavior = "idle";
				set $discussion.request = "repeat";
				set $discussion.sentenceType = null;
				set $discussion.text = null;
			}
			
			default: do
			{
				#log("transition default");
				set $discussion.behavior = "positive";
				set $discussion.request = "repeat";
				set $discussion.sentenceType = #getSentenceType();
				set $discussion.text = #getMessageText();
			}
		}
	}

	node action
	{
		do
		{
			var localFunctionName = "action";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log($discussion);

			goto selfReturn;
		}

		transitions
		{
			selfReturn: goto @return;
		}
	}
}