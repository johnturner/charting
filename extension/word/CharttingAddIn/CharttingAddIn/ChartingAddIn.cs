using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using Word = Microsoft.Office.Interop.Word;
using Office = Microsoft.Office.Core;
using System.Windows.Forms;
using Microsoft.Win32;

namespace CharttingAddIn
{
    public partial class ChartingAddIn
    {
        public static string CHARTING_REGISTRY_PATH = "HKEY_CURRENT_USER\\Software\\Charting";
        public static int MAX_GOALS = 4;
        ChartingRibbon ribbon = null;
        private string username = null;
        private string apiKey = null;
        private List<String> goals = new List<String>();

        public List<String> Goals
        {
            get { return goals; }
            set { goals = value; }
        }

        public string Username
        {
            get { return username; }
            set { username = value; }
        }

        public string ApiKey
        {
            get { return apiKey; }
            set { apiKey = value; }
        }

        public void LoadGoals()
        {
            try
            {
                goals = ChartingXMLAPI.FetchGoals(username, apiKey);
            }
            catch (Exception e)
            {
                MessageBox.Show("Error loading goals: " + e.Message);
            }
            ribbon.invalidate();
        }

        public void PostNote()
        {
            ChartingXMLAPI.PostNote(ribbon.DocTitle, ribbon.DocURL, ribbon.NoteText, 
                                    ribbon.getSelectedGoals(), username, apiKey);
            MessageBox.Show("Note created.");
        }

        public void Logout()
        {
            username = null;
            apiKey = null;
            Registry.SetValue(ChartingAddIn.CHARTING_REGISTRY_PATH, "apiKey", "");
            Registry.SetValue(ChartingAddIn.CHARTING_REGISTRY_PATH, "username", "");
            ribbon.invalidate();
        }

        public String GetDocumentName()
        {
            return this.Application.ActiveDocument.Name;
        }

        public String GetDocumentPath()
        {
            return this.Application.ActiveDocument.Path;
        }

        public String GetSelection()
        {
            return this.Application.Selection.Range.Text;
        }

        private void ThisAddIn_Startup(object sender, System.EventArgs e)
        {
            this.Application.DocumentChange += 
                new Word.ApplicationEvents4_DocumentChangeEventHandler(DocumentChange);
            this.Application.WindowSelectionChange += 
                new Word.ApplicationEvents4_WindowSelectionChangeEventHandler(WindowSelectionChange);
            Office.CommandBarControls controls = this.Application.CommandBars["Text"].Controls;

            username = (string)Registry.GetValue(CHARTING_REGISTRY_PATH, "username", "");
            apiKey = (string)Registry.GetValue(CHARTING_REGISTRY_PATH, "apiKey", "");

            if (username == "") username = null;
            if (apiKey == "") apiKey = null;

            if (username != null && apiKey != null)
            {
                LoadGoals();
            }

            //object m = Type.Missing;
            //Office.CommandBarButton goal1Button = (Office.CommandBarButton)controls.Add(Office.MsoControlType.msoControlButton, m, m,m,m);
            //goal1Button.Caption = "Hello";
        }

        void WindowSelectionChange(Microsoft.Office.Interop.Word.Selection Sel)
        {
            ribbon.invalidate();
        }

        private void ThisAddIn_Shutdown(object sender, System.EventArgs e)
        {
        }

        private void DocumentChange()
        {
            ribbon.invalidate();
        }

        protected override Office.IRibbonExtensibility CreateRibbonExtensibilityObject()
        {
            ribbon = new ChartingRibbon(this);
            return ribbon;
        }

        #region VSTO generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InternalStartup()
        {
            this.Startup += new System.EventHandler(ThisAddIn_Startup);
            this.Shutdown += new System.EventHandler(ThisAddIn_Shutdown);
        }
        
        #endregion
    }
}
