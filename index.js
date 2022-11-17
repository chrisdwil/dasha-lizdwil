const commander = require("commander");
const dasha = require("@dasha.ai/sdk");
const accountSid = 'your api sid';
const authToken = 'your api auth token';
//const client = require('twilio')(accountSid, authToken);

commander
  .command("out")
  .description("check calls from Dasha")
  .requiredOption("-p --phone <phone>", "phone or SIP URI to call to")
  .option("-c --config <name>", "SIP config name", "default")
  .option("-f --forward <phone>", "phone or SIP URI to forward the call to")
  .option("-v --verbose", "Show debug logs")
  .action(async ({ phone, config, forward, verbose }) => {
    const app = await dasha.deploy("./app");

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

commander
  .command("in")
  .description("check calls to Dasha")
  .option("-f --forward <phone>", "phone or SIP URI to forward the call to")
  .option("-v --verbose", "Show debug logs")
  .action(async ({ forward, verbose }) => {
    const app = await dasha.deploy("./app", { groupName: "Default" });

    app.setExternal("messageForward", (args, conv) => {
      client.messages
        .create({
          body: 'test function',
          to: '',
          from: '', // From a valid Twilio number
        })
        .then((message) => console.log(message.sid));
      return true;
    });

    app.queue.on("ready", async (id, conv, info) => {
      if (info.sip !== undefined)
        console.log(`Captured sip call: ${JSON.stringify(info.sip)}`);
      reason = "ok";
      if (JSON.stringify(info.sip).includes("reason=user-busy"))
        reason = "busy";
      if (JSON.stringify(info.sip).includes("reason=no-answer"))
        reason = "no-answer";
      conv.input = { phone: "", forward: forward ?? null, reason: reason };
      if (verbose === true) {
        conv.on("debugLog", console.log);
      }
      conv.audio.tts = "dasha-emotional";
      await conv.execute();
      resultBody = result.recordingUrl.concat('\n');

      result.transcription.forEach(element => {
        if (element.speaker == "ai") {
          resultBody = resultBody + 'liz: ' + element.text + '\n\n';
        } else {
          resultBody = resultBody + 'guest: ' + element.text + '\n\n';
        }
      });

      console.log(resultBody);
      /*      client.messages
              .create({
                body: resultBody,
                to: '',
                from: '',
              })
              .then((message) => console.log(message.sid));
      */
      return true;
    });

    await app.start();

    console.log("Waiting for calls via SIP");
    const config = (await dasha.sip.inboundConfigs.listConfigs())[
      "sip-test-app"
    ];
    if (config?.applicationName === "sip-test-app") {
      console.log(config?.uri);
    }
    console.log("Press Ctrl+C to exit");
    console.log(
      "More details: https://docs.dasha.ai/en-us/default/tutorials/sip-inbound-calls/"
    );
    console.log("Or just type:");
    console.log(
      "dasha sip create-inbound --application-name sip-test-app sip-test-app"
    );
    console.log("And call to sip uri returned by command above");
  });

commander.parseAsync();