using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using Npgsql;

public partial class test : System.Web.UI.Page
{
    protected void Page_Load(Object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Define the connection
            NpgsqlConnection conn = new NpgsqlConnection(ConfigurationManager.ConnectionStrings["Heroku"].ToString());
            conn.Open();
            NpgsqlCommand cmd = new NpgsqlCommand("SELECT id, name FROM old_classes WHERE active=true ORDER BY name", conn);
            NpgsqlDataReader reader = cmd.ExecuteReader();
            lstClass.DataSource = reader;
            lstClass.DataTextField = "name";
            lstClass.DataValueField = "id";
            lstClass.DataBind();
            reader.Close();
            conn.Close();

            
            // Populate the classes, instructors, locations picklists

                    // lstClass
                    // <asp:SqlDataSource ID="srcClasses" runat="server" 
                    //     ConnectionString="<%$ ConnectionStrings:Heroku %>" 
                    //     ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"  
                    //     SelectCommand="SELECT id, name FROM old_classes WHERE active=true ORDER BY name"
                    //     DataSourceMode="DataReader"
                    // />

                    // lstInstructor
                    // <asp:SqlDataSource ID="srcInstructors" runat="server" 
                    //     ConnectionString="<%$ ConnectionStrings:Heroku %>" 
                    //     ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"          
                    //     SelectCommand="SELECT id, lastname || ', ' || firstname AS name FROM old_instructors WHERE active=true ORDER BY lastname"
                    //     DataSourceMode="DataReader"
                    // />

                    // lstLocation
                    // <asp:SqlDataSource ID="srcLocations" runat="server" 
                    //     ConnectionString="<%$ ConnectionStrings:Heroku %>" 
                    //     ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"    
                    //     SelectCommand="SELECT id, name FROM old_locations WHERE active=true ORDER BY name"
                    //     DataSourceMode="DataReader"
                    // />

                    // lstPaymentType
                    // <asp:SqlDataSource ID="srcPaymentTypes" runat="server" 
                    //     ConnectionString="<%$ ConnectionStrings:Heroku %>" 
                    //     ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"    
                    //     SelectCommand="SELECT id, name FROM old_payment_types WHERE active=true ORDER BY ordinal"
                    //     DataSourceMode="DataReader"
                    // />





            txtClassDate.Text = DateTime.Today.ToString("MM/dd/yyyy");
            gvStudents.DataBind();
        }
        else
        {
            AttendeeAlert.Text = "";
            StudentAlert.Text = "";
        }
    }

    protected void FindStudent_Click(Object sender, EventArgs e)
    {
        // Reset page index to zero for each new search so we're not stuck on an out of range page
        gvStudents.PageIndex = 0;

        if (SearchText.Text != "")
        {
            // gvStudents.DataSourceID = "lnqStudents";
            gvStudents.DataSourceID = "srcStudentBalances";
            gvStudents.DataBind();
        }
        else
            gvStudents.DataSourceID = "";
    }

    protected void NewStudentCancel_Click(Object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "NewStudentHide", "newStudentHide();", true);
        // Reset the fields to blank for the next student we create.
        firstName.Text = "";
        lastName.Text = "";
    }

    protected void NewStudentOK_Click(Object sender, EventArgs e)
    {
        srcStudents.Insert();
        gvStudents.DataBind(); // So we can see the newly added student immediately without a new search
        ScriptManager.RegisterStartupScript(this, this.GetType(), "NewStudentHide", "newStudentHide();", true);
        SearchText.Text = lastName.Text;
        firstName.Text = "";
        lastName.Text = "";
    }

    protected void PurchaseClassesCancel_Click(Object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "PurchaseClassesHide", "purchaseClassesHide();", true);
    }

    protected void PurchaseClassesOK_Click(Object sender, EventArgs e)
    {
        // purchased_on is set to GETDATE() as a SQL Server default
        // srcPayments.InsertParameters["source_ip"].DefaultValue = Request.UserHostAddress;
        // srcPayments.InsertParameters["quantity"].DefaultValue = Math.Abs(srcPayments.InsertParameters["quantity"].DefaultValue);
        srcPayments.Insert();
        gvStudents.DataBind(); // Refresh to show increased quantity
        ScriptManager.RegisterStartupScript(this, this.GetType(), "PurchaseClassesHide", "purchaseClassesHide();", true);
    }

    protected void gvStudents_RowCommand(Object sender, GridViewCommandEventArgs e)
    {
        // If a pager control or sort column is clicked, bail out of this right away
        if (e.CommandName != "Select" && e.CommandName != "Purchase")
            return;

        GridViewRow row = (GridViewRow)((Control)e.CommandSource).NamingContainer;
        student_id.Value = gvStudents.DataKeys[row.RowIndex].Value.ToString();

        switch (e.CommandName)
        {
            case "Select":

                // Check to see whether the selected student has a balance < 1
                int balance = Convert.ToInt32(e.CommandArgument);
                if (balance < 1)
                {
                    StudentAlert.Text = alert("This student needs to buy a class card.");
                    return; // Exit - do not add to class
                }

                if (lstInstructor.SelectedIndex == 0 || lstLocation.SelectedIndex == 0 || lstClass.SelectedIndex == 00)
                {
                    AttendeeAlert.Text = alert("Please choose an instructor, location, and class before adding a student.");
                    return; // Exit - do not add to class
                }

                // Check to see whether the selected student is already in the attendees list
                DataView dv = (DataView)srcAttendees.Select(DataSourceSelectArguments.Empty);
                foreach (DataRow dr in dv.Table.Rows)
                {
                    if (dr["student_id"].ToString() == student_id.Value)
                    {
                        StudentAlert.Text = alert("That student has already been added to the class.");
                        return; // Exit - do not add to class
                    }
                }

                // Insert the record into the attendances table
                srcAttendees.Insert();

                // Refresh data bindings
                gvStudents.DataBind(); // Updates the student's balance

                break;

            case "Purchase":
                litStudentName.Text = ((LinkButton)e.CommandSource).ToolTip;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PurchaseClassesShow", "purchaseClassesShow();", true);
                PurchaseClassesOK.Focus();
                break;
        }

    }

    protected void gvAttendees_RowDataBound(Object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Footer) // add the number of students to the footer of gvAttendees
        {
            int students = gvAttendees.Rows.Count;
            string footerText = " student";
            if (students > 1)
                footerText += "s";
            e.Row.Cells[2].Text = students.ToString() + footerText;
        }
    }

    protected void gvAttendees_RowDeleted(Object sender, EventArgs e)
    {
        gvStudents.DataBind(); // Updates the student's balance
    }

    private string alert(string message, string criticality = "danger")
    {
        return "<div class=\"alert alert-" + criticality + " alert-dismissable\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">&times;</button>" + message + "</div>";
    }

}