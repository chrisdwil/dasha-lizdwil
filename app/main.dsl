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
		
		if(#getVisitCount("mainIntroduction") > 10) {		
			goto transferTimeout;
		}
	
		if(!#waitForSpeech(500)) {	
			wait { 
				restartself
			};
		}
		
		wait {
				/*
				transfer
				transferYes
				transferNo
				*/
				agree
				disagree
		};
	}
		
	transitions {
/*
		transfer: goto transferCallYes on #messageHasIntent("transfer");
		transferYes: goto transferCallYes on #messageHasIntent("yes");
		transferNo: goto transferCallNo on #messageHasIntent("no");
*/
		agree: goto transferCallYes on #messageHasSentiment("positive");
		disagree: goto transferCallNo on #messageHasSentiment("negative");
		transferTimeout: goto transferTimeout;

		restartself: goto mainIntroduction on true priority -1000 tags: ontick;
	}
}

node transferCallYes {
	do {
		#log("-- node transferCallYes -- entered call transfer");

		if(#getVisitCount("transferCallYes") < 2) {
			#say("hold");
		} 

		/*
		if(#getVisitCount("transferCallYes") > 10) {
				goto offerMessage;	
		}
		*/
		
		if(#getVisitCount("transferCallYes") < 11) {	
			wait { 
				restartself
			};
		}
	}

	transitions {
		offerMessage: goto offerMessage;
	
		restartself: goto transferCallYes on true priority -1000 tags: ontick;
	}
}

node transferCallNo {
	do {
		#log("-- node transferCallNo -- entered call transfer");
		
		if(#getVisitCount("transferCallNo") < 2) {
			#say("offerMessage");
		} else if(#getVisitCount("transferCallNo") > 10) {		
			goto transferTimeout;
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
		agree: goto hangUp on #messageHasIntent("yes");
		disagree: goto hangUp on #messageHasIntent("no");
		transferTimeout: goto transferTimeout;
	
		restartself: goto transferCallNo on true priority -1000 tags: ontick;
	}
}

node messageOffer {
	do {
		#log("-- node offerMessage -- offer caller chance to leave a message");

		if(#getVisitCount("mainIntroduction") < 2) {
			#say("offerMessage");
		} 
		
		if(#getVisitCount("offerMessage") > 10) {		
			goto transferTimeout;
		}
	
		if(!#waitForSpeech(500)) {	
			wait { 
				restartself
			};
		}
		
		wait {
				/*
				transfer
				transferYes
				transferNo
				*/
				agree
				disagree
		};
		
		
		
	}
}

node transferTimeout {
	do {
		#log("-- node transferTimeout -- Hanging up on caller due to timeout");
		#say("transferTimeout");
		exit;
	}
}

node hangUp {
	do {
		#log("-- node transferTimeout -- Hanging up on caller due to timeout");
		#say("hangUp");
		exit;
	}
}

node @exit {
    do {
        #log("-- node @exit -- ending conversation");
        exit;
    }
} 

