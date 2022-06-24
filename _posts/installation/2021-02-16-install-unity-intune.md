---
title: How to deploy Unity with Intune
excerpt: 'Learn how to deploy with Intune one the most widely used engines to develop Games and AR/VR applications: Unity'
image: /assets/images/illustrations/automation.jpeg
categories:
  - Deploy
tags:
  - Intune
  - Unity Editor
  - Unity Hub
---
Learn how to deploy with Intune one the most widely used engines to develop Games and AR/VR applications. Microsoft Intune can be the great way to deploy Unity to many computer / developer. You can configure, add, assign, protect, monitor, update, and retire apps easily while being remote. This will allow you to offer a seamless experience to your employee, or at least, be sure that everyone have the same installation.

> If you are not familiar with Intune App lifecycle, you can check https://docs.microsoft.com/en-us/mem/intune/apps/app-lifecycle

As Unity & Unity Hub are EXE format, you will have create a package then uploaded it to Intune cloud storage. Let see how to do that.

## Get materials and setup your workbench
  
### Get the sources
[Download Unity](https://unity3d.com/get-unity/download/archive) sources on your computer.

You need to get the **Unity Hub** and the **Unity Installer**. You should have `UnityHubSetup.exe` and `UnityDowloadAssistant-xxx.exe` files if you made done the right choice.

As exposed in [How to install Unity on Windows](2021-02-10-install-unity.md), you can have several release on your computer but have to choose the right one. When you have already a dev ongoing, you must have the same one on every computer.
    
### Setup Intune package environment

Use the **Microsoft Win32 Content Prep Tool** to pre-process the Unity Hub. This tool converts application installation files into the `.intunewin` format needed to deploy Win32 apps with Intune.
    
> You must be on Windows 10 to perform the following steps.
>
> For more information, see https://docs.microsoft.com/en-us/mem/intune/apps/apps-win32-prepare

1. Create the following folder structure on your computer (This is just the way I do this, you can create your own folder structure with your own names, just what best works for you.)
    - `C:\Intune\Apps`
    - `C:\Intune\Source`
2. Download the [Microsoft Win32 Content Prep Tool](https://go.microsoft.com/fwlink/?linkid=2065730)
3. Move the downloaded file (`IntuneWinAppUtil.exe`) file the `C:\Intune\` folder.

## Add Unity Hub to Intune

### Package the Unity Hub for Intune
1. Copy `UnityHubSetup.exe` to `C:\Intune\Sources`
2. Open a CMD or a PowerShell prompt and navigate to `C:\Intune\`
3. Run the IntuneWinAppUtil.exe command and fill in the following information:
    - Source folder: `C:\Intune\Sources`
    - Setup file: `UnityHubSetup.exe`
    - Output folder: `C:\Intune\Apps`

You should have a `unityhubsetup.intunewin` file in your `C:\Intune\Apps` folder

### Add the Unity Hub app in Intune

To add Unity Hub to your apps in Microsoft Intune, do the following:

1. Sign in to the [Microsoft Endpoint Manager admin center](https://go.microsoft.com/fwlink/?linkid=2109431).
2. Select **Apps** > **All apps** > **Add**.
3. In the **Select app type** pane, select **Windows app (Win32)**.
4. Upload your **unityhubsetup.intunewin** file and add the details needed to have Unity well found by your users. You can download logo from Unity on https://unity.com/brand
5. In the **Program** page, provide the following
    * Install Command: `UnityHubSetup.exe /S`
    * Uninstall Command: `"C:\Program Files\Unity Hub\Uninstall Unity Hub.exe" /S`
    * Install behavior: System
6. On the **Requirements** page, specify the requirements that devices must meet before the app is installed. At least 64-bit architecture and choose the latest Windows 10 version.
7. On the **Detection rules** page, configure the rules to detect the presence of the app:
    * Rules format: manually configure the detection rules then **click** +Add
    * Rule Type: `Registry`
    * Key path: `HKEY_LOCAL_MACHINE\Software\Unity Technologies\Hub`
    * Detection Method: `Key Exist`
8. Select the group assignments for the app.
9. Click **Next** to display the **Review + create** page. Review the values and settings you entered for the app.
10. When you are done, click **Create** to add the app to Intune.

The **Overview** blade of the app you've created is displayed.

> Curious to know more about deploying Win32 apps with Microsoft Intune ? 
>
> For more information, https://docs.microsoft.com/en-us/mem/intune/apps/apps-win32-add

## Add Unity Editor in Intune

In the same way you have done previously, we have to package Unity Editor and add this package to Intune.

### Download sources
1. Run the `UnityDowloadAssistant-xxx.exe` you downloaded at the first step.
2. Select components you want to include

> Note that you should deploy Visual Studio by your own or add sources to the Intune Sources on the next step

### Define sources location

Extract sources to the `C:\Intune\Sources` Folder

> Don’t forget to remove the Unity Hub you add previously in the Sources repository

Have a beer if you don’t have the proper Internet connection.

> This procedure will install Unity Editor on your computer as well as sources are extracted. The Unity install Folder is the root. Bellow will be create sub folders to host Editor and Module. I advice you to set the install folder to : `C:\Program Files\Unity\{YourVersion}`
>
> If you install 2 versions in the same folder, the latest installed win.

When finished, you will found in the Sources folder executables needed to install Unity Editor and a BAT File create for you. If you choose to Install Unity Editor only, the BAT file won’t be relevant.

### Package the Unity Hub for Intune
1. Run the IntuneWinAppUtil.exe command and fill in the following information:
    - Source folder: `C:\Intune\Sources`
    - Setup file: `UnitySetup64.exe`
    - Output folder: `C:\Intune\Apps`

### Add the Unity Editor app in Intune
Like in the Unity Hub step, you will fill the Intune wizard with the following

- On the **Program** page, provide the following
  - Install Command: `UnitySetup64.exe /S /D="C:\Program Files\Unity\{YourVersion}"`
  - Uninstall Command: `"C:\Program Files\Unity\{YourVersion}\Editor\Uninstall.exe" /S`
  - Install behavior: `System`

> If you select more than one component to install, you should rely on the `install.bat` file or create a new one to perform all components installation. You will have also to create an `Unistall.bat` file.

- On the **Requirements** page, specify the same requirements than for Unity Hub. You should also define that Unity Hub is install relying on **Configure additional requirement rules**
  - Requirement type: `Registry`
  - Key path: `HKEY_LOCAL_MACHINE\Software\Unity Technologies\Hub`
  - Value name: `InstallLocation`
  - Registry key requirement: `Key Exist`
- On the Detection rules page, configure the rules to detect the presence of the app:
  - Rules format: manually configure the detection rules then **click** +Add
  - Rule Type: `File`
  - Path: `"C:\Program Files\Unity\{YourVersion}\Editor\"`
  - File or folder: `Unity.exe`
  - Detection Method: `String (version)`
  - Operator: `Equals`
  - Value: `{YourVersion}`

## Conclusion

You now have Unity Hub and Unity Editor ready to be deployed and install by Intune to your developers. Depending the choices you made on the App Information, they can be display in the Company Portal for Self Services or will be pushed within the 30 next minutes.

If you have any comments, feel free to use the form bellow