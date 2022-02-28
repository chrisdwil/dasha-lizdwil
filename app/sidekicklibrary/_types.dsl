type person = {
		name: string;
		nick: string;
		phonetic: string;
		role: string;
};

type interaction = {
		name: string;
		agenda: string;
		request: string; // examples: transfer, message, farewell, unknown
		behavior: string; // examples: positive, neutral, negative, idle, confused
		text: string;
		type: string;
};