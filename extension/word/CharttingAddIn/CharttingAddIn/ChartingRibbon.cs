using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using Office = Microsoft.Office.Core;
using System.Windows.Forms;
using Microsoft.Win32;

namespace CharttingAddIn
{
    [ComVisible(true)]
    public class ChartingRibbon : Office.IRibbonExtensibility
    {
        private Office.IRibbonUI ribbon;
        private ChartingAddIn addIn;
        private bool showLoginDetails = false;
        private bool[] selectedGoals = new bool[ChartingAddIn.MAX_GOALS];

        private string username = "";
        private string password = "";

        private string noteText = "";
        public string NoteText
        {
            get { return noteText; }
            set { noteText = value; }
        }

        private string docTitle = "";
        public string DocTitle
        {
            get { return docTitle; }
            set { docTitle = value; }
        }

        private string docURL = "";
        public string DocURL
        {
            get { return docURL; }
            set { docURL = value; }
        }

        public ChartingRibbon(ChartingAddIn addIn)
        {
            this.addIn = addIn;
        }

        public void invalidate()
        {
            ribbon.Invalidate();
        }

        public List<string> getSelectedGoals()
        {
            List<string> selectedGoalsList = new List<string>();
            for (int i = 0; i < ChartingAddIn.MAX_GOALS; i++) 
            {
                if (selectedGoals[i] && i < addIn.Goals.Count)
                {
                    selectedGoalsList.Add(addIn.Goals[i]);
                }
            }
            return selectedGoalsList;
        }

        #region IRibbonExtensibility Members

        public string GetCustomUI(string ribbonID)
        {
            return GetResourceText("CharttingAddIn.ChartingRibbon.xml");
        }

        #endregion

        #region Ribbon Callbacks
        public String GetSourceTitle(Office.IRibbonControl editbox)
        {
            return addIn.GetDocumentName();
        }
        public String GetSourceURL(Office.IRibbonControl editbox)
        {
            return addIn.GetDocumentPath();
        }
        public String GetNoteBody(Office.IRibbonControl editbox)
        {
            return addIn.GetSelection();
        }

        public void UpdateSourceTitle(Office.IRibbonControl editbox, string text)
        {
            docTitle = text;
        }
        public void UpdateSourceURL(Office.IRibbonControl editbox, string text)
        {
            docURL = text;
        }
        public void UpdateNoteBody(Office.IRibbonControl editbox, string text)
        {
            noteText = text;
        }

        public void UpdateUsername(Office.IRibbonControl editbox, string text)
        {
            username = text;
        }

        public void UpdatePassword(Office.IRibbonControl editbox, string text)
        {
            password = text;
        }

        public String Goal1Label(Office.IRibbonControl goalButton)
        {
            if (addIn.Goals.Count > 0)
            {
                return addIn.Goals[0];
            }
            else
            {
                return "";
            }
        }
        public String Goal2Label(Office.IRibbonControl goalButton)
        {
            if (addIn.Goals.Count > 1)
            {
                return addIn.Goals[1];
            }
            else
            {
                return "";
            }
        }
        public String Goal3Label(Office.IRibbonControl goalButton)
        {
            if (addIn.Goals.Count > 2)
            {
                return addIn.Goals[2];
            }
            else
            {
                return "";
            }
        }
        public String Goal4Label(Office.IRibbonControl goalButton)
        {
            if (addIn.Goals.Count > 3)
            {
                return addIn.Goals[3];
            }
            else
            {
                return "";
            }
        }

        public bool Goal1Visible(Office.IRibbonControl goalButton)
        {
            return addIn.Goals.Count > 0;
        }
        public bool Goal2Visible(Office.IRibbonControl goalButton)
        {
            return addIn.Goals.Count > 1;
        }
        public bool Goal3Visible(Office.IRibbonControl goalButton)
        {
            return addIn.Goals.Count > 2;
        }
        public bool Goal4Visible(Office.IRibbonControl goalButton)
        {
            return addIn.Goals.Count > 3;
        }

        public void FlipGoal1(Office.IRibbonControl goalButton, bool flip)
        {
            selectedGoals[0] = flip;
        }
        public void FlipGoal2(Office.IRibbonControl goalButton, bool flip)
        {
            selectedGoals[1] = flip;
        }
        public void FlipGoal3(Office.IRibbonControl goalButton, bool flip)
        {
            selectedGoals[2] = flip;
        }
        public void FlipGoal4(Office.IRibbonControl goalButton, bool flip)
        {
            selectedGoals[3] = flip;
        }

        public void ShowLogin(Office.IRibbonControl loginButton)
        {
            showLoginDetails = true;
            ribbon.Invalidate();
        }

        public void Login(Office.IRibbonControl loginSubmitButton)
        {
            try
            {
                string apiKey = ChartingXMLAPI.Login(username, password);

                addIn.ApiKey = apiKey;
                Registry.SetValue(ChartingAddIn.CHARTING_REGISTRY_PATH, "apiKey", apiKey);

                addIn.Username = username;
                Registry.SetValue(ChartingAddIn.CHARTING_REGISTRY_PATH, "username", username);

                addIn.LoadGoals();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error logging in: " + ex.Message);
            }
            showLoginDetails = false;
            ribbon.Invalidate();
        }

        public void Logout(Office.IRibbonControl logoutButton)
        {
            addIn.Logout();
        }

        public bool LogoutEnabled(Office.IRibbonControl logoutButton)
        {
            return addIn.Username != null;
        }

        public bool ShowNoteOptions(Office.IRibbonControl tab)
        {
            return addIn.Username != null;
        }

        public string LoggedInUser(Office.IRibbonControl logginLabel)
        {
            if (addIn.Username == null)
            {
                return "Please log in.";
            }
            else
            {
                return "Logged in as " + addIn.Username;
            }
        }

        public bool ShowLoginDetails(Office.IRibbonControl loginDetailsGroup)
        {
            return showLoginDetails;
        }

        public void PostNote(Office.IRibbonControl postNoteButton)
        {
            try
            {
                addIn.PostNote();
            }
            catch (Exception e)
            {
                MessageBox.Show("Error posting note: " + e.Message);
            }
        }

        public void Ribbon_Load(Office.IRibbonUI ribbonUI)
        {
            this.ribbon = ribbonUI;
        }

        #endregion

        #region Helpers

        private static string GetResourceText(string resourceName)
        {
            Assembly asm = Assembly.GetExecutingAssembly();
            string[] resourceNames = asm.GetManifestResourceNames();
            for (int i = 0; i < resourceNames.Length; ++i)
            {
                if (string.Compare(resourceName, resourceNames[i], StringComparison.OrdinalIgnoreCase) == 0)
                {
                    using (StreamReader resourceReader = new StreamReader(asm.GetManifestResourceStream(resourceNames[i])))
                    {
                        if (resourceReader != null)
                        {
                            return resourceReader.ReadToEnd();
                        }
                    }
                }
            }
            return null;
        }

        #endregion
    }
}
