---
title: How to install PlayFab into Unity
excerpt: 'Get started with the PlayFab Client library for C# in Unity. Follow steps to install the package before try out example code for a basic task.'
image: /assets/images/illustrations/cross-platform.jpeg
categories:
  - Deploy
tags:
  - PlayFab SDK
  - SDK
  - Unity
---
This quickstart helps you deploy PlayFab SDK before doing any API call in the Unity engine. Before continuing, make sure you have completed [Getting started for developers](https://docs.microsoft.com/en-us/gaming/playfab/personas/developer), which ensures you have a PlayFab account and are familiar with the PlayFab Game Manager.

## Download PlayFab SDK

Download the [PlayFab SDK for Unity](https://aka.ms/playfabunitysdkdownload) on your computer. Sources are available on [GitHub](https://github.com/PlayFab/UnitySDK)

> You can also use the Editor Extension package, but as this component only rely on the PlayFab Account Authentication and we want to manage this mechanism with our Corporate Azure AD Account, we will proceed manually.

## Install & Setup PlayFab SDK in Unity

  1. Open Unity Hub and Select **Create a new project**.
  2. Select **2D Template** and define your Project Name and location.

At this point, you have a blank project with only 1 scene store in your Asset Folder. 

### Deploy PlayFab SDK

From the Unity editor, go to **Assets** > **Import Package** > **Custom Package** and then select the downloaded PlayFabSDK package.

> If you already have an old SDK Version imported, you should delete the folder before to avoid any issue later on

### Configure PlayFab SDK

You have to define the Game Title that will host Player Authentication for your game. You will find [your Title ID](https://developer.playfab.com/en-US/my-games) on your Studio page

This can be done on 2 ways :

- Add `PlayFabSettings.TitleId = "YourTitleID";` somewhere in your code - or
- In your Unity Project tab, navigate to: **assets/PlayFabSDK/Shared/Public/Resources** and select the **PlayFabSharedSettings** and fill the Title Id field.<figure class="wp-block-image size-large is-style-default">

### Test your PlayFab SDK
To check the this import have been done well, you can follow