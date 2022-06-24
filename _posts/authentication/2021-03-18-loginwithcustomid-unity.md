---
title: LoginWithCustomID in Unity
excerpt: Get started with the PlayFab Client library for Unity on Authentication mechanism discovery step-by-step.
image: /assets/images/illustrations/cross-platform.jpeg
categories:
  - Authentication
tags:
  - LoginWithCustomID
  - PlayFab
  - Unity
github: https://github.com/YAKAGameStudio/playfab-authentication
---
Get started with the PlayFab Client library for Unity on Authentication mechanism discovery. 

We will first perform some test with a basic structure, then move to a more complete approach for mobile devices and perform the same in an MVC ASP.Net Core Website.

This quickstart helps you make your PlayFab API call in the using the Client library for C# in Unity. Before continuing, make sure you have a PlayFab account and are familiar with the PlayFab Game Manager. You can also review how to [manage authentication in C# Console](2021-02-23-loginwithcustomid-console.md)

If you need an overview about solutions, check [Player Authentication mechanisms in PlayFab](2021-02-23-player-authentication-mechanisms.md)

> You can found the full code on [YAKAGameStudio/playfab-authentication]({{ github }})

## Requirements

- A PlayFab developer account
- An [installation of Visual Studio](https://visualstudio.microsoft.com/)
- An [installation of Unity](2021-02-10-install-unity.md)

## Download & Install PlayFab SDK

Follow [How to install PlayFab into Unity](2021-03-15-install-playfab-unity.md) setup the prerequisites

### Set up your Authentication Call

You want to go through the final step ? check this file on GitHub

  1. In Create a new **Game Object**, and rename it to PlayFab.
  2. In the **Assets** window, Right-click and select **Create** > **C# Script**. Name the script **GetStarted**.
  3. Add it to the Game Object as shown on the picture below.
  4. Double-click the file to open it in a code-editor. 
  5. In your code editor, replace the contents of **GetStarted**.cs with the code shown below and save the file.

> For this demo, all code lines will stay into the GetStarted.cs file. We will see later how to structure the authentication class

#### Initiate request header

To initiate your request, you should define how CustomID look like and behave.

```csharp
var LoginRequest = new LoginWithCustomIDRequest
{
	// Your Title setup in PlayFab SDK
    TitleId = PlayFabSettings.TitleId,
   // Custom unique identifier for the user, use anything you want.
   CustomId = SystemInfo.deviceUniqueIdentifier,
   // Automatically create a PlayFab account if one is not currently linked to this ID.
   CreateAccount = true,
   // Request additional Information
   InfoRequestParameters = LoginRequestParams
};
```

You can also request additional information on login to initialize your game or your player profile.

> For more information see : [getplayercombinedinforequestparams](https://docs.microsoft.com/en-us/rest/api/playfab/client/authentication/loginwithcustomid?view=playfab-rest#getplayercombinedinforequestparams)

```csharp
var LoginRequestParams = new GetPlayerCombinedInfoRequestParams
{
   GetPlayerProfile = true,
   GetUserVirtualCurrency = true
};
```

### Call PlayFab API

You are ready to send your authentication request and catch the answer.

```csharp
PlayFabClientAPI.LoginWithCustomID(LoginRequest, OnLoginSuccess, OnLoginError);
```

### Manage PlayFab answer

We create 2 new functions that will print confirmation of the API call using messages written to the console output.

```csharp
private void OnLoginSuccess(LoginResult result)
{
  Debug.Log("Congratulation, you are authenticated");
  Debug.LogFormat("Login Success: {0}", result.PlayFabId);
  Debug.LogFormat("Session: {0}", result.SessionTicket);
}

private void OnLoginError(PlayFabError error)
{
  Debug.LogWarning("Something went wrong with your first API call.  :(");
  Debug.LogError("Here's some debug information:");
  Debug.LogError(error.GenerateErrorReport());
}
```

> You can extend the OnLoginSuccess with information requested with the LoginRequestParams. 

You want to review the full code source or detect an issue?

## Success
If you follow this step-by-step to perform LoginWithCustomID in Unity, you should have the following in your Unity Console