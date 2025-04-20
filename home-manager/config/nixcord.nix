{flake, ...}: {
  imports = [flake.inputs.nixcord.homeManagerModules.nixcord];

  programs.nixcord = {
    discord.openASAR.enable = false;

    config = {
      themeLinks = [
        "https://allpurposem.at/disblock/DisblockOrigin.theme.css"
      ];
      plugins = {
        accountPanelServerProfile.enable = true;
        alwaysTrust.enable = true;
        betterGifPicker.enable = true;
        betterSettings = {
          enable = true;
          disableFade = false;
        };
        biggerStreamPreview.enable = true;
        blurNSFW.enable = true;
        callTimer.enable = true;
        clearURLs.enable = true;
        colorSighted.enable = true;
        copyFileContents.enable = true;
        emoteCloner.enable = true;
        experiments = {
          enable = true;
          toolbarDevMenu = true;
        };
        fakeNitro = {
          enable = true;
          transformEmojis = false;
          transformStickers = false;
        };
        favoriteEmojiFirst.enable = true;
        favoriteGifSearch.enable = true;
        fixYoutubeEmbeds.enable = true;
        forceOwnerCrown.enable = true;
        friendsSince.enable = true;
        fullSearchContext.enable = true;
        fullUserInChatbox.enable = true;
        voiceDownload.enable = true;
        userVoiceShow.enable = true;
        spotifyShareCommands.enable = true;
        sendTimestamps.enable = true;
        messageLatency.enable = true;
        gifPaste.enable = true;
        imageZoom.enable = true;
        keepCurrentChannel.enable = true;
        memberCount = {
          enable = true;
          memberList = false;
        };
        mentionAvatars.enable = true;
        messageLinkEmbeds.enable = true;
        messageLogger.enable = true;
        moreCommands.enable = true;
        moreKaomoji.enable = true;
        mutualGroupDMs.enable = true;
        newGuildSettings = {
          enable = true;
          messages = "only@Mentions";
        };
        noF1.enable = true;
        noOnboardingDelay.enable = true;
        noPendingCount.enable = true;
        noTypingAnimation.enable = true;
        noUnblockToJump.enable = true;
        openInApp.enable = true;
        pinDMs.enable = true;
        previewMessage.enable = true;
        replyTimestamp.enable = true;
        serverInfo.enable = true;
        spotifyCrack.enable = true;
        summaries.enable = true;
        unsuppressEmbeds.enable = true;
        validReply.enable = true;
        validUser.enable = true;
        volumeBooster.enable = true;
        webScreenShareFixes.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };
}
