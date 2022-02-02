context {
	input phone: string;
	input forward: string? = null;
	
	mainIntroResponse: string = "";	
}

start node mainIntroduction {
	do {
		#log("-- node mainIntroduction -- Introduction to caller");

		if(#getVisitCount("mainIntroduction") < 2) {
			#connectSafe($phone);
			#say("mainIntroduction");
		} 

		if(#getVisitCount("mainIntroduction") > 10) {		
			goto callerTimeout;
		}
	
		if(!#waitForSpeech(500)) {	
			wait { 
				restartself
			};
		}
		
		wait {
				agree
				disagree
		};
	}
	
	transitions {

		agree: goto offerAssistance on #messageHasSentiment("positive");
		disagree: goto offerAssistance on #messageHasSentiment("negative");
		
		callerTimeout: goto callerTimeout;
		restartself: goto mainIntroduction on true priority -1000 tags: ontick;
	}
	
	onexit {
		agree: do { set $mainIntroResponse == "positive"; }
		disagree: do { set $mainIntroResponse == "negative"; }
		
		callerTimeout: 
		restartself:
	}
}

node offerAssistance {
	do {
		#log("-- node offerAssistance -- offering assistance to caller");
		
		if($mainIntroResponse == "positive") {
			exit;
		}
		
		if($mainIntroResponse == "negative") {
			exit;
		}
	}
}

digression wantChris {
	conditions {on #messageHasIntent("transfer");}
	do {
		#sayText("wow you did your first digression");
		wait *;
		exit;
	}
	
	transitions {
		agree: goto mainIntroduction on #messageHasSentiment("positive");
	}
}

node callerTimeout {
	do {
        #log("-- node @exit -- ending conversation");

        #say("callerTimeout");
        exit;
	}
}

node @exit {
    do {
        #log("-- node @exit -- ending conversation");
        
        exit;
    }
}

digression @exit_dig {
		conditions { on true tags: onclosed; }
		do {
			exit;
		}
}