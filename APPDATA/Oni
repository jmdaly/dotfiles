"use strict";
exports.__esModule = true;
exports.activate = function (oni) {
    console.log("config activated");
    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind("<c-enter>", function () { return console.log("Control+Enter was pressed"); });
    oni.input.unbind("<c-p>");
    oni.input.bind("<c-k>", "quickOpen.show");
};
exports.deactivate = function (oni) {
    console.log("config deactivated");
};
exports.configuration = {
    "activate": exports.activate,
    //add custom config here, such as
    "ui.colorscheme": "nord",
    "oni.useDefaultConfig": true,
    "oni.bookmarks": ["c:\\GitRepos\\WebAdmin", "c:\\GitRepos\\IQscript"],
    //"oni.loadInitVim": "C:\\Users\\mrussell\\dotfiles\\vimrc",
    "editor.completions.mode": "native",
    "autoClosingPairs.enabled": false,
    "sidebar.default.open": false,
    //"editor.fontSize": "12px",
    //"editor.fontFamily": "Monaco",
    // UI customizations
    "ui.animations.enabled": true,
    "ui.fontSmoothing": "auto"
};
