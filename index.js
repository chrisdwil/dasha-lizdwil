const dotenv = require("dotenv").config();
const commander = require("commander");
const dasha = require("@dasha.ai/sdk");
const fs = require("fs");
const axios = require("axios").default;
const accountSid = 'your api sid';
const authToken = 'your api auth token';
//const client = require('twilio')(accountSid, authToken);
const open_ai_key = process.env.OPEN_AI_KEY;

console.log(process.env.OPEN_AI_KEY);

commander
  .command("out")
  .description("check calls from Dasha")
  .requiredOption("-p --phone <phone>", "phone or SIP URI to call to")
  .option("-c --config <name>", "SIP config name", "default")
  .option("-f --forward <phone>", "phone or SIP URI to forward the call to")
  .option("-v --verbose", "Show debug logs")
  .action(async ({ phone, config, forward, verbose }) => {
    const app = await dasha.deploy("./app");

    app.setExternal("openAICompletions", async(args, conv) => {
      console.log(open_ai_key);

      const res = await axios.post( "https://api.openai.com/v1/completions",
        {
          model: 'text-davinci-003',
          prompt: args.completionsQuestion,
          temperature: 0,
          max_tokens:100,
          top_p: 1,
          frequency_penalty: 0,
          presence_penalty: 0
        },
        {
          headers: {
            Authorization: open_ai_key
        }
      });
      console.log(" JSON data from API ==>", res.data);
    
      receivedResponse = res.data;

      return receivedResponse = res.data.choices[0].text;
    });

    reason = "ok";
    forward = phone;

    await app.start();

    const conv = app.createConversation({ phone, forward: forward ?? null, reason: reason });
    if (verbose) {
      conv.on("debugLog", console.log);
    }
    conv.audio.tts = "dasha-emotional";
    conv.sip.config = config;

    await conv.execute();

    await app.stop();
    
    app.dispose();
  });

commander.parseAsync();