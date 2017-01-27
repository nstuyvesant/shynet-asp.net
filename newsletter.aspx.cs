using System;
using aspNetEmail;
using System.Data;
using System.Configuration;
using Npgsql;

public partial class newsletter : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    private DataSet BuildDataSet(string SqlStatement, string DataTableName)
    {
        String cs = ConfigurationManager.ConnectionStrings["Heroku"].ConnectionString;
        NpgsqlConnection conn = new NpgsqlConnection(cs);
        DataSet ds = new DataSet();
        NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(SqlStatement, conn);
        adapter.Fill(ds, DataTableName);
        return ds;
    }

    protected void btnSend_Click(object sender, EventArgs e)
    {
        bool IsTestMode = false;
        // System.Net.Configuration.SmtpSection smtp = new System.Net.Configuration.SmtpSection();
        EmailMessage msg = new EmailMessage();
        msg.ValidateAddress = false;
        msg.FromAddress = "leta@schoolhouseyoga.com";
        msg.MailMergeReconnectAttempts = 3;
        msg.MailMergeReconnectDelay = 3;

        String sql = "SELECT email FROM public.\"Users\" WHERE email IS NOT NULL AND \"optOut\" = false ORDER BY email OFFSET 0 ROWS FETCH NEXT 9000 ROWS ONLY;";
        // String sql = "SELECT email FROM public.\"Users\" WHERE email IS NOT NULL AND \"optOut\" = false ORDER BY email OFFSET 9000 ROWS;";

        if (IsTestMode)
        {
            sql = "SELECT email FROM public.\"Users\" WHERE email IN ('info@schoolhouseyoga.com');";
        }

        DataSet ds = BuildDataSet(sql, "Users");

        msg.To = "##email##";
        msg.Subject = "Schoolhouse Yoga News";
        msg.ContentTransferEncoding = MailEncoding.QuotedPrintable;
        msg.BodyFormat = MailFormat.Html;
        //msg.BodyFormat = MailFormat.Text;
        msg.ThrowException = false;
        msg.LogBody = false;
        msg.Logging = false;
        msg.AppendBodyFromUrl("https://www.schoolhouseyoga.com/newsletter.html", true, true, true, MailEncoding.QuotedPrintable, true, EmbedImageOption.ConvertToAbsoluteUrl);
        //msg.Body = "Dear ##firstName##," + Environment.NewLine + Environment.NewLine;
        //msg.AppendBodyFromFile(@"c:\inetpub\wwwroot\newsletter.txt");
        msg.Body = msg.Body + "<br/><a href='https://www.schoolhouseyoga.com/api/newsletter/unsubscribe/##email##' style='color:black;'>Unsubscribe from the newsletter</a></body></html>";
        if (IsTestMode)
        {
            if (msg.SendMailMergeToMSPickup(ds, @"c:\inetpub\mailroot\pickup\"))
            {
                litMsg.Text = "The test messages were sent.";

            }
            else
            {
                litMsg.Text = "<font color=#FF0033>The following error occurred while sending the email: " + msg.LastException().Message + "</font><br><br>";
                litMsg.Text += Server.HtmlEncode(msg.GetLog()).Replace("\r\n", "<br>");
            }
        }
        else
        {
            if (msg.SendMailMergeToMSPickup(ds, @"c:\inetpub\mailroot\pickup\"))
            {
                litMsg.Text = ds.Tables[0].Rows.Count.ToString() + " messages were sent.";
            }
            else
            {
                litMsg.Text = "<font color=#FF0033>The following error occurred while sending the email: " + msg.LastException().Message + "</font><br><br>";
                litMsg.Text += Server.HtmlEncode(msg.GetLog()).Replace("\r\n", "<br>");
            }

        }

        pnlInput.Visible = false;
        pnlConfirmation.Visible = true;
    }
}