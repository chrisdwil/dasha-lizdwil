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
//				disagree
//				transfer
		};
	}
		
	transitions {

		agree: goto mainIntroductionPositive on #messageHasSentiment("positive");
//		disagree: goto transferCallNo on #messageHasSentiment("negative");
//		transfer: goto transferCallYes on #messageHasIntent("transfer");
//		transferTimeout: goto transferTimeout;

//		restartself: goto mainIntroduction on true priority -1000 tags: ontick;
	}
}

node mainIntroductionPositive {
	do {
		#log("-- node mainIntroductionPositive -- respond to caller's positive sentiment");

		#say("mainIntroductionPositive");

		goto offerAssistance;
	}
	
	transitions {
	
		offerAssistance: goto offerAssistance on true;
		
	}
}

node mainIntroductionNegative {
	do {
		#log("-- node mainIntroductionNegative -- respond to caller's negative sentiment");

		#say("mainIntroductionNegative");
		
		goto offerAssistance;
	}
		
	transitions {
	
		offerAssistance: goto offerAssistance on true;
		
	}
}

node offerAssistance {
	do {
		exit;
	}
}

node @exit {
    do {
        #log("-- node @exit -- ending conversation");
        exit;
    }
} 

