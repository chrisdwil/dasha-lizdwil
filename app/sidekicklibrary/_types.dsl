library

global type person = {
		name: string;
		nick: string;
		phonetic: string;
};

global type notes = {
		text: string;
};

type result = {
		name: string;
		data: string;
};

type constraints = {
		cycles: number;
		timeout: number;	
};

type interaction = {
		name: string;
		agenda: string;
		request: string; // examples: transfer, message, farewell, unknown
		behavior: string; // examples: positive, neutral, negative, idle, confused
		// all people in discussion
		host: person; 
		sidekick: person;
		guest: person;
		journal: notes[];
		results: result[];
};