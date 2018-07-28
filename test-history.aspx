﻿<%@ Page Language="C#" Debug="true" AutoEventWireup="true" CodeFile="test-history.aspx.cs" Inherits="shynet_test_history" MaintainScrollPositionOnPostback="True" %>
<!doctype html>
<html lang="en-us">
<head runat="server">
  <title>Student History</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="x-ua-compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha256-NJWeQ+bs82iAeoT5Ktmqbi3NXwxcHlfaVejzJI2dklU=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-+d0P83n9kaQMCwj8F4RJB66tzIwOKmrdb46+porD/OvrJ+37WqIM7UoBtwHO6Nlg" crossorigin="anonymous" />
  <style>
    .spacer {
      margin-top: 10px;
    }
  </style>
</head>
<body>
  <div class="container body-content spacer">
    <form runat="server">
      <asp:ScriptManager ID="ScriptManager1" runat="server" />

      <b><asp:Literal ID="litHeading" runat="server" /></b><br/>

      <asp:SqlDataSource ID="srcHistory" runat="server" 
        ConnectionString="<%$ ConnectionStrings:Heroku %>" 
        ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"
        SelectCommand="SELECT * FROM old_show_history(@student_id)" 
        SelectCommandType="Text"
        DeleteCommand="SELECT FROM old_delete_history(@transaction_type, @id)"
        DeleteCommandType="Text"
        UpdateCommand="SELECT FROM old_update_history(@transaction_type, @id, @transaction_date::date, @instructor_id, @location_id, @class_id, @quantity::smallint, @payment_type_id)"
        UpdateCommandType="Text"
        >
        <SelectParameters>
          <asp:Parameter Name="student_id" DbType="Guid" Direction="Input" />
        </SelectParameters>
        <DeleteParameters>
          <asp:Parameter Name="transaction_type" DbType="String" Direction="Input" />
          <asp:Parameter Name="id" DbType="Guid" Direction="Input" />
        </DeleteParameters>
        <UpdateParameters>
          <asp:Parameter Name="transaction_type" DbType="String" Direction="Input" />
          <asp:Parameter Name="id" DbType="Guid" Direction="Input" />
          <asp:Parameter Name="transaction_date" DbType="Date" Direction="Input" />
          <asp:Parameter Name="instructor_id" DbType="Guid" Direction="Input" />
          <asp:Parameter Name="location_id" DbType="Guid" Direction="Input" />
          <asp:Parameter Name="class_id" DbType="Guid" Direction="Input" />
          <asp:Parameter Name="quantity" DbType="Int16" Direction="Input" />
          <asp:Parameter Name="payment_type_id" DbType="Guid" Direction="Input" />
        </UpdateParameters>
      </asp:SqlDataSource>

      <asp:GridView ID="gvHistory"
        CssClass="table table-striped table-hover table-condensed table-bordered"
        AllowPaging="True"
        AutoGenerateColumns="False"
        DataSourceID="srcHistory"
        DataKeyNames="transaction_type,id"
        PageSize="20" 
        AutoGenerateDeleteButton="True"
        AutoGenerateEditButton="True" 
        OnRowDeleting="gvHistory_RowDeleting"
        OnRowEditing="gvHistory_RowEditing"
        OnRowDataBound="gvHistory_RowDataBound"
        PagerSettings-PageButtonCount="5"
        runat="server">
        <Columns>
          <asp:BoundField DataField="transaction_type" HeaderText="transaction_type" Visible="false" ReadOnly="true" />
          <asp:BoundField DataField="id" Visible="false" HeaderText="id" ReadOnly="true" />
          <asp:BoundField DataField="transaction_date" HeaderText="transaction_date" Visible="false" />
          <asp:BoundField DataField="instructor_id" HeaderText="instructor_id" Visible="true" />
          <asp:BoundField DataField="location_id" HeaderText="location_id" Visible="false" />
          <asp:BoundField DataField="class_id" HeaderText="class_id" Visible="false" />
          <asp:BoundField DataField="payment_type_id" HeaderText="payment_type_id" Visible="false" />
          <asp:TemplateField HeaderText="Date" ItemStyle-Width="90px">
            <EditItemTemplate>
              <asp:TextBox ID="txtClassDate" CssClass="form-control" TextMode="Date" Text='<%# Bind("transaction_date","{0:yyyy-MM-dd}") %>' runat="server" Width="160px" AutoPostBack="True" />
            </EditItemTemplate>
            <ItemTemplate>
              <asp:Label ID="transaction_date" runat="server" Text='<%# Bind("transaction_date","{0:d}") %>'></asp:Label>
            </ItemTemplate>
          </asp:TemplateField>
          <asp:TemplateField HeaderText="Description">
            <EditItemTemplate>
              <asp:dropdownlist id="lstInstructor" CssClass="form-control" runat="server" AutoPostBack="true" />
              <asp:dropdownlist id="lstClass" CssClass="form-control" runat="server" AutoPostBack="true" />
              <asp:dropdownlist id="lstLocation" CssClass="form-control" runat="server" AutoPostBack="true" />
              <asp:dropdownlist id="lstPaymentType" CssClass="form-control" runat="server" AutoPostBack="true" />
            </EditItemTemplate>
            <ItemTemplate>
              <asp:Label ID="lblWhat" runat="server" Text='<%# Bind("what") %>'></asp:Label>
            </ItemTemplate>
            <HeaderStyle HorizontalAlign="Left" />
          </asp:TemplateField>
          <asp:BoundField DataField="quantity" HeaderText="Qty" ControlStyle-CssClass="form-control" HeaderStyle-CssClass="text-center" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="60px" />
          <asp:BoundField DataField="balance" HeaderText="Balance" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="60px" ReadOnly="True" />
        </Columns>
      </asp:GridView>
    </form>
  </div>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha256-98vAGjEDGN79TjHkYWVD4s87rvWkdWLHPs5MC3FvFX4=" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha256-C8oQVJ33cKtnkARnmeWp6SDChkU+u7KvsNMFUzkkUzk=" crossorigin="anonymous"></script>
</body>
</html>
