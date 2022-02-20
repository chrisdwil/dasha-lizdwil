library

block introduction(attendeelist: human[], reason: string): human[]
{	
	context
	{
		greeted: boolean = false;
	    
	    recognitions: 
	    {
	    	statement: string[];
	        request: string[];
	        question: string[];
	        other: string[];
	    } = {
	            statement: [],
	            request: [],
	            question: [],
	            other: []
        };
	}
	
	start node hello
	{
		do 
		{
			var logNodeName: string = "hello";
			#log(logNodeName + " has been initialized for reason: " + $reason);
			
			if ($reason == "busy")
			{
				#say("libIntroductionHelloUnavailable");
				exit;
			}
			
			if (#waitForSpeech(5000))
			{
				#log(logNodeName + " caller has been detected");
				#say("libIntroductionHello");
				set $greeted = true;
				wait *;
			}
			else
			{
				goto greetForce;
			}
			 
		}

		transitions
		{
			greet: goto helloRepeat on true;
			greetForce: goto helloRepeat;
		}
	}
	
	node @return
	{
		do
		{
			var logNodeName: string = "@return";
	        #log(logNodeName + " has been initialized");
	        
			return $attendeelist;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			exit;
		}
	}
	
	node helloRepeat
	{
		do
		{
			var logNodeName: string = "helloRepeat";
	        #log(logNodeName + " has been initialized");
 			#log(logNodeName + " " + $attendeelist[2]);
	        
			var sentenceType = #getSentenceType(); 

	        if (sentenceType is not null)
	        {
	            $recognitions[sentenceType]?.push(#getMessageText());
		        #log($recognitions);
	        }
						
			if (!$greeted) 
			{
				set $greeted = true;
				#say("libIntroductionHello");
				#say("libIntroductionHelloAssist");
			}
			
			/*
			{
				#say("libIntroductionHelloAssist");
			}
			
			if ($attendeelist[2].mood == "confused")
			{
				#say("libIntroductionHelloMenu");
			}
			*/
			goto farewell;
			goto listen;
		}
		
		transitions
		{
			listen: goto helloListen;
			farewell: goto @return;
		}
	}
	
	node helloListen
	{
		do
		{
			var logNodeName: string = "helloListen";
	        #log(logNodeName + " has been initialized");

			wait *;
		}
		 
		transitions
		{
			confusion: goto helloRepeat on #messageHasAnyIntent(["questions","confusion"]) priority 5;
			farewell: goto helloFarewell on #messageHasAnyIntent(["farewell"]) priority 10;
			idle: goto helloRepeat on timeout 10000;
			listen: goto helloListen on true priority 1;
			transfer: goto helloTransfer on #messageHasAnyIntent(["transfer"]) priority 9;
		}
		
		onexit
		{	
			confusion: do 
			{
			//	set $attendeelist[2].mood = "confused";
			}
			
			idle: do
			{
			//	set $attendeelist[2].mood = "idle";

			}
		}
	}
	
	node helloTransfer
	{
		do
		{
			var logNodeName: string = "helloTransfer";
	        #log(logNodeName + " has been initialized");
	        
			//set $attendeelist[2].mood = "positive";
			//set $attendeelist[2].request = "transfer";
			#say("libIntroductionHelloTransfer");
			return $attendeelist;
		}
	}
	
	node helloFarewell
	{
		do
		{
			var logNodeName: string = "helloFarewell";
	        #log(logNodeName + " has been initialized");
	        
			//set $attendeelist[2].mood = "positive";
			//set $attendeelist[2].request = "farewell";
			#say("libIntroductionHelloFarewell");
			return $attendeelist;
		}
	}
}
