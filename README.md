Simple application based on Dasha.ai SDK for node.js for testing SIP connections. If you need any help, join us in our [Developer Community](http://community.dasha.ai).

# Prerequisites:
- node.js 12.0 and above
- dasha cli `npm i -g @dasha.ai/cli`
- logged in account using `dasha-cli`: `dasha account login default`
- access to an configuration of your PBX or SIP/PSTN/telephony provider

# How to use

- clone this repository
- `npm сi`

## Outbound calls checking

- Create inbound SIP configuration on your PBX/provider
- Create outbound SIP configuration on Dasha side
    - `dasha sip create-outbound -h`
    - for example: 
```
dasha sip create-outbound --server my-dasha-app.pstn.twilio.com --account +1XXXXXXXXXX --ask-password twilio
password: enter_your_password_here
```
- Call to yourself `node index.js out -c twilio -p +XXXXXX`
- More info: https://docs.dasha.ai/en-us/default/tutorials/sip-outbound-calls/


## Inbound calls checking

- Create inbound SIP configuration on Dasha side
`dasha sip create-inbound --application-name sip-test-app sip-test-app`
- Command will return SIP `uri`, you need to call
- Create outbound SIP configuration on PBX/provider side
- `node index.js in`
- Wait for line: `Waiting for calls via SIP`
- Call to `uri` returned by `dasha sip create-inbound`
- More info: https://docs.dasha.ai/en-us/default/tutorials/sip-inbound-calls/

## Checking call forwarding

This program allows you to check call forwarding

```
node index.js out -c twilio -p phone -f forward-phone
node index.js in -f forward-phone
```

In the end of the dialog, your call will be forwarded to `forward-phone`.

### Notes:

Forwarded calls are not tracked by Dasha, and are implemented using a `SIP REFER` message


Happy checking!!

---
dasha.ai team

https://dasha.ai















