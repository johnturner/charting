const XUL_NS = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";
const CHARTING_URL = "http://charting.mhnltd.co.uk/";
//const CHARTING_URL = "http://localhost:3000/";
var Prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService);
Prefs = Prefs.getBranch("extensions.charting.");

charting.onFirefoxLoad = function(e) {
  charting.verifyAPIKey();
  var appcontent = document.getElementById("appcontent");
  if(appcontent) {
    appcontent.addEventListener("DOMContentLoaded", charting.onPageLoad, true);
  }
};

charting.onPageLoad = function(e) {
}

window.addEventListener("load", charting.onFirefoxLoad, false);

function createGoalMenuItem(goalIndex, goalName) {
  var item = document.createElementNS(XUL_NS, "menuitem");
  item.setAttribute('id', 'goal-menu-item-' + goalIndex);
  item.setAttribute('label', "Tag page with: " + goalName);
  item.addEventListener('command', function(){charting.note(goalIndex);}, false)
  return item;
}

function createGoalButton(goalIndex, goalName) {
  var item = document.createElementNS(XUL_NS, "checkbox");
  item.setAttribute('id', 'goal-button-' + goalIndex);
  item.setAttribute('label', goalName);
  item.setAttribute('class', 'goal-button');
  return item;
}
