// Liz D. Wil - Beta V0
import "gressGlobal/all.dsl";

context
{
	input phone: string;
	input forward: string;
	input reason: string;
	
	logNodeName: string = "main";
	callerText: string = "";
	hostText: string = "";
}

external function openAICompletions(completionsQuestion: string): string;

block speakText(blockHostText: string, blockCallerText: string): boolean
{
	context
	{
	logNodeName: string = "speakText";
	}

    start node root
    {
        do
        {
			var blockHostTextReplaced = $blockHostText;
			set blockHostTextReplaced = blockHostTextReplaced.replaceAll("\n", "   ");
			set blockHostTextReplaced = blockHostTextReplaced.replaceAll("\"", "   ");

			var logNodeNameSub = "@";
			#log("---------------");
			#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
			#log("caller:" + $blockCallerText);
			#log("original:" + $blockHostText);
			#log("replaced:" + blockHostTextReplaced);

			#sayText(blockHostTextReplaced,
				options: { 
					speed: 0.99, emotion: "from text: Awesome Day!",
					interruptable: true
					}
				);	
			return true;
        }
    }
}

start node main
{
	do
	{
		set $hostText = external openAICompletions("Generate me a greeting to a caller introducing myself as Liz");

		var logNodeNameSub = "@";
		#log("---------------");
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#log($phone);
		#log($forward);
		#log($reason);
		#log("---------------");

		#connectSafe($phone);
		#waitForSpeech(10000);
		blockcall speakText($hostText, $callerText);
		goto transitionConversationAssist;
	}

	transitions 
	{
		transitionConversationAssist: goto mainAssist;
	}
}

node @exit
{
	do
	{
		var logNodeNameSub = "@exit";
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		
		#disconnect();
		exit;
	}
}

digression @digReturn
{
	conditions{on true tags: onclosed;}
	do
	{
		var logNodeNameSub = "@digReturn";
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		
		exit;
	}
}

node mainAssist
{
	do
	{
		var mainAssistVisitCount = #getVisitCount("mainAssist");
		
		if (mainAssistVisitCount == 1)
		{
			set $hostText = external openAICompletions("Generate me a random statement for how can I assist today?");
		}	

		if (mainAssistVisitCount > 1)
		{
			set $hostText = external openAICompletions("Generate me a random statement for is there anything else?");
		}

		if (mainAssistVisitCount > 3)
		{
			set $hostText = external openAICompletions("Generate me a random statement for I am getting busy here, is there anything else?");
		}

		var logNodeNameSub = "mainAssist";	
		#log("---------------");
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#log(mainAssistVisitCount);
		#log("---------------");

		blockcall speakText($hostText, $callerText);
		wait *;
	}

	transitions
	{
		transitionReply: goto mainReply on true;
		transitionTimeout: goto mainAssist on timeout 15000;
	}

	onexit 
	{
		transitionReply: do { 
								set $callerText = #getMessageText(); 
							}
	}
}

node mainReply
{
	do
	{
		blockcall speakText("Let me check ... ", $callerText);
		set $hostText = external openAICompletions($callerText);

		var logNodeNameSub = "mainReply";	
		#log("---------------");
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#log("---------------");
		
		blockcall speakText($hostText, $callerText);
		goto mainReplyNext;
	}

	transitions 
	{
		mainReplyNext: goto mainAssist;
	}
}