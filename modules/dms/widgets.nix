{ delib, ... }:
delib.module {
  name = "osa.de.dms";

  myconfig.ifEnabled =
    { myconfig, ... }:
    let
      transparency = myconfig.osa.ui.transparency;
      frameRounding = myconfig.osa.ui.frameRounding;
    in
    {
      osa.de.dms.settings = {
        notificationHistoryEnabled = false;
        notificationOverlayEnabled = true;
        notificationFocusedMonitor = true;
        lockScreenNotificationMode = 1;

        notificationTimeoutCritical = 15000;
        notificationShowTimeoutBar = true;

        updaterHideWidget = true;
        workspaceOccupiedColorMode = "secondaryContainer";
        workspaceUnfocusedColorMode = "schh";

        controlCenterWidgets = [
          {
            enabled = true;
            id = "volumeSlider";
            width = 50;
          }
          {
            enabled = true;
            id = "brightnessSlider";
            width = 50;
          }
          {
            enabled = true;
            id = "wifi";
            width = 50;
          }
          {
            enabled = true;
            id = "bluetooth";
            width = 50;
          }
          {
            enabled = true;
            id = "audioOutput";
            width = 50;
          }
          {
            enabled = true;
            id = "audioInput";
            width = 50;
          }
          {
            enabled = true;
            id = "darkMode";
            width = 50;
          }
          {
            enabled = true;
            id = "nightMode";
            width = 50;
          }
          {
            enabled = true;
            id = "plugin_dankKDEConnect";
            width = 50;
          }
        ];

        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 3;
            screenPreferences = [ "all" ];
            showOnLastDisplay = true;
            leftWidgets = [
              "launcherButton"
              {
                enabled = true;
                id = "systemTray";
              }
            ];
            centerWidgets = [
              {
                enabled = true;
                id = "workspaceSwitcher";
              }
            ];
            rightWidgets = [
              {
                id = "keyboard_layout_name";
                enabled = true;
                keyboardLayoutNameCompactMode = false;
              }
              {
                id = "battery";
                enabled = true;
              }
              {
                id = "volumeMixer";
                enabled = true;
              }
              {
                id = "controlCenterButton";
                enabled = true;
              }
              {
                id = "clock";
                enabled = true;
                clockCompactMode = true;
              }
            ];
            autoHide = false;
            autoHideDelay = 250;
            borderColor = "surfaceText";
            borderEnabled = false;
            borderOpacity = 0.39;
            borderThickness = 1;
            bottomGap = 0;
            clickThrough = false;
            fontScale = 1;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = frameRounding;
            gothCornersEnabled = false;
            iconScale = 1;
            innerPadding = 4;
            maximizeDetection = true;
            maximizeWidgetIcons = false;
            maximizeWidgetText = false;
            noBackground = true;
            openOnOverview = true;
            popupGapsAuto = true;
            popupGapsManual = 5;
            removeWidgetPadding = false;
            scrollXBehavior = "column";
            scrollYBehavior = "workspace";
            shadowIntensity = 0;
            spacing = 0;
            squareCorners = true;
            inherit transparency;
            visible = true;
            widgetOutlineColor = "primary";
            widgetOutlineEnabled = false;
            widgetPadding = 8;
            widgetTransparency = transparency;
          }
        ];
      };
    };
}
