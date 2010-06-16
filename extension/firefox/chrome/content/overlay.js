var charting = {
  tags: ["tag1", "tag2", "tag3"],
  
  onLoad: function() {
    // initialization code
    this.initialized = true;
    this.strings = document.getElementById("charting-strings");
  },

  note: function(tagIndex) {
    alert(this.tags[tagIndex]);
    var AJAX = new window.XMLHttpRequest();
    if (AJAX) {
      AJAX.open("GET", "http://norgg.org:1234", false);
      AJAX.send(null);
      alert(AJAX.responseText);
    } else {
      alert("fail");
    }
  },

  onToolbarButtonCommand: function(e) {
    // just reuse the function above.  you can change this, obviously!
    charting.onMenuItemCommand(e);
  }
};

window.addEventListener("load", charting.onLoad, false);
