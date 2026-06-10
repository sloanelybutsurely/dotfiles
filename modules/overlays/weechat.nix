final: prev: {
  weechat = prev.weechat.override {
    configure = { availablePlugins, ... }: {
      scripts = with prev.weechatScripts; [
        wee-slack
        weechat-go
        weechat-autosort
        edit
      ];

      plugins = builtins.attrValues (builtins.removeAttrs availablePlugins [ "php" ]);
    };
  };

  customWeechat = final.weechat;
}
