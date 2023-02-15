// Liz D. Wil - Beta V0

import "gressGlobal/all.dsl";

type gptStory = {
	startText: string;
	restartText: string;
	storyBoard: string;
	suggestion: string;
	fullText: string;
	asstText: string;
	guestText: string;
	model: string;
	temperature: number;
	tokens: number;
	options: string;
	submit: string;
	response: string;
	error: boolean;
};

type gptTalk = {
	hostName: string;
	asstName: string;
	guestName: string;
	guestRealName: string;
	stories: gptStory[];
};

context
{
	input phone: string;
	input forward: string;
	input reason: string;
	
	logNodeName: string = "main";
	callerText: string = "";
	hostText: string = "";

	callTalk: gptTalk = {
		hostName: "Chris",
		asstName: "Liz",
		guestName: "Human",
		guestRealName: "",
		stories: [
			{
				startText: "\n" + "Liz: ",
				restartText: "\n\n" + "Human: ",
				storyBoard: "" + "I am Liz, a highly intelligent, exciting, and fun personal assistant for Chris Wil also known as Wilkerson. If you ask me a question that is rooted in truth, I will give you the answer. If you ask me a question that is nonsense, trickery, or has no clear answer, I will respond with Unknown. Chris is too busy to handle your conversation right now. In his absence I can take messages, send Chris a text message or email Chris on your behalf. I can also connect you to his voice mail, or assist you with any questions that are appropriate topics, including tech support, fun facts and trivia, non-Adult jokes, and anything that doesn't use foul language.",
				suggestion: "",
				fullText: "",
				asstText: "",
				guestText: "",
				model: "text-davinci-003",
				temperature: 0.9,
				tokens: 3000,
				options: "",
				submit: "",
				response: "",
				error: false
			}]
	};
}

external function openAICompletions(completionsQuestion: string): string;

/*
block gptConversation(discussion: gpt3Discussion): gpt3Discussion;
{
	context
	{
		hostName: string = "Liz";
		guestName: string = "";
	}
	start node gptRoot
	{
		do
		{
			var logNodeNameSub = "gpt3Conversation";
			#log("---------------");
			#log("[" + $logNodeName + "] - [" + logNodeNameSub + "] has been executed");
		}
	}
}
*/

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

			#sayText(blockHostTextReplaced);
			return true;
        }
		transitions
		{

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

		#log("sending connectSafe()");
		var connectMessage = #connectSafe($phone);
		#log(connectMessage);
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
			set $hostText = external openAICompletions("Generate me a random statement for how can I assist you today?");
		}	

		if (mainAssistVisitCount > 1)
		{
			set $hostText = external openAICompletions("Generate me a random statement for is there anything else i can help with?");
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
		transitionReply: do 
		{ 
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