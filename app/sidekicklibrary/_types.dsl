library

type talker = 
{
	name: string?;
	nick: string?;
	phonetic: string?;
};

type result = 
{
	name: string?;
	data: string?;
};

/*
type  = 
{
	// max or defaults
	steps: string?;
	timeout: string?;	
	errors: strings?;
};
*/

type interaction = 
{
	name: string;
	agenda: string;
	greet: boolean; // should we greet first or listen?
	request: string?; // examples: transfer, message, farewell, unknown
	behavior: string?; // examples: positive, neutral, negative, idle, confused
	phrase: string?;

	// all people in discussion
	host: talker?; 
	sidekick: talker?;
	guest: talker?;
};