// browser
user_pref("browser.nova.enabled", false);
user_pref("browser.theme.waterfox.browserStyle", "proton");
user_pref("browser.warnOnQuit", false);
user_pref("signon.rememberSignons", false);
user_pref("userChrome.autohide.forward_button", false);
user_pref("waterfox.blocker.ui.enabled", false);

// disable welcome screen
user_pref("browser.aboutwelcome.enabled", false);
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");

// Allow extensions installed in the profile folder to run
user_pref("extensions.autoDisableScopes", 0);

// search engine
user_pref("browser.search.separatePrivateDefault", false);

// Tab Sidebar
user_pref("sidebar.verticalTabs", true);

// new tab page
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);

// URL Bar
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.recentsearches", false);
user_pref("browser.urlbar.suggest.remotetab", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.trending", false);

// Scrolling
user_pref("apz.overscroll.enabled", false);
