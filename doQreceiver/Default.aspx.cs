using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Configuration;
using System.Xml;
using doQRouter;

public partial class _Default : System.Web.UI.Page
{
    private string strDestFolder = ConfigurationSettings.AppSettings["DestinationFolder"];
    private clsCommon objCommon = new clsCommon();
    protected void Page_Load(object sender, EventArgs e)
    {
        string strResponse = "";
        try
        {
            Response.BufferOutput = false;
            strResponse = objCommon.ExtractFiles(Request.InputStream);
            Response.Write(strResponse);
        }
        catch (Exception exception)
        {
            Trace.Write(exception.Message);
            objCommon.WriteErrorToFIle(exception);
            string str = objCommon.GenerateAck(false, exception.Source + ":" + exception.Message, "", "");
            Response.Write(str);
        }

    }
}
