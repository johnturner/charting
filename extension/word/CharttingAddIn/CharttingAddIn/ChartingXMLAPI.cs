using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Web;
using System.Xml;
using System.Windows.Forms;

namespace CharttingAddIn
{
    class ChartingXMLAPI
    {
        private static string BASE_URL = "http://charting.mhnltd.co.uk/";
        private static string LOGIN_URL = BASE_URL + "api_key.xml";
        private static string GOALS_URL = BASE_URL + "goals.xml";
        private static string CREATE_NOTE_URL = BASE_URL + "notes.xml";

        /**
         * Logs the user in and returns the API key.
         */
        public static string Login(string username, string password)
        {
            string apiKey = "";
            Dictionary<string, string> loginDetails = new Dictionary<string,string>();
            loginDetails["login[username]"] = username;
            loginDetails["login[password]"] = password;


            XmlDocument apiKeyXml = post(LOGIN_URL, dictToParams(loginDetails));

            apiKey = apiKeyXml.GetElementsByTagName("api-key").Item(0).InnerText;

            return apiKey;
        }

        public static List<string> FetchGoals(string username, string apiKey)
        {
            List<string> goals = new List<string>();
            Dictionary<string, string> loginDetails = new Dictionary<string,string>();
            loginDetails["user[name]"] = username;
            loginDetails["user[key]"] = apiKey;

            XmlDocument goalsXml = get(GOALS_URL, dictToParams(loginDetails));
            foreach (XmlNode node in goalsXml.GetElementsByTagName("goal"))
            {
                goals.Add(node.InnerText);
            }
            return goals;
        }

        public static void PostNote(string title, string location, string noteBody,
                                    List<string> goals,
                                    string username, string apiKey)
        {
            Dictionary<string, string> noteParams = new Dictionary<string, string>();
            noteParams["note[body]"] = noteBody;
            noteParams["source[location]"] = location;
            noteParams["source[title]"] = title;
            noteParams["source[doctype"] = "msword";
            noteParams["user[name]"] = username;
            noteParams["user[key]"] = apiKey;

            string paramsString = dictToParams(noteParams);

            foreach (string goal in goals)
            {
                paramsString += "note[goals][]=" +
                                HttpUtility.UrlEncode(goal) + "&";
            }
            post(CREATE_NOTE_URL, paramsString);
        }

        private static XmlDocument get(string url, string getParams) 
        {
            WebRequest request = WebRequest.Create(url + "?" + getParams);
            request.Method = "GET";
            WebResponse response = request.GetResponse();
            XmlDocument doc = new XmlDocument();
            doc.Load(response.GetResponseStream());
            return doc;
        }

        private static XmlDocument post(string url, string postParams)
        {
            WebRequest request = WebRequest.Create(url);
            request.Method = "POST";

            byte[] postParamsArray = new UTF8Encoding().GetBytes(postParams);
            request.ContentType = "application/x-www-form-urlencoded";
            request.ContentLength = postParamsArray.Length;
            Stream paramsStream = request.GetRequestStream();
            paramsStream.Write(postParamsArray, 0, postParamsArray.Length);

            WebResponse response = request.GetResponse();
            XmlDocument doc = new XmlDocument();
            doc.Load(response.GetResponseStream());
            return doc;
        }

        private static string dictToParams(Dictionary<string, string> dict)
        {
            string paramsString = "";
            foreach (KeyValuePair<string, string> kvp in dict)
            {
                paramsString += HttpUtility.UrlEncode(kvp.Key) + "=" +
                                HttpUtility.UrlEncode(kvp.Value) + "&";
            }
            return paramsString;
        }
    }
}
