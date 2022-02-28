library

type person = {
		name: string;
		nick: string;
		phonetic: string;
		role: string;
};

type notes = {
		text: string;
};

type result = {
		name: string;
		data: string;
}

constraints = {
		cycles: number;
		timeout: number;
		
}

type interaction = {
		name: string;
		agenda: string;
		request: string; // examples: transfer, message, farewell, unknown
		behavior: string; // examples: positive, neutral, negative, idle, confused
		people: person[]; // all people in discussion
		journal: notes[];
		results: result[];
};