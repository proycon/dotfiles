// ==UserScript==
// @name     PromoDead
// @description Kill reddit PROMOTED posts.
// @version  1
// @grant    none
// @include  https://www.reddit.com
// @include  https://www.reddit.com/
// @include  https://www.reddit.com/r/*
// @author   u/CodeLobe
// ==/UserScript==

// ---===] Configuration [===---

// Set false to stop after once.
var keepRemovingPosts = true;

// Seconds between sponcered post removal passes.
var removeDelaySeconds = 5;

// Set false to stop printing post removal stats to console.
var consoleRemovalLogs = true;

// When set true, the offending post will be bordered by red instead of removed.
// Useful when reddit changes its layout and this script needs an update.
var debugging = false;

// ---===] End of Config [===---


var intervalID = -1; // Allows us to stop removal passes.

// Main program loop.
function PromoDead()
{	var found = 0;
	var span = document.getElementsByTagName( "span" );
	for ( var i = 0; i < span.length; ++i )
	{	if ( span[ i ].innerHTML.match( "promoted" ) )
		{	// Found the PROMOTED span, get div 7 nested parents higher:
			var p = span[ i ];
			for ( var j = 0; j < 7; ++j ) p = p.parentElement;
			// Remove or set border red if in debug mode.
            p.style.visibility = "hidden";
			if ( debugging ) p.style.border = "2px solid red";
			else p.parentElement.removeChild( p );
			found++;
		}
	}
	if ( found && consoleRemovalLogs ) window.console.log( "PromoDead cured " + found + " reddit post" + (found > 1 ? "s." : ".") );
	if ( !keepRemovingPosts && intervalID >= 0 )
	{	window.top.clearInterval( intervalID );
		intervalID = -1;
	}
}

// Start curing reddit of promted posts.
PromoDead();
intervalID = window.top.setInterval( PromoDead, removeDelaySeconds * 1000 );
