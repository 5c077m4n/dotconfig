/* override recipe: enable DRM and let me watch videos ***/
//user_pref("media.gmp-widevinecdm.enabled", true); // 2021 default-inactive in user.js
user_pref("media.eme.enabled", true); // 2022

/* override recipe: enable session restore ***/
user_pref("browser.startup.page", 3); // 0102
user_pref("browser.privatebrowsing.autostart", false); // 0110 required if you had it set as true
user_pref("places.history.enabled", true); // 0862 required if you had it set as false
user_pref("browser.sessionstore.privacy_level", 0); // 1003 [to restore cookies/formdata if not sanitized]
//user_pref("network.cookie.lifetimePolicy", 0); // 2801 [DON'T: add cookie + site data exceptions instead]
user_pref("privacy.clearOnShutdown.history", false); // 2811
user_pref("privacy.clearOnShutdown.cookies", false); // 2811 optional: default false arkenfox v94
user_pref("privacy.clearOnShutdown.formdata", false); // 2811 optional
user_pref("privacy.cpd.history", false); // 2812 to match when you use Ctrl-Shift-Del
user_pref("privacy.cpd.cookies", false); // 2812 optional: default false arkenfox v94
//user_pref("privacy.cpd.formdata", false); // 2812 optional

/* override-recipe: desktop: alter new window max sizes **/
user_pref("privacy.window.maxInnerWidth", 4502); // 4502 [default 1600 in user.js v95]
user_pref("privacy.window.maxInnerHeight", 4502);  // 4502 [default 900 in user.js v95]

/* override recipe: enable web conferencing: Google Meet | JitsiMeet | BigBlueButton | Zoom | Discord ***/
// OPTIONAL
// some sites, e.g. Zoom, need a canvas site exception if using RFP [Right Click>View Page Info>Permissions]
//user_pref("media.autoplay.blocking_policy", 0); // 2031 optional [otherwise add site exceptions]
//user_pref("webgl.disabled", false); // 4520 optional [required for Zoom]

// RESET these - all now inactive or removed from user.js
// ^ except media.peerconnection.ice.no_host can be used to harden if it works for you
//user_pref("media.peerconnection.enabled", true); // 2001 default-inactive in user.js 95
//user_pref("media.peerconnection.ice.no_host", false); // 2004 default-inactive in user.js 95
user_pref("javascript.options.wasm", true); // 5506 default-inactive in user.js v91
//user_pref("dom.webaudio.enabled", true); // 8001 default-inactive in user.js v90
//user_pref("media.getusermedia.screensharing.enabled", true); // removed from user.js v91
