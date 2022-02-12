// Liz D. Wil
//import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string = "sip:+12817829187@lizdwil.pstn.twilio.com;transport=udp";
	input sprint: boolean;
	
	herName: string = "Liz D. Wil";
	herNick: string = "Liz";
	herGender: string = "multibit";
	myName: string = "Chris D. Wil";
	myNameNick: string = "Chris Dee";
	myGender: string = "male";
	
	callMood: string = "positive";
	callStepsCur: number = 1;
	callStepsRisk: number = 5;
	callStepsIdle: number = 0;
	callRescued: boolean = false;
	assistGreetFull: boolean = true;
}

start node assist {
	do
	{	
		#connect($phone);
		wait *;
	}
	
	transitions
	{
		assistGreetAttempt: goto assistGreetAttempt on timeout 300;
	}
}

node assistGreetAttempt {
	do
	{		
		#preparePhrase("hello", {nickName: $herName});
		#say("hello", {nickname: $herName});
		
		exit;
	}
}

node @exit 
{
    do 
    {
						
        exit;
    }
}

digression @exit_dig
{
		conditions
		{ 
			on true tags: onclosed; 
		}
		
		do 
		{
			exit;
		}
}