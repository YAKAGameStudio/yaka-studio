---
title: LoginWithCustomID in C# Console
excerpt: Get started with the PlayFab Client library for C# on Authentication mechanism discovery step-by-step within a Console.
image: /assets/images/illustrations/identity.jpeg
categories:
  - Authentication
tags:
  - PlayFab
  - Unity
  - Console
  - LoginWithCustomID
github: https://github.com/YAKAGameStudio/playfab-authentication
---
Get started with the `PlayFab Client library` for C# on the `LoginWithCustomID` authentication mechanism. 

We will first perform some tests with a basic structure, then implement [LoginWithCustomID in Unity](2021-03-18-loginwithcustomid-unity.md) and at least perform the same in an MVC ASP.Net Core Website.

This quickstart helps you make your PlayFab API call in the using the Client library for C#. 
Before continuing, make sure you have a PlayFab account and are familiar with the PlayFab Game Manager.

If you need an overview about solutions, check [Player Authentication mechanisms in PlayFab](2021-02-23-player-authentication-mechanisms.md)

> You can found the full code on [GitHub]({{ github }})

## Requirements

  * A PlayFab developer account.
  * An [installation of Visual Studio](https://visualstudio.microsoft.com/).

## C# Console

This guide provides the minimum steps required to make your first PlayFab API call. Confirmation is done via a console print.

  1. Open Visual Studio and Select **Create a new project**.
  2. Select **Console App (.Net Core)** for C#.
  3. Install NuGet package for **PlayFabAllSDK**. For instructions, see [Install and use a package in Visual Studio](https://docs.microsoft.com/en-us/nuget/quickstart/install-and-use-a-package-in-visual-studio).

![Install PlayFab SDK with NuGet Package](/assets/images/screenshots/loginwithcustomid-console-nuget.png "Visual Studio NuGet Package Manager"){:class="img-fluid"}

At this point, you should be able to successfully compile the project. The output window should contain something like the following example.

```console
Build started: Project: ConsoleAuthentication, Configuration: Debug Any CPU
ConsoleAuthentication-> c:\Learn\Authentication\Console\bin\Debug\ConsoleAuthentication.exe
========== Build: 1 succeeded, 0 failed, 0 up-to-date, 0 skipped ==========
```

### Set up your LoginWithCustomID Authentication Call

Your new project contain a file called Program.cs, which was created automatically by Visual Studio. Open that file, and add the code in the example shown below. You want to go through the final step ? check this file on GitHub

> For this demo, all code lines will stay into the Program.cs file. We will see later how to structure the authentication class

#### Setup PlayFab Title

PlayFab API is scoped by game. When the call is initiated, the request is sent to: `https://titleId.playfabapi.com/Client/LoginWithCustomID`. So you need to setup the Game Title you are working on. 

```csharp
static void Main(string[] args)
{
  // Provide your titleId from PlayFab Game Manager
  PlayFabSettings.staticSettings.TitleId = "titleId";

  // Wait for the user to respond before closing.
  Console.WriteLine("Done! Press any key to close");

  Console.ReadKey();
}
```

#### Initiate request header

When initiate your request, you should define how CustomID look like and behave.

```csharp
var LoginRequest = new LoginWithCustomIDRequest
{
   // Custom unique identifier for the user, use anything you want.
   CustomId = "ConsoleAuthentication",
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

### Call LoginWithCustomID with PlayFab API

You are ready to send your authentication request and catch the answer. In the Main Function, we add the following

```csharp
PlayFabClientAPI.LoginWithCustomIDAsync(LoginRequest)
  .ContinueWith(OnLoginCompleted)
  .Wait();
```
### Manage PlayFab answer

We create a new function (OnLoginCompleted) that will print confirmation of the API call using messages written to the console output.

```csharp
private static void OnLoginCompleted(Task<PlayFabResult<LoginResult>> loginTask)
 {
   	var apiError = loginTask.Result.Error;
   	var apiResult = loginTask.Result.Result;

   	var PlayerProfile = apiResult.InfoResultPayload.PlayerProfile;
   	var PlayerCurrencies = apiResult.InfoResultPayload.UserVirtualCurrency;

	if (apiError != null)
   	{
       // When Error Occur
       Console.WriteLine("Something went wrong with your API call :( Here's some debug information:");

       // Print issue with the PlayFabUtil class
       Console.WriteLine(PlayFabUtil.GenerateErrorReport(apiError));
       Console.WriteLine(apiError.GenerateErrorReport());
     }
     else
     {
       // Display Player information
       Console.WriteLine("Congratulations, you made a successful API call!");
       Console.WriteLine("Player information:");

       // Player Session
       Console.WriteLine("PlayFabId:           " + apiResult.PlayFabId);
       Console.WriteLine("SessionTicket:       " + apiResult.SessionTicket);
       // Player Activity
       Console.WriteLine("NewlyCreated:        " + apiResult.NewlyCreated);
       Console.WriteLine("LastLoginTime:       " + apiResult.LastLoginTime);

       // Information get with the LoginRequestParams
       if (PlayerProfile != null)
       { 
         // About GetPlayerProfile
         Console.WriteLine("We get the following information from GetPlayerProfile");
         Console.WriteLine("DisplayName:         " + PlayerProfile.DisplayName);
         Console.WriteLine("Created:             " + PlayerProfile.Created);
         Console.WriteLine("ValueToDateInUSD:    " + PlayerProfile.TotalValueToDateInUSD);
       }
       // About GetUserVirtualCurrency
       if (PlayerCurrencies != null)
       {
         Console.WriteLine("We get the following information from GetUserVirtualCurrency");
         Console.WriteLine("User Currencies own:       " + PlayerCurrencies.Count);

         foreach (var PlayerCurrency in PlayerCurrencies)
         {
           Console.WriteLine("---");
           Console.WriteLine("Currency:            " + PlayerCurrency.Key);
           Console.WriteLine("Value:               " + PlayerCurrency.Value);
         }
       }                
   }
 }
 ```

> You can extend the OnLoginCompleted with information requested with the LoginRequestParams. 
> You want to review the full code source or detect an issue? See [GitHub]({{ github }})