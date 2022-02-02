context {
	input phone: string;
	input forward: string? = null;
}

start node mainIntroduction {
	do {
		#log("-- node mainIntroduction -- Introduction to caller");

		if(#getVisitCount("mainIntroduction") < 2) {
			#connectSafe($phone);
			#say("mainIntroduction");
		} 

		/*
		if(#getVisitCount("mainIntroduction") > 10) {		
			goto transferTimeout;
		}
		*/
	
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

		agree: goto mainIntroductionPositive on #messageHasSentiment("positive");
		disagree: goto mainIntroductionNegative on #messageHasSentiment("negative");

		restartself: goto mainIntroduction on true priority -1000 tags: ontick;
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
		agree: goto mainIntroductionPositive on #messageHasSentiment("positive");
	}
}	

node mainIntroductionPositive {
	do {
		#log("-- node mainIntroductionPositive -- respond to caller's positive sentiment");

		#say("mainIntroductionPositive");
		exit;
	}
}

node mainIntroductionNegative {
	do {
		#log("-- node mainIntroductionNegative -- respond to caller's negative sentiment");

		#say("mainIntroductionNegative");
		exit;
	}
}

node @exit {
    do {
        #log("-- node @exit -- ending conversation");
        exit;
    }
}