// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function startTimer() {
	alertTimerId    = setTimeout('refreshPage()', 100000);
}

function resetTimer() {
	clearTimeout ( alertTimerId );
  startTimer();
}

function refreshPage() {
	window.location.replace('/frontend');
}