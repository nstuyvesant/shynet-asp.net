﻿using System;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using Npgsql;

public partial class shynet_test_history : System.Web.UI.Page
{
    private string CONNECTION_STRING = ConfigurationManager.ConnectionStrings["Heroku"].ToString();

    protected void Page_Load(object sender, EventArgs e)
    {
        srcHistory.SelectParameters[0].DefaultValue = Request.QueryString["id"];
        litHeading.Text = Request.QueryString["name"];

        if (User.Identity.Name == "SHYNET\\shy")
        {
            gvHistory.AutoGenerateDeleteButton = false;
            gvHistory.AutoGenerateEditButton = false;
        }
    }

    protected void gvHistory_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        srcHistory.DeleteParameters[0].DefaultValue = gvHistory.DataKeys[e.RowIndex].Values["transaction_type"].ToString(); // Transaction type (P or A)
        srcHistory.DeleteParameters[1].DefaultValue = gvHistory.DataKeys[e.RowIndex].Values["id"].ToString();  // id
        //TODO: Rebind main DataView in case class was deleted from currently displayed one
    }

    protected void gvHistory_RowCanceling(object sender, GridViewCancelEditEventArgs e)
    {
        // I probably don't need to do this since I'm using automatic binding
        //gvHistory.EditIndex = -1;
        //gvHistory.DataBind();
    }

    protected void gvHistory_RowEditing(object sender, GridViewEditEventArgs e)
    {
        if (gvHistory.DataKeys[e.NewEditIndex].Values["transaction_type"].ToString() == "A")
            ((BoundField)gvHistory.Columns[4]).ReadOnly = true;
        else
            ((BoundField)gvHistory.Columns[4]).ReadOnly = false;
    }

    protected void gvHistory_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
          if (e.Row.RowState == DataControlRowState.Edit)
          {
            // Populate dropdowns only once using ViewState to retain their contents
            NpgsqlConnection conn = new NpgsqlConnection(CONNECTION_STRING);
            conn.Open();

            NpgsqlCommand cmd = new NpgsqlCommand("SELECT id, lastname || ', ' || firstname AS name FROM old_instructors WHERE active=true ORDER BY lastname", conn);
            NpgsqlDataReader reader = cmd.ExecuteReader();
            DropDownList lstInstructor = (DropDownList)e.Row.FindControl("lstInstructor");
            lstInstructor.DataSource = reader;
            lstInstructor.DataTextField = "name";
            lstInstructor.DataValueField = "id";
            lstInstructor.DataBind();
            reader.Close();
            DataRowView dr = e.Row.DataItem as DataRowView;
            lstInstructor.SelectedValue = dr["instructor_id"].ToString();

            cmd = new NpgsqlCommand("SELECT id, name FROM old_classes WHERE active=true ORDER BY name", conn);
            reader = cmd.ExecuteReader();
            DropDownList lstClass = (DropDownList)e.Row.FindControl("lstClass");
            lstClass.DataSource = reader;
            lstClass.DataTextField = "name";
            lstClass.DataValueField = "id";
            lstClass.DataBind();
            reader.Close();
            lstClass.SelectedValue = dr["class_id"].ToString();

            cmd = new NpgsqlCommand("SELECT id, name FROM old_locations WHERE active=true ORDER BY name", conn);
            reader = cmd.ExecuteReader();
            DropDownList lstLocation = (DropDownList)e.Row.FindControl("lstLocation");
            lstLocation.DataSource = reader;
            lstLocation.DataTextField = "name";
            lstLocation.DataValueField = "id";
            lstLocation.DataBind();
            reader.Close();
            lstLocation.SelectedValue = dr["location_id"].ToString();

            cmd = new NpgsqlCommand("SELECT id, name FROM old_payment_types WHERE active=true ORDER BY ordinal", conn);
            reader = cmd.ExecuteReader();
            DropDownList lstPaymentType = (DropDownList)e.Row.FindControl("lstPaymentType");
            lstPaymentType.DataSource = reader;
            lstPaymentType.DataTextField = "name";
            lstPaymentType.DataValueField = "id";
            lstPaymentType.DataBind();
            reader.Close();
            lstPaymentType.SelectedValue = dr["payment_type_id"].ToString();

            conn.Close();

            if (gvHistory.DataKeys[e.Row.RowIndex].Values["transaction_type"].ToString() == "A")
                lstPaymentType.Visible = false;
            else
                lstPaymentType.Visible = true;
          }
        }
    }

}