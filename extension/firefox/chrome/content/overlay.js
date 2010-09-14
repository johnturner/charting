var charting = {
  rootURL: function() {
    return Prefs.getCharPref("url") + "/";
  },

  loadGoals: function() {
    var url = charting.rootURL() + "goals.json";
    var request = new XMLHttpRequest();
    var params="?user[key]=" + escape(Prefs.getCharPref("apiKey")) +
               "&user[name]=" + escape(Prefs.getCharPref("user"));
    request.open("GET", url+params, true);
    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        eval(request.responseText);
      }
    }
    
    request.send(null);
  },
  
  //Callback called from JSONP 
  goals: function(goalArray) {
    charting.removeGoalMenuItems();

    var goalsOut = [];

    for (var i in goalArray) {
      goalsOut[i] = goalArray[i].goal.name;
    }
    charting.userGoals = goalsOut;
    
    charting.addGoalMenuItems();
    document.getElementById('charting-label').label = "Charting: Ready";
  },

  goals_error: function(message) {
    document.getElementById('charting-label').label = "Charting: Failed to load goals: " + message;
  },

  loadAPIKey: function(e) {
    var url = charting.rootURL() + "api_key";
    var request = new XMLHttpRequest();
    request.open("GET", url, true);
    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        eval(request.responseText);
      }
    }

    request.send(null);
  },

  api_key: function(info) {
    Prefs.setCharPref("apiKey", info.key);
    Prefs.setCharPref("user", info.user);
    document.getElementById('charting-label').label = "Charting: Loading goals...";
    charting.loadGoals();
  },

  api_key_error: function(message) {
    document.getElementById('charting-label').label = "Charting: Couldn't load API key: " + message;
  },

  verifyAPIKey: function(e) {
    var url = charting.rootURL() + "verify_api_key";
    var params = "?user[name]="+escape(Prefs.getCharPref("user")) +
                 "&user[key]="+escape(Prefs.getCharPref("apiKey"));
    var request = new XMLHttpRequest();
    request.open("GET", url+params, true);
    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        eval(request.responseText);
      }
    }
    request.send(null);
  },

  key_verified: function(message) {
    document.getElementById('charting-label').label = "Charting: Loading goals...";
    charting.loadGoals();
  },

  key_invalid: function(message) {
    document.getElementById('charting-label').label = "Charting: Loading API key...";
    charting.loadAPIKey();
  },

  addGoalMenuItems: function() {
    var context_menu = document.getElementById("contentAreaContextMenu");
    var charting_end = document.getElementById("charting-end");
    for (goal in charting.userGoals) {
      var menu_item = createGoalMenuItem(goal, charting.userGoals[goal]);
      context_menu.insertBefore(menu_item, charting_end);
    }
  },

  removeGoalMenuItems: function() {
    for (i in this.goals) {
      var menuItem = document.getElementById('goal-menu-item-' + i);
      if (menuItem != null) {
        menuItem.parentNode.removeChild(menuItem);
      }
    }
  },

  onLoad: function() {
    // initialization code
    this.initialized = true;
    this.strings = document.getElementById("charting-strings");
  },

  note: function(goalIndex) {
    var selection = escape(content.window.getSelection());
    var source_url = escape(content.window.location.toString());
    var source_title = escape(content.document.title);

    var params= "note[body]=" + selection +
                "&note[goals][]=" + escape(charting.userGoals[goalIndex]) +
                "&source[location]=" + source_url +
                "&source[title]=" + source_title +
                "&source[doctype]=webpage" + 
                "&user[name]=" + escape(Prefs.getCharPref("user")) +
                "&user[key]=" + escape(Prefs.getCharPref("apiKey"));

    var request = new XMLHttpRequest();
    request.open("POST", charting.rootURL() + "notes.json", true);
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    request.setRequestHeader("Content-length", params.length);

    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        alert(request.responseText);
        eval(request.responseText);
      }
    }

    request.send(params);
  },

  note_success: function(noteObj) {
    alert("Created note.");
    if (charting.noteWindow != null) {
      charting.noteWindow.close();
    }
  },

  note_error: function(message) {
    alert("Error creating note: " + message);
  },

  onToolbarOptionsButtonCommand: function(e) {
    var features = "chrome,titlebar,toolbar,centerscreen,modal";
    window.openDialog("chrome://charting/content/preferences.xul", "Preferences", features);
  },

  onToolbarNoteButtonCommand: function(e) {
    charting.noteWindow = window.open("chrome://charting/content/note-window.xul", "note-window", "chrome");
    charting.noteWindow.addEventListener("load", charting.onLoadNoteWindow, false);
  },

  onLoadNoteWindow: function(e) {
    charting.noteWindow.document.getElementById('page-url').value=content.window.location.toString();
    charting.noteWindow.document.getElementById('page-title').value=content.document.title;
    charting.noteWindow.document.getElementById('page-description').value=content.window.getSelection().toString();

    //Add buttons for each goal.
    var buttons = charting.noteWindow.document.getElementById("charting-goal-buttons");
    for (i in charting.userGoals) {
      var button = createGoalButton(i, charting.userGoals[i]);
      buttons.appendChild(button);
    }

    charting.noteWindow.document.getElementById('save-button').addEventListener('command', charting.noteFromWindow, false);
  },

  noteFromWindow: function(e) {
    var url = charting.rootURL() + "notes.json";
    var selectedGoals = [];
    
    var body = escape(charting.noteWindow.document.getElementById('page-description').value);
    var source_url = escape(charting.noteWindow.document.getElementById('page-url').value);
    var source_title = escape(charting.noteWindow.document.getElementById('page-title').value);

    var params= "note[body]=" + body +
                "&source[location]=" + source_url +
                "&source[title]=" + source_title +
                "&source[doctype]=webpage" +
                "&user[name]=" + escape(Prefs.getCharPref("user")) +
                "&user[key]=" + escape(Prefs.getCharPref("apiKey"));

    for (var i in charting.userGoals) {
      var button = charting.noteWindow.document.getElementById('goal-button-' + i);
      if (button.getAttribute('checked')) {
        params += "&note[goals][]=" + charting.userGoals[i];
      }
    }

    var request = new XMLHttpRequest();
    request.open("POST", url, true);
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    request.setRequestHeader("Content-length", params.length);
    
    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        eval(request.responseText);
      }
    }
    
    request.send(params);
  }
};

window.addEventListener("load", charting.onLoad, false);
