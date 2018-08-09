using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e) {
        if (!Page.IsPostBack) {
        }
    }

    protected void FindStudent_Click(object sender, EventArgs e) {
        gvStudents.DataBind();
    }

    protected void FindSubscriber_Click(object sender, EventArgs e) {
        gvSubscribers.DataBind();
    }

    protected void dvSubscribers_ItemInserted(object sender, DetailsViewInsertedEventArgs e) {		
         gvSubscribers.DataBind();		
     }
}