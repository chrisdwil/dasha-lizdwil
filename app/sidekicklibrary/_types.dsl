library

type talker = 
{
	name: string?;
	nick: string?;
	phonetic: string?;
};

type notes = 
{
	text: string?;
};

type result = 
{
	name: string?;
	data: string?;
};

type concerns = 
{
	cycles: string?;
	idle: string?;	
};

type interaction = 
{
	name: string?;
	agenda: string?;
	request: string?; // examples: transfer, message, farewell, unknown
	behavior: string?; // examples: positive, neutral, negative, idle, confused
	phrase: string?;

	/*
	// all people in discussion
	host: talker?; 
	sidekick: talker?;
	guest: talker?;
	
	journal: notes[]?;
	results: result[]?;
	*/
};