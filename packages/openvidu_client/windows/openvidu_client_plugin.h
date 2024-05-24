#ifndef FLUTTER_PLUGIN_OPENVIDU_CLIENT_PLUGIN_H_
#define FLUTTER_PLUGIN_OPENVIDU_CLIENT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace openvidu_client {

class OpenviduClientPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  OpenviduClientPlugin();

  virtual ~OpenviduClientPlugin();

  // Disallow copy and assign.
  OpenviduClientPlugin(const OpenviduClientPlugin&) = delete;
  OpenviduClientPlugin& operator=(const OpenviduClientPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace openvidu_client

#endif  // FLUTTER_PLUGIN_OPENVIDU_CLIENT_PLUGIN_H_
