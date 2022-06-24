---
title: Direct Line API 3.0
excerpt: 'Understand communication between your bot and Unity by using the Direct Line API.'
permalink: 
image: /assets/images/illustrations/chatbot.jpeg
categories:
  - Bot
tags:
  - Direct Line API
  - Conversation
  - Customer
  - Unity
---

You can enable communication between your [bot](2021-12-10-bot.md) and Unity by using the `Direct Line API`.
I will explain how to do it in Unity but also provide some information about the mechanism.

## Authentication
Direct Line API 3.0 requests can be authenticated either by using a secret that you obtain from the Direct Line channel configuration page in the Azure Portal or by using a token that you obtain at runtime. 

- A Direct Line `secret` is a master key that can be used to access any conversation that belongs to the associated bot. A secret can also be used to obtain a token. Secrets do not expire.
- A Direct Line `token` is a key that can be used to access a single conversation. A token expires but can be refreshed.

## Starting conversation
[Additional Reading](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-direct-line-3-0-start-conversation?view=azure-bot-service-4.0){:target="_blank"}

Direct Line conversations are explicitly opened by clients and may run as long as the bot and client participate and have valid credentials.
While the conversation is open, both the bot and client may send messages. 

> More than one client may connect to a given conversation and each client may participate on behalf of multiple users.

To open conversation, issue a POST Request to the endpoint

```http
POST https://directline.botframework.com/v3/directline/conversations
Authorization: Bearer `SECRET` OR `TOKEN`
```

If the request is successful, the response will contain an ID for the conversation, a token, a value that indicates the number of seconds until the token expires, and a stream URL that the client may use to receive activities.

```json
{
    "conversationId": "-ABC-",
    "token": "-123-",
    "expires_in": 3600,
    "streamUrl": "wss://directline.botframework.com/v3/directline/conversations/-ABC-/stream?watermark=-&t=-123-",
    "referenceGrammarId": "ddf0cd2c-b093-595c-b951-8431afebed17"
}
```

To perform this action in Unity, we have to:
- Call the HTTP Service and store the answer for later purpose.
- Initiate discussion to have the greetings (optional - see [Microsoft Bot Channel activities](https://docs.microsoft.com/en-us/azure/bot-service/bot-service-channels-reference?view=azure-bot-service-4.0#categorized-activities-by-channel)

```csharp
internal IEnumerator StartConversation()
{
  // Compose Directline Endpoint
  string conversationEndpoint = string.Format("{0}/conversations", botEndpoint);

  // Create a empty webform to perform post
  WWWForm webForm = new WWWForm();

  // Call HTTP Service with Unity - See https://docs.unity3d.com/ScriptReference/Networking.UnityWebRequest.html
  using (UnityWebRequest uwr = UnityWebRequest.Post(conversationEndpoint, webForm))
  {
    // Define Auth header
    uwr.SetRequestHeader("Authorization", "Bearer " + botSecret);
    // Define temp storage for answer
    uwr.downloadHandler = new DownloadHandlerBuffer();

    // Send & Wait for answer
    yield return uwr.SendWebRequest();

    // Manage answer if no faillure
    if (uwr.result != UnityWebRequest.Result.Success)
    {
      Debug.LogError($"BOT | StartConversation | Request error: {uwr.error} \n Status: {uwr.responseCode.ToString()}");
    }
    else
    {
      // Catch the answer
      string jsonResponse = uwr.downloadHandler.text;

      // Create Conversation to store authentication
      conversation = new Conversation();
      conversation = JsonUtility.FromJson<Conversation>(jsonResponse);

      // Create Activities to store conversation messages
      activities = new Activities();

      // Set the Bot Status
      conversationStarted = true; 

      // Request a first "introduction" from the Bot
      if(greetings)
      {
        // The following call is necessary to create and inject an activity of type "conversationUpdate" to get greetings from your bot
        StartCoroutine(SendMessageToBot("", botId, botName, "conversationUpdate"));
      }
    }
  }
}
```

## Sending messages
[Additional Reading](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-direct-line-3-0-send-activity?view=azure-bot-service-4.0)
By using `Direct Line API`, Unity can send messages to your bot by issuing HTTP `POST` requests. 

> You may send a single message per request.

To send a message to the bot, the client must create an Activity and then issue a request to `https://directline.botframework.com/v3/directline/conversations/{conversationId}/activities`, specifying the Activity object in the body of the request. 

```http
POST https://directline.botframework.com/v3/directline/conversations/abc123/activities
Authorization: Bearer RCurR_XV9ZA.cwA.BKA.iaJrC8xpy8qbOF5xnR2vtCX7CZj0LdjAPGfiCpg4Fv0
Content-Type: application/json
[other headers]
```
```json
{
    "locale": "en-EN",
    "type": "message",
    "from": {
        "id": "user1"
    },
    "text": "hello"
}
```

When the activity is delivered to the bot, the service responds with an HTTP status code that reflects the bot's status code. If the POST is successful, the response contains a JSON payload that specifies the ID of the Activity that was sent to the bot.

```csharp
private IEnumerator SendMessageToBot(string message, string activityType)
{
    // Compose Directline Endpoint
    string activityEndpoint = string.Format("{0}/conversations/{1}/activities", botEndpoint, conversation.conversationId);

    // Create a empty webform to perform post
    WWWForm webForm = new WWWForm();

    // Create a new activity
    Activity activity = new Activity();
    // Provide Conversation Id
    activity.conversation = new ConversationReference();
    activity.conversation.id = conversation.conversationId;
    // Provide Sender Information
    activity.from = new UserAccount();
    activity.from.id = playerId;
    activity.from.name = playerName;
    // Provide Message
    activity.text = message;
    // Provide content Type
    activity.type = activityType;
    // Provide Channel used
    activity.channelId = "DirectLineChannelId";

    // Serialize the activity
    string json = JsonUtility.ToJson(activity);

    // Call HTTP Service with Unity - See https://docs.unity3d.com/ScriptReference/Networking.UnityWebRequest.html
    using (UnityWebRequest uwr = UnityWebRequest.Post(activityEndpoint, webForm))
    {
        // Define Auth header
        uwr.SetRequestHeader("Authorization", "Bearer " + botSecret);
        // Define temp storage for answer
        uwr.downloadHandler = new DownloadHandlerBuffer();
        // Define
        uwr.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(json));
        // Define Content format
        uwr.uploadHandler.contentType = "application/json";

        // Send & Wait for answer
        yield return uwr.SendWebRequest();

        // Manage answer if no faillure
        if (uwr.result != UnityWebRequest.Result.Success)
        {
            Debug.LogError($"BOT | StartConversation | Request error: {uwr.error} \n Status: {uwr.responseCode.ToString()}");
        }
        else
        {
            // Catch the answer
            string jsonResponse = uwr.downloadHandler.text;

            // Create ActivtyReference to store latest message
            activityReference = new ActivityReference();
            activityReference = JsonUtility.FromJson<ActivityReference>(jsonResponse);
            // Add a timestamp
            activityReference.time = Time.time;

            // Get the Bot Service Answer
            StartCoroutine(GetResponseFromBot(activity));
        }
    }
}
```



## Receiving messages
Using Direct Line API 3.0, a client can receive messages from your bot either via WebSocket stream or by issuing HTTP GET requests. Using either of these techniques, a client may receive multiple messages from the bot at a time as part of an ActivitySet. For more information, see Receive activities from the bot.





## Conversation





## Message