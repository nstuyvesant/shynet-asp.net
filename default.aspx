<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="editor" %>
<%@ Register Namespace="SHY" TagPrefix="shy" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="x-ua-compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <title>SHYnet</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha256-eSi1q2PG6J7g7ib17yAaWMcrr5GrtohYChqibrV7PBE=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.8.0/css/bootstrap-datepicker3.min.css" integrity="sha256-mlKJFBS1jbZwwDrZD1ApO7YFS6MA1XDN37jZ9GDFC64=" crossorigin="anonymous" />

  <style type="text/css">
      body {
        -webkit-font-smoothing: antialiased;
      }
      a {
          color: #5f4884;
      }
      a:hover {
          color: #eb9316;
      }
      a>.fa-minus-circle {
          color: black;
      }
      a:hover>.fa-minus-circle {
          color: red;
      }
      .pagination {
          margin: 5px 5px 0px 5px;
      }
      .input-group {
          margin-bottom: 15px;
      }
      .card-header {
          background-color: #5f4884!important;
          border-color: #5f4884!important;
          background-image: none;
          color: white;
      }
      .card {
          border-color: #5f4884!important;
      }
      .container {
          padding-top: 20px;
      }
  </style>
</head>
<body>
    <div class="container">
	    <form id="Form1" method="post" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" />

            <asp:UpdatePanel ID="updatePanel1" class="row" runat="server">
                <ContentTemplate>
                    <input type="hidden" id="student_id" runat="server" />
                    <div class="col-sm-6 col-xs-12">
                        <div class="card">
                            <h5 class="card-header">Students</h5>
                            <div class="card-body">
<!--Find/Create Student Form-->
                                <asp:Panel DefaultButton="FindStudent" CssClass="form" role="form" runat="server">
                                    <label class="sr-only" for="SearchText">Find Student</label>
                                    <div class="input-group mb-3">
                                        <asp:TextBox ID="SearchText" CssClass="form-control" Text="" autofocus runat="server" MaxLength="20" placeholder="Student's first or last name" TextMode="SingleLine" runat="server" />
                                        <span class="input-group-append">
                                            <asp:LinkButton id="FindStudent" class="btn btn-warning" onclick="FindStudent_Click" runat="server"><span class="fas fa-search"></span> Search</asp:LinkButton>
                                        </span>
                                    </div>
                                    <div class="form-group">
                                        <asp:LinkButton id="btnNewStudent" class="btn btn-warning" data-toggle="modal" data-target="#NewStudent" runat="server"><span class="fas fa-plus-circle"></span> New Student</asp:LinkButton>
                                    </div>
                                </asp:Panel>
                                <asp:Literal ID="StudentAlert" runat="server" />
<!--/Find/Create Student Form-->
<!-- Grid of Students -->
                                <asp:UpdateProgress ID="loader" AssociatedUpdatePanelID="updatePanel1" runat="server">
                                    <ProgressTemplate>
                                        <div class="text-center"><img src="ajax-loader.gif" alt="Loading..."  /> Searching for students...</div>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                                <asp:GridView
                                    ID="gvStudents" 
                                    CssClass="table table-striped table-hover table-sm table-bordered"
                                    style="margin-bottom:0px;"
                                    AllowPaging="True"
                                    AutoGenerateColumns="False"
                                    DataKeyNames="id"
                                    OnRowCommand="gvStudents_RowCommand"
                                    OnPageIndexChanging="gvStudents_PageIndexChanging"
                                    PageSize="10"
                                    runat="server"
                                >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Student name" ItemStyle-Wrap="False">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="SelectStudent" CommandName="Select" CommandArgument='<%# Eval("balance") %>' runat="server"><%# Eval("lastname") %>, <%# Eval("firstname") %> <%# Eval("email") == null ? "(email missing)" : "" %> <span class="fas fa-chevron-right"></span></asp:LinkButton>
                                            </ItemTemplate>
                                            <ItemStyle Wrap="False" />
                                        </asp:TemplateField>
                                        <asp:TemplateField
                                            HeaderText="Classes"
                                            HeaderStyle-CssClass="text-center"
                                            ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="81px">
                                            <ItemTemplate>
                                                <a href="history.aspx?id=<%#Eval("id")%>&name=<%#Eval("firstname")%> <%#Eval("lastname")%>" target="_blank" rel="noopener noreferrer"><%# Eval("balance") %></a>&nbsp;&nbsp;<asp:LinkButton ID="PurchaseClassesLink" CommandName="Purchase" CommandArgument='<%# Container.DataItemIndex %>' ToolTip='<%# Eval("firstname") + " " + Eval("lastname") %>' runat="server"><span class="fas fa-plus-circle text-success"></span></asp:LinkButton>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="text-center" />
                                            <ItemStyle HorizontalAlign="Right" Width="81px" />
                                        </asp:TemplateField>
                                        <asp:BoundField Visible="false" DataField="balance" ReadOnly="true" />
                                    </Columns>
                                    <PagerSettings
                                        Mode="NumericFirstLast"
                                        PageButtonCount="4"
                                        FirstPageText="&laquo;"
                                        LastPageText="&raquo;"
                                     />
                                    <PagerTemplate>
                                        <shy:GridPager ID="GridViewPager1" runat="server"
                                            ShowFirstAndLast="True"
                                            ShowNextAndPrevious="True"
                                            PageLinksToShow="3"/>
                                    </PagerTemplate>
                                    <EmptyDataTemplate>
                                        No students found matching the search criteria.
                                    </EmptyDataTemplate>
                                </asp:GridView>
<!-- /Grid of Students -->
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xs-12">
                        <div class="card">
                            <h5 class="card-header">Class Attendees</h5>
                            <div class="card-body">  
                              <asp:Literal ID="AttendeeAlert" runat="server"/>       
                              <div class="col-xs-12">
                                  <div class="form-group">
                                      <label class="sr-only" for="lstClass">Class</label>
                                      <asp:dropdownlist id="lstClass" CssClass="form-control" runat="server" AppendDataBoundItems="true" AutoPostBack="True">
                                          <asp:ListItem Value="AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA" Selected="True">Select a class</asp:ListItem>
                                      </asp:dropdownlist>
                                  </div>
                                  <label class="sr-only" for="txtClassDate">Class Date</label>
                                  <div class="input-group date">
                                      <asp:TextBox ID="txtClassDate" data-provide="datepicker" data-date-autoclose="true" class="form-control" runat="server" AutoPostBack="True" />
                                      <div class="input-group-append">
                                          <div class="input-group-text"><span class="fas fa-th"></span></div>
                                      </div>
                                  </div>
                              </div>

                              <div class="col-xs-12">
                                  <div class="input-group">
                                      <label class="sr-only" for="lstLocation">Location</label>
                                      <asp:dropdownlist id="lstLocation" CssClass="form-control" runat="server" AppendDataBoundItems="True" AutoPostBack="True">
                                          <asp:ListItem Value="AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA" Selected="True">Select Location</asp:ListItem>
                                      </asp:dropdownlist>
                                      <span class="input-group-addon">&nbsp;</span>
                                      <label class="sr-only" for="lstInstructor">Instructor</label>
                                      <asp:dropdownlist id="lstInstructor" CssClass="form-control" runat="server" AppendDataBoundItems="True" AutoPostBack="True">
                                          <asp:ListItem Value="AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA" Selected="True">Select instructor</asp:ListItem>
                                      </asp:dropdownlist>
                                  </div>
                              </div>

                              <div class="col-xs-12">
                                  <asp:GridView ID="gvAttendees"
                                      CssClass="table table-striped table-hover table-sm table-bordered"
                                      style="margin-bottom:0px;"
                                      AllowPaging="false" 
                                      AutoGenerateColumns="false"
                                      AutoGenerateDeleteButton="false"    
                                      DataKeyNames="id"
                                      DataSourceID="srcAttendees"
                                      EnableViewState="true"
                                      EnableSortingAndPagingCallbacks="true"
                                      OnRowDataBound="gvAttendees_RowDataBound" 
                                      OnRowDeleted="gvAttendees_RowDeleted"
                                      PageSize="25"
                                      runat="server"
                                      ShowFooter="True"
                                  >
                                      <Columns>
                                          <asp:BoundField Visible="false" DataField="student_id" />
                                          <asp:CommandField ShowDeleteButton="true" ItemStyle-Width="24px" DeleteText='<span class="fas fa-minus-circle"></span>' />
                                          <asp:BoundField HeaderText="Attendees" DataField="name" ItemStyle-HorizontalAlign="Left" />
                                      </Columns>
                                      <PagerTemplate>
                                          <shy:GridPager ID="GridViewPager2" runat="server"
                                              ShowFirstAndLast="True"
                                              ShowNextAndPrevious="True"
                                              PageLinksToShow="3"/>
                                      </PagerTemplate>
                                      <EmptyDataTemplate>
                                          No students in selected class.
                                      </EmptyDataTemplate>
                                  </asp:GridView>
                                  
                              </div>
                            </div>
                        </div>
                    </div>

                    <asp:Panel ID="pnlNewStudent" DefaultButton="NewStudentOK" runat="server">
                        <div id="NewStudent" class="modal">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h4 class="modal-title">New Student</h4>
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group">
                                            <label for="firstName">First name</label>
                                            <asp:TextBox ID="firstName" autofocus required CssClass="form-control" runat="server" placeholder="First name" MaxLength="20" style="margin-bottom:10px;" />
                                        </div>
                                        <div class="form-group">
                                            <label for="firstName">Last name</label>
                                            <asp:TextBox ID="lastName" required CssClass="form-control" runat="server" placeholder="Last name" MaxLength="20" />
                                        </div>
                                        <div class="form-group">
                                          <label for="email">Email</label>
                                          <asp:TextBox ID="email" type="email" CssClass="form-control" runat="server" placeholder="Email address" MaxLength="255" />
                                      </div>
                                    </div>
                                    <div class="modal-footer">
                                        <asp:Button ID="NewStudentCancel" onclick="NewStudentCancel_Click" formnovalidate CssClass="btn btn-secondary" CausesValidation="false" Text="Cancel" runat="server" style="width:80px;" />
                                        <asp:Button ID="NewStudentOK" onclick="NewStudentOK_Click" CssClass="btn btn-warning" Text="Save" CausesValidation="false" style="width:80px;" runat="server" />
                                    </div>
                                </div><!-- /.modal-content -->
                            </div><!-- /.modal-dialog -->
                        </div><!-- /.modal -->
                    </asp:Panel>

                    <asp:Panel ID="pnlPurchase" DefaultButton="PurchaseClassesOK" runat="server">
                        <div id="PurchaseClasses" class="modal">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h4 class="modal-title">Purchase classes for <asp:Literal ID="litStudentName" runat="server" /></h4>
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group">
                                            <label for="NumberOfClasses">Number of classes</label>
                                            <input type="number" id="NumberOfClasses" min="1" oninput="this.value = Math.abs(this.value)" autofocus required class="form-control" value="1" runat="server" style="margin-bottom:10px;" />
                                        </div>
                                        <div class="form-group">
                                            <label for="lstPaymentType">Payment method</label>
                                            <asp:DropDownList ID="lstPaymentType" CssClass="form-control" runat="server" />
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <asp:LinkButton ID="PurchaseClassesCancel" onclick="PurchaseClassesCancel_Click" formnovalidate CssClass="btn btn-secondary" CausesValidation="false" Text="Cancel" style="width:85px;" runat="server" />
                                        <asp:LinkButton ID="PurchaseClassesOK" CssClass="btn btn-warning" onclick="PurchaseClassesOK_Click" CausesValidation="true" style="width:85px;" runat="server">Purchase</asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:SqlDataSource ID="srcAttendees" runat="server"
                        ConnectionString="<%$ ConnectionStrings:Heroku %>"
                        ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"
                        SelectCommand="SELECT id, name, student_id
                                            FROM old_attendees
                                            WHERE 
                                                class_date = @class_date AND
                                                instructor_id = @instructor_id AND
                                                class_id = @class_id AND
                                                location_id = @location_id
                                            ORDER BY name"
                        InsertCommand="INSERT INTO old_attendances (instructor_id, class_id, location_id, class_date, student_id) VALUES (@instructor_id::uuid, @class_id::uuid, @location_id::uuid, @class_date::date, @student_id::uuid)"                
                        DeleteCommand="DELETE FROM old_attendances WHERE id = @id::uuid"
                    >
                        <SelectParameters>
                            <asp:ControlParameter Name="class_date" DbType="Date" ControlID="txtClassDate" PropertyName="Text"/>
                            <asp:ControlParameter Name="instructor_id" DbType="Guid" ControlID="lstInstructor" PropertyName="SelectedValue"/>
                            <asp:ControlParameter Name="class_id" DbType="Guid" ControlID="lstClass" PropertyName="SelectedValue"/>
                            <asp:ControlParameter Name="location_id" DbType="Guid" ControlID="lstLocation" PropertyName="SelectedValue"/>
                        </SelectParameters>
                        <InsertParameters>
                            <asp:ControlParameter Name="student_id" DbType="Guid" ControlID="student_id" PropertyName="Value" />                                
                            <asp:ControlParameter Name="class_date" DbType="Date" ControlID="txtClassDate" PropertyName="Text"/>
                            <asp:ControlParameter Name="instructor_id" DbType="Guid" ControlID="lstInstructor" PropertyName="SelectedValue"/>
                            <asp:ControlParameter Name="class_id" DbType="Guid" ControlID="lstClass" PropertyName="SelectedValue"/>
                            <asp:ControlParameter Name="location_id" DbType="Guid" ControlID="lstLocation" PropertyName="SelectedValue"/>
                        </InsertParameters>
                    </asp:SqlDataSource>

                </ContentTemplate>
            </asp:UpdatePanel>

	        </form>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.4/umd/popper.min.js" integrity="sha256-EGs9T1xMHdvM1geM8jPpoo8EZ1V1VRsmcJz8OByENLA=" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha256-VsEqElsCHSGmnmHXGQzvoWjWwoznFSZc6hs7ARLRacQ=" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.8.0/js/bootstrap-datepicker.min.js" integrity="sha256-tW5LzEC7QjhG0CiAvxlseMTs2qJS7u3DRPauDjFJ3zo=" crossorigin="anonymous"></script>

        <script type="text/javascript">
            function newStudentHide() {
                $('#NewStudent').modal('hide');
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            }

            function purchaseClassesShow() {
                $('#PurchaseClasses').modal('show');
            }

            function purchaseClassesHide() {
                $('#PurchaseClasses').modal('hide');
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            }
        </script>
    </body>
</html>
