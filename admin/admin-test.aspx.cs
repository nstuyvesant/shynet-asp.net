using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class adminTest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e) {
        if (!Page.IsPostBack) {
        }
    }

    protected void FindStudent_Click(object sender, ImageClickEventArgs e) {
        gvStudents.DataBind();
    }
}