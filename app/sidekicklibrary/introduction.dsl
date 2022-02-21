library

block setSentenceType(): string
{
	var sentenceType = #getSentenceType(); 

    if (sentenceType is not null)
    {
    	return sentenceType
        //$helloAttendees["guest"]["said"][sentenceType]?.push(#getMessageText());
    }
    return "other";
}

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
						
			if (!$greeted)
			{
				set $greeted = true;
				#say("libIntroductionHello");
				#say("libIntroductionHelloAssist");
			}
			
			if ($helloAttendees["guest"]["mood"] == "idle")
			{
				#say("libIntroductionHelloAssist");
			}
			
			if ($helloAttendees["guest"]["mood"] == "confused")
			{
				#say("libIntroductionHelloMenu");
			}

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
			//confusion: goto helloRepeat on #messageHasAnyIntent(["questions","confusion"]) priority 5;
			//farewell: goto helloFarewell on #messageHasAnyIntent(["farewell"]) priority 10;
			idle: goto helloRepeat on timeout 5000;
			//listen: goto helloListen on true priority 1;
			transfer: goto helloTransfer on #messageHasAnyIntent(["transfer"]) priority 9;
		}
/*		
		onexit
		{	
			confusion: do 
			{
				//set $helloAttendees["guest"]["mood"] = "confused";
			}
			
			idle: do
			{
				//set $helloAttendees["guest"]["mood"] = "idle";
			}
		}
*/
	}
	
	node helloTransfer
	{
		do
		{
			var logNodeName: string = "helloTransfer";
	        #log(logNodeName + " has been initialized");

	        blockcall setSentenceType();
//	        set $helloAttendees["guest"]["mood"] = "positive";
//	        set $helloAttendees["guest"]["ask"] = "transfer";
			#say("libIntroductionHelloTransfer");
			return $helloAttendees;
		}
	}
/*	
 
 
 			var sentenceType = #getSentenceType(); 

	        if (sentenceType is not null)
	        {
	            $helloAttendees["guest"]["said"][sentenceType]?.push(#getMessageText());
	        }
	        
	node helloFarewell
	{
		do
		{
			var logNodeName: string = "helloFarewell";
	        #log(logNodeName + " has been initialized");
	        
        	set $helloAttendees["guest"]["mood"] = "positive";
	        set $helloAttendees["guest"]["ask"] = "farewell";
			#say("libIntroductionHelloFarewell");
			return $helloAttendees;
		}
	}
*/
}


