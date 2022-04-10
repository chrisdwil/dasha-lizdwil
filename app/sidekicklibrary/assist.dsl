library

block assist ( discussion: interaction ): interaction
{
	context
	{
		defaultAttempts: number = 4;
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

			if ($discussion.greet)
			{
				#say("assist.greet");
				set $discussion.greet = false;
				#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been greeted");
			}

			if ($discussion.behavior == "idle")
			{
				#say("assist.idle");
				#log("[" + $discussion.name + "] - [" + localFunctionName + "] caller is idle or not understandable");
			}
			
			goto listen;
		}
		
		transitions
		{
			selfReturn: goto @return;
			listen: goto listen;
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
			connect: goto action on #messageHasIntent("connect") priority 10;
			message: goto action on #messageHasAnyIntent(["message"]) priority 8;
			farewell: goto action on #messageHasAnyIntent(["farewell"]) priority 5;
			idle: goto talk on timeout 10000;
			listen: goto listen on true priority -1;
		}
		
		onexit
		{
			farewell: do 
			{
				#log("transition farewell");
				set $discussion.behavior = "positive";
				set $discussion.request = "farewell";
				set $discussion.sentenceType = #getSentenceType();
				set $discussion.text = #getMessageText();
			}

			message: do
			{
				#log("transition message");
				set $discussion.behavior = "positive";
				set $discussion.request = "message";
				set $discussion.sentenceType = #getSentenceType();
				set $discussion.text = #getMessageText();	
			}

			connect: do
			{
				#log("transition connect");
				set $discussion.behavior = "positive";
				set $discussion.request = "connect";
				set $discussion.sentenceType = #getSentenceType();
				set $discussion.text = #getMessageText();	
			}

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