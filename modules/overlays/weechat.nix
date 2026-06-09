final: prev: {
  weechat = prev.weechat.override {
    configure = { availablePlugins, ... }: {
      scripts = with prev.weechatScripts; [
        wee-slack
      ];
    };
  };

  customWeechat = final.weechat;
}
