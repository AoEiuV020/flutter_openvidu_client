#include "include/openvidu_client/openvidu_client_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "openvidu_client_plugin.h"

void OpenviduClientPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  openvidu_client::OpenviduClientPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
