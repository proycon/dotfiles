// ==UserScript==
// @name Twitter Hide Promoted Tweets
// @namespace com.schrauger.twitter.js
// @author Stephen Schrauger
// @description Hide promoted tweets on twitter.com
// @homepage https://github.com/schrauger/twitter-hide-promoted-tweets-userscript
// @include https://*.twitter.com/*
// @include https://twitter.com/*
// @version 1.0
// @grant none
// @downloadURL https://raw.githubusercontent.com/schrauger/twitter-hide-promoted-tweets-userscript/master/twitter_hide_promoted_tweets.user.js
// @updateURL   https://raw.githubusercontent.com/schrauger/twitter-hide-promoted-tweets-userscript/master/twitter_hide_promoted_tweets.user.js
// ==/UserScript==
/*jslint browser: true*/
/*global jQuery*/

jQuery(function () {
	jQuery("<style>")
	.prop("type", "text/css")
	.html("\
		li.has-profile-promoted-tweet, \
		div.suggested-tweet-stream-container {\
			display: none;\
		}")
	.appendTo("head");
});
