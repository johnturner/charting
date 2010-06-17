const XUL_NS = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";
const CHARTING_URL = "http://charting.mhnltd.co.uk/";

charting.onFirefoxLoad = function(event) {
  charting.loadGoals();
};

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
