<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="test" %>
<%@ Register Namespace="SHY" TagPrefix="shy" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>SHYnet</title>

    <!-- Load jQuery from Google CDN -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <!-- Latest compiled and minified CSS 4.1.2 -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
        
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

    <!-- bootstrap-datepicker - could replace Google input type=date -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/css/bootstrap-datepicker3.standalone.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.min.js"></script>


    <style type="text/css">
        a {
            color: #5f4884;
        }
        a:hover {
            color: #eb9316;
        }
        a>.glyphicon-remove {
            color: black;
        }
        a:hover>.glyphicon-remove {
            color: red;
        }
        .pagination {
            margin: 5px 5px 0px 5px;
        }
        .input-group {
            margin-bottom: 15px;
        }
        .panel-primary>.panel-heading {
            background-color: #5f4884!important;
            border-color: #5f4884!important;
            background-image: none;
        }
        .panel-primary {
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
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h4>Students</h4>
                            </div>
                            <div class="panel-body">
<!--Find/Create Student Form-->
                                <asp:Panel DefaultButton="FindStudent" CssClass="form" role="form" runat="server">
                                    <div class="form-group">
                                        <label class="sr-only" for="SearchText">Find Student</label>
                                        <div class="input-group">
                                            <asp:TextBox ID="SearchText" CssClass="form-control" Text="" autofocus runat="server" MaxLength="20" placeholder="Student's first or last name" TextMode="SingleLine" runat="server" />
                                            <span class="input-group-btn">
                                                <asp:LinkButton id="FindStudent" class="btn btn-warning" onclick="FindStudent_Click" runat="server"><span class="glyphicon glyphicon-search"></span> Search</asp:LinkButton>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:LinkButton id="btnNewStudent" class="btn btn-warning" data-toggle="modal" data-target="#NewStudent" runat="server"><span class="glyphicon glyphicon-plus-sign"></span> New Student</asp:LinkButton>
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
                                    CssClass="table table-striped table-hover table-condensed table-bordered"
                                    style="margin-bottom:0px;"
                                    AllowPaging="True"
                                    AutoGenerateColumns="False"
                                    DataSourceID=""
                                    DataKeyNames="id"
                                    OnRowCommand="gvStudents_RowCommand"
                                    PageSize="25"
                                    runat="server"
                                >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Student name" ItemStyle-Wrap="False">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="SelectStudent" CommandName="Select" CommandArgument='<%# Eval("balance") %>' runat="server"><%# Eval("lastname") %>, <%# Eval("firstname") %> <span class="glyphicon glyphicon-chevron-right"></span></asp:LinkButton>
                                            </ItemTemplate>
                                            <ItemStyle Wrap="False" />
                                        </asp:TemplateField>
                                        <asp:TemplateField
                                            HeaderText="Classes"
                                            HeaderStyle-CssClass="text-center"
                                            ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="81px">
                                            <ItemTemplate>
                                                <a href="history.aspx?id=<%#Eval("id")%>&name=<%#Eval("firstname")%> <%#Eval("lastname")%>" target="_blank" rel="noopener noreferrer"><%# Eval("balance") %>&nbsp;&nbsp;<span class="glyphicon glyphicon-list-alt hide"></span></a>&nbsp;&nbsp;<asp:LinkButton ID="PurchaseClassesLink" CommandName="Purchase" CommandArgument='<%# Container.DataItemIndex %>' ToolTip='<%# Eval("firstname") + " " + Eval("lastname") %>' runat="server"><span class="glyphicon glyphicon-plus-sign text-success"></span></asp:LinkButton>
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
                        <div class="panel panel-primary">
                            <div class="panel-heading"><h4>Class Attendees</h4></div>
                            <div class="panel-body">         
                                <div class="row"><!--Class Selection Form-->
                                    <div class="col-xs-12">
                                        <asp:Literal ID="AttendeeAlert" runat="server"/>
                                        <div class="form-group">
                                            <label class="sr-only" for="lstClass">Class</label>
                                            <asp:dropdownlist id="lstClass" CssClass="form-control" runat="server" AppendDataBoundItems="true" AutoPostBack="True">
                                                <asp:ListItem Value="AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA" Selected="True">Select a class</asp:ListItem>
                                            </asp:dropdownlist>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-6">
                                        <label class="sr-only" for="txtClassDate">Class Date</label>
                                        <div class="input-group date" data-provide="datepicker">
                                            <asp:TextBox ID="txtClassDate" class="form-control" runat="server" AutoPostBack="True" />
                                            <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-th"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
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
                                </div><!--/Class Selection Form-->

                                <div class="row"><!--Attendees Grid-->
                                    <div class="col-xs-12">
                                        <asp:GridView ID="gvAttendees"
                                            CssClass="table table-striped table-hover table-condensed table-bordered"
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
                                                <asp:CommandField ShowDeleteButton="true" ItemStyle-Width="24px" DeleteText='<span class="glyphicon glyphicon-remove"></span>' />
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
                                </div><!--/Attendees Grid-->
                            </div>
                        </div>
                    </div>

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

                    <asp:SqlDataSource ID="srcPayments" runat="server"
                        ConnectionString="<%$ ConnectionStrings:Heroku %>" 
                        InsertCommand="INSERT INTO old_purchases (student_id, location_id, instructor_id, class_id, quantity, payment_type_id) VALUES (@student_id::uuid, @location_id::uuid, @instructor_id::uuid, @class_id::uuid, @quantity, @payment_type_id::uuid)" 
                        ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>">
                        <InsertParameters>
                            <asp:ControlParameter Name="student_id" DbType="Guid" ControlID="student_id" PropertyName="Value" />                                
                            <asp:ControlParameter Name="location_id"  DbType="Guid" ControlID="lstLocation" PropertyName="SelectedValue" />
                            <asp:ControlParameter Name="instructor_id" DbType="Guid" ControlID="lstInstructor" PropertyName="SelectedValue" />
                            <asp:ControlParameter Name="class_id" DbType="Guid" ControlID="lstClass" PropertyName="SelectedValue" />
                            <asp:ControlParameter Name="quantity" DbType="Int16" ControlID="NumberOfClasses" PropertyName="Value" />
                            <asp:ControlParameter Name="payment_type_id" DbType="Guid" ControlID="lstPaymentType" PropertyName="SelectedValue" />
                        </InsertParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="srcStudentBalances" runat="server"
                      ConnectionString="<%$ ConnectionStrings:Heroku %>"
                      ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"           
                      SelectCommand="SELECT id, balance, lastname, firstname FROM old_student_balances WHERE lower(lastname) LIKE lower(@search_text) || '%' OR lower(firstname) LIKE lower(@search_text) || '%'"
                      EnableViewState="False"
                      DataSourceMode="DataSet"
                      >
                      <SelectParameters>
                        <asp:ControlParameter ControlID="SearchText" ConvertEmptyStringToNull="false" Name="search_text" PropertyName="Text" Size="20" Type="String" />
                      </SelectParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="srcStudents" runat="server"
                        ConnectionString="<%$ ConnectionStrings:Heroku %>"
                        ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"           
                        InsertCommand="INSERT INTO old_students (firstname, lastname) VALUES (@firstname, @lastname)"
                        EnableViewState="False"
                        DataSourceMode="DataSet"
                        >
                        <InsertParameters>
                            <asp:ControlParameter Name="firstname" DbType="String" ControlID="firstName" PropertyName="Text" />
                            <asp:ControlParameter Name="lastName" DbType="String" ControlID="lastName" PropertyName="Text" />
                        </InsertParameters>
                    </asp:SqlDataSource>

                    <asp:Panel ID="pnlNewStudent" DefaultButton="NewStudentOK" runat="server">
                        <div id="NewStudent" class="modal">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h4 class="modal-title">New Student</h4>
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
                                    </div>
                                    <div class="modal-footer">
                                        <asp:Button ID="NewStudentCancel" onclick="NewStudentCancel_Click" formnovalidate CssClass="btn btn-default" CausesValidation="false" Text="Cancel" runat="server" style="width:80px;" />
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
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h4 class="modal-title">Purchase classes for <asp:Literal ID="litStudentName" runat="server" /></h4>
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
                                        <asp:LinkButton ID="PurchaseClassesCancel" CssClass="btn btn-default" onclick="PurchaseClassesCancel_Click" style="width:85px;" runat="server">Cancel</asp:LinkButton>
                                        <asp:LinkButton ID="PurchaseClassesOK" CssClass="btn btn-warning" onclick="PurchaseClassesOK_Click" CausesValidation="true" style="width:85px;" runat="server">Purchase</asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                </ContentTemplate>
            </asp:UpdatePanel>

	        </form>
        </div>

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
