charting.onFirefoxLoad = function(event) {
  var context_menu = document.getElementById("contentAreaContextMenu");
  var charting_end = document.getElementById("charting-end");
  
  for (tag in charting.tags) {
    var menu_item = createTagMenuItem(tag, charting.tags[tag]);
    context_menu.insertBefore(menu_item, charting_end);
  }

  //document.getElementById("contentAreaContextMenu")
  //        .addEventListener("popupshowing", function (e){ charting.showFirefoxContextMenu(e); }, false);
};

charting.showFirefoxContextMenu = function(event) {
  // show or hide the menuitem based on what the context menu is on
  //document.getElementById("context-charting").hidden = gContextMenu.onImage;
};

window.addEventListener("load", charting.onFirefoxLoad, false);

function createTagMenuItem(tagIndex, tagName) {
  const XUL_NS = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";
  var item = document.createElementNS(XUL_NS, "menuitem"); // create a new XUL menuitem
  item.setAttribute('id', 'tag-menu-item' + tagIndex);
  item.setAttribute('label', "Tag page with: " + tagName);
  item.setAttribute('oncommand', 'charting.note(' + tagIndex + ')');
  return item;
}

