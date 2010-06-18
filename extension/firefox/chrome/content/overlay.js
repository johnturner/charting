var charting = {
  loadGoals: function() {
    var url = CHARTING_URL + "goals.json";
    var request = new XMLHttpRequest();
    var params="?user[key]=" + escape(Prefs.getCharPref("apiKey")) +
               "&user[name]=" + escape(Prefs.getCharPref("user"));
    request.open("GET", url+params, true);
    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        if (request.status == 200) {
          charting.removeGoalMenuItems();

          var goalsString = request.responseText;
          var goalsJSON = JSON.parse(goalsString);
          var goalsOut = [];
          for (var i in goalsJSON) {
            goalsOut[i] = goalsJSON[i].goal.name;
          }
          charting.goals = goalsOut;
          
          charting.addGoalMenuItems();
          document.getElementById('charting-label').label = "Charting: Ready";
        }
        else {
          document.getElementById('charting-label').label = "Charting: Failed to load goals.";
        }
      }
    }

    request.send(null);
  },

  loadAPIKey: function(e) {
    var url = CHARTING_URL + "api_key";
    var request = new XMLHttpRequest();
    request.open("GET", url, true);
    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        if (request.status == 200) {
          var info = JSON.parse(request.responseText);
          Prefs.setCharPref("apiKey", info.key);
          Prefs.setCharPref("user", info.user);
          document.getElementById('charting-label').label = "Charting: Loading goals...";
          charting.loadGoals();
        }
        else if (request.status == 401) {
          document.getElementById('charting-label').label = "Charting: Please log in to load API key.";
        }
        else {
          document.getElementById('charting-label').label = "Charting: Couldn't connect to Charting server.";
        }
      }
    }

    request.send(null);
  },

  verifyAPIKey: function(e) {
    var url = CHARTING_URL + "verify_api_key";
    var params = "?user[name]="+escape(Prefs.getCharPref("user")) +
                 "&user[key]="+escape(Prefs.getCharPref("apiKey"));
    var request = new XMLHttpRequest();
    request.open("GET", url+params, true);
    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        if (request.status == 200) {
          document.getElementById('charting-label').label = "Charting: Loading goals...";
          charting.loadGoals();
        }
        else {
          document.getElementById('charting-label').label = "Charting: Loading API key...";
          charting.loadAPIKey();
        }
      }
    }
    request.send(null);
  },

  addGoalMenuItems: function() {
    var context_menu = document.getElementById("contentAreaContextMenu");
    var charting_end = document.getElementById("charting-end");
    for (goal in charting.goals) {
      var menu_item = createGoalMenuItem(goal, charting.goals[goal]);
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
                "&note[goals][]=" + escape(charting.goals[goalIndex]) +
                "&source[location]=" + source_url +
                "&source[title]=" + source_title +
                "&source[doctype]=webpage" + 
                "&user[name]=" + escape(Prefs.getCharPref("user")) +
                "&user[key]=" + escape(Prefs.getCharPref("apiKey"));

    var request = new XMLHttpRequest();
    request.open("POST", CHARTING_URL + "notes.json", true);
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    request.setRequestHeader("Content-length", params.length);

    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        if (request.status == 201) {
          alert("Created note for " + charting.goals[goalIndex]);
        }
        else {
          alert("Failed to create note.");
        }
      }
    }

    request.send(params);
  },

  onToolbarOptionsButtonCommand: function(e) {
    alert("Options not implemented yet.");
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
    for (i in charting.goals) {
      var button = createGoalButton(i, charting.goals[i]);
      buttons.appendChild(button);
    }

    charting.noteWindow.document.getElementById('save-button').addEventListener('command', charting.noteFromWindow, false);
  },

  noteFromWindow: function(e) {
    var selectedGoals = [];
    
    var body = escape(charting.noteWindow.document.getElementById('page-description').value);
    var source_url = escape(charting.noteWindow.document.getElementById('page-url').value);
    var source_title = escape(charting.noteWindow.document.getElementById('page-title').value);

    var params= "note[body]=" + body +
                "&source[location]=" + source_url +
                "&source[title]=" + source_title +
                "&source[doctype]=webpage";

    for (var i in charting.goals) {
      var button = charting.noteWindow.document.getElementById('goal-button-' + i);
      if (button.getAttribute('checked')) {
        params += "&note[goals][]=" + charting.goals[i];
      }
    }

    var request = new XMLHttpRequest();
    request.open("POST", CHARTING_URL + "notes.json", true);
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    request.setRequestHeader("Content-length", params.length);

    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        if (request.status == 201) {
          charting.noteWindow.close();
        }
        else {
          alert("Failed to create note.");
        }
      }
    }

    request.send(params);
  }
  
};

window.addEventListener("load", charting.onLoad, false);
