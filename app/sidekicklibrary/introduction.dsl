library

block introduction(helloAttendees: people, helloReason: string): people
{	
	context
	{
		greeted: boolean = false;
	}
	
	start node hello
	{
		do 
		{
			var logNodeName: string = "hello";
			#log(logNodeName + " has been initialized for call reason: " + $helloReason);
			#log(logNodeName + " with following attendees:");
			#log($helloAttendees);
			
			if ($helloReason == "busy")
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
	        #log(logNodeName + " has been executed");
	        
			return $helloAttendees;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			return $helloAttendees;
		}
	}

	
	node helloRepeat
	{
		do
		{
			var logNodeName: string = "helloRepeat";
			#log(logNodeName + " has been initialized for repeat reason: unknown");
			#log(logNodeName + " with following attendees:");
			#log($helloAttendees);
	        
			var sentenceType = #getSentenceType(); 

	        if (sentenceType is not null)
	        {
	            $helloAttendees["guest"]["said"][sentenceType]?.push(#getMessageText());
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

			goto listen;
		}
		
		transitions
		{
			listen: goto helloListen;
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
				$helloAttendee["guest"]["mood"].push("confused");
			}
			
			idle: do
			{
				//set $helloAttendee["guest"]["mood"] = "idle";
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
			return $helloAttendees;
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
			return $helloAttendees;
		}
	}
}


