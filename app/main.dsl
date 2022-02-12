context {
    input phone: string;
    input name: string = "";
    input message: string;
    output leavedMessage: string = "";
    output status: string = "Failed";
}

start node root
{
    do
    {
        #preparePhrase("hello", {name: $name});
        #preparePhrase("message", {message: $message});
        var connected = #connectSafe($phone);
        #say("hello", {name: $name});
        wait *;
    }
    transitions
    {
        sayMessage: goto sayMessage on true;
    }
}

node sayMessage
{
    do
    {
        #say("message", {message: $message});
        wait *;
    } 
    transitions
    {
        yes: goto leaveMessage on #messageHasIntent("agreement", "positive");
        no: goto @exit on #messageHasIntent("agreement", "negative");
        @default: goto getMessage on true;
    }
}

node leaveMessage
{
    do
    {
        #say("listening");
        wait *;
    } transitions
    {
        @default: goto getMessage on true when confident;
    }
}

node getMessage
{
    do
    {
        set $leavedMessage = #getMessageText();
        goto @default;
    } transitions
    {
        @default: goto @exit;
    }
}

node @exit
{
    do
    {
        set $status = "Completed";
        #say("fine");
        exit;
    }
}

digression @exit
{
    conditions { on true tags: onclosed; }
    do
    {
        exit;
    }
}

digression repeat
{
    conditions { on #messageHasIntent("repeat"); }
    do
    {
        #repeat();
        return;
    }
}