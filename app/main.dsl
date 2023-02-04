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



start node main
{
	do
	{
		var hostText = external openAICompletions("Q: Generate me a greeting to a caller introducing myself as Liz");

		var logNodeNameSub = "@";
		#log("---------------");
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#log($phone);
		#log($forward);
		#log($reason);
		#log($hostText);
		#log("---------------");

		#connectSafe($phone);
		#waitForSpeech(3000);
		#sayText(hostText);
		goto transitionConversationAssist;
	}

	transitions 
	{
		transitionConversationAssist: goto mainConversationAssist;
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

node mainConversationAssist
{
	do
	{
		set $hostText = external openAICompletions("Q: Generate me a random statement that I am here to assist them with anything today");

		var logNodeNameSub = "mainConversationAssist";	
		#log("---------------");
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#log("---------------");

		#sayText($hostText);
		set $hostText = "";
		wait *;
	}

	transitions
	{
		transitionReply: goto mainReply on true;
		transitionTimeout: goto mainIdle on timeout 15000;
	}

	onexit 
	{
		transitionReply: do { set $callerText = #getMessageText(); }
	}
}

node mainReply
{
	do
	{
		set $hostText = external openAICompletions($callerText);
		#sayText($hostText);
		#log($hostText);
		goto mainReplyNext;
	}

	transitions 
	{
		mainReplyNext: goto mainConversationAssist;
	}
}

node mainIdle 
{
	do
	{
		set $hostText = "Are you still there?";

		var logNodeNameSub = "mainIdle";
		#log("---------------");
		#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		#log($hostText);
		#log("---------------");

		#sayText($hostText);
		goto mainIdleNext;
	}

	transitions 
	{
		mainIdleNext: goto mainConversationAssist;
	}
}