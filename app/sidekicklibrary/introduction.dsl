library

block introduction(sidekick: human, guest: human, greeted: boolean): human
{	
	context
	{
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
			#log(logNodeName + " has been initalized");
			
			if (#waitForSpeech(1000) && !$greeted)
			{
				#log(logNodeName + " caller has been detected");
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
			return $guest;
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
	        #log(logNodeName + " has been initalized");
			#log($recognitions);	
			
			wait *;
			
			var sentenceType = #getSentenceType(); 
			
			if (sentenceType is not null) 
	        {
	            $recognitions[sentenceType]?.push(#getMessageText());
	        } else 
	        {
	            $recognitions.other.push(#getMessageText());
	        }
	        
	        #log($recognitions);
		}
		
		transitions
		{
			transfer: goto return on #messageHasIntent("transfer");
			idle: goto helloRepeat on timeout 10000;
		}
	}
}

/*
 
 			#log(logNodeName + " mood: " + $guest.mood);
			#log(logNodeName + " requested: " + $guest.request);
			#log(logNodeName + " responses: " + #stringify($guest.responses));			
			#log(logNodeName + " errors: " + #stringify($guest.errors));
			#log($recognitions);
 
	node helloMenu
	{
		do
		{
			#say("libIntroductionHelloMenu");
			wait *;
		}
		
		transitions
		{
			confirmedYes: goto hello on #messageHasIntent("yes");

			confusion: goto helloMenu on #messageHasAnyIntent(["questions","confusion"]);
			idle: goto hello on timeout 10000;
			sentinmentYes: goto hello on #messageHasSentiment("positive");

			transfer: goto @return on #messageHasIntent("transfer");
		}

		onexit 
		{
			confusion: do 
			{ 
				set $guest.mood = "confusion"; 
				set $guest.responses += 1;
			}
			idle: do 
			{ 
				set $guest.mood = "idle"; 
				set $guest.errors += 1;
			}
		}
	}
*/
	
