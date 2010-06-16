charting.onFirefoxLoad = function(event) {
  charting.loadGoals();
};

window.addEventListener("load", charting.onFirefoxLoad, false);

function createTagMenuItem(goalIndex, goalName) {
  const XUL_NS = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";
  var item = document.createElementNS(XUL_NS, "menuitem"); // create a new XUL menuitem
  item.setAttribute('id', 'goal-menu-item-' + goalIndex);
  item.setAttribute('label', "Tag page with: " + goalName);
  item.setAttribute('oncommand', 'charting.note(' + goalIndex + ')');
  return item;
}

