<%@ Page Language="C#" AutoEventWireup="true" Debug="true" CodeFile="admin-test.aspx.cs" Inherits="adminTest" %>
<!DOCTYPE html>
<html lang="en">

<head runat="server">
    <title>SHY Administration</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="x-ua-compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha256-eSi1q2PG6J7g7ib17yAaWMcrr5GrtohYChqibrV7PBE=" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-+d0P83n9kaQMCwj8F4RJB66tzIwOKmrdb46+porD/OvrJ+37WqIM7UoBtwHO6Nlg" crossorigin="anonymous" />
</head>

<body>
    <div class="container" style="margin-top:15px;">
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" />
            <asp:UpdatePanel ID="updatePanel1" runat="server">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">Students</div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label class="sr-only" for="StudentSearch">Find Student</label>
                                        <div class="input-group">
                                            <asp:TextBox ID="StudentSearch" CssClass="form-control" Text="" autofocus RunAt="server" MaxLength="20" placeholder="Student's first or last name" TextMode="SingleLine" />
                                            <span class="input-group-btn">
                                                <asp:LinkButton id="FindStudent" CssClass="btn btn-warning" onClick="FindStudent_Click" RunAt="server"><span class="fas fa-search"></span> Search</asp:LinkButton>
                                            </span>
                                        </div>
                                    </div>
                                    <asp:GridView ID="gvStudents" runat="server" CssClass="table table-striped" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="srcStudents" EmptyDataText="No students' name matched the search." AllowPaging="True" AllowSorting="True" GridLines="None">
                                        <Columns>
                                            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
                                            <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" Visible="false" SortExpression="id" />
                                            <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                            <asp:BoundField DataField="firstname" HeaderText="First" SortExpression="firstname" />
                                            <asp:BoundField DataField="lastname" HeaderText="Last" SortExpression="lastname" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">Add Student</div>
                                <div class="card-body">
                                    <asp:DetailsView ID="dvStudent" runat="server" CssClass="table table-striped" AutoGenerateRows="False" DataKeyNames="id" DataSourceID="srcStudents" DefaultMode="Insert" GridLines="None">
                                        <Fields>
                                            <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                            <asp:BoundField DataField="firstname" HeaderText="First" SortExpression="firstname" />
                                            <asp:BoundField DataField="lastname" HeaderText="Last" SortExpression="lastname" />
                                            <asp:CommandField ButtonType="Button" InsertText="Save" ShowInsertButton="True" />
                                        </Fields>
                                    </asp:DetailsView>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row" style="margin-top:20px;">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">Classes</div>
                                <div class="card-body">
                                    <asp:GridView ID="gvClasses" CssClass="table table-striped" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="srcClasses" EmptyDataText="There are no data records to display." GridLines="None">
                                        <Columns>
                                            <asp:CommandField ShowEditButton="True" />
                                            <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" Visible="false" SortExpression="id" />
                                            <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                            <asp:BoundField DataField="name" HeaderText="Class" SortExpression="name" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">Add Class</div>
                                <div class="card-body">
                                    <asp:DetailsView ID="dvClasses" CssClass="table table-striped" runat="server" AutoGenerateRows="False" CellPadding="4" DataKeyNames="id" DataSourceID="srcClasses" DefaultMode="Insert" GridLines="None" AllowPaging="True" DataMember="DefaultView">
                                        <Fields>
                                            <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" Visible="False" />
                                            <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                            <asp:BoundField DataField="name" HeaderText="Class" SortExpression="name" />
                                            <asp:CommandField ButtonType="Button" InsertText="Save" ShowEditButton="True" ShowInsertButton="True" />
                                        </Fields>
                                    </asp:DetailsView>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row" style="margin-top:20px;">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">Instructors</div>
                                <div class="card-body">
                                    <asp:GridView ID="gvInstructors" CssClass="table table-striped" runat="server" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="srcInstructors" EmptyDataText="There are no data records to display." AllowPaging="True" AllowSorting="True" GridLines="None">
                                        <Columns>
                                            <asp:CommandField ShowEditButton="True" />
                                            <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" Visible="false" SortExpression="id" />
                                            <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                            <asp:BoundField DataField="firstname" HeaderText="First" SortExpression="firstname" />
                                            <asp:BoundField DataField="lastname" HeaderText="Last" SortExpression="lastname" />
                                            <asp:BoundField DataField="email" HeaderText="Email" visible="false" SortExpression="email" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">Add Instructor</div>
                                <div class="card-body">
                                    <asp:DetailsView ID="dvInstructor" CssClass="table table-striped" runat="server" AutoGenerateRows="False" DataKeyNames="id" DataSourceID="srcInstructors" DefaultMode="Insert" GridLines="None">
                                        <Fields>
                                            <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                            <asp:BoundField DataField="firstname" HeaderText="First" SortExpression="firstname" />
                                            <asp:BoundField DataField="lastname" HeaderText="Last" SortExpression="lastname" />
                                            <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                                            <asp:CommandField ButtonType="Button" InsertText="Save" ShowInsertButton="True" />
                                        </Fields>
                                    </asp:DetailsView>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row" style="margin-top:20px;">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">Locations</div>
                                <div class="card-body">
                                    <asp:GridView ID="gvLocations" CssClass="table table-striped" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="srcLocations" EmptyDataText="There are no data records to display." GridLines="None">
                                        <Columns>
                                            <asp:CommandField ShowEditButton="True" />
                                            <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" Visible="False" SortExpression="id" />
                                            <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                            <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">Add Location</div>
                                <div class="card-body">
                                    <asp:DetailsView ID="dvLocations" CssClass="table table-striped" runat="server" AutoGenerateRows="False" DataKeyNames="id" DataSourceID="srcLocations" DefaultMode="Insert" GridLines="None">
                                        <Fields>
                                            <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                            <asp:BoundField DataField="name" HeaderText="Location" SortExpression="name" />
                                            <asp:CommandField ButtonType="Button" InsertText="Save" ShowInsertButton="True" />
                                        </Fields>
                                    </asp:DetailsView>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </form>
    </div>

    <asp:SqlDataSource ID="srcStudents" runat="server"
        ConnectionString="<%$ ConnectionStrings:Heroku %>"
        ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"
        SelectCommand="SELECT id, active, firstname, lastname FROM old_students WHERE lastname LIKE @search_text || '%' OR firstname LIKE @search_text || '%' ORDER BY lastname, firstname"
        InsertCommand="INSERT INTO old_students (active, firstname, lastname) VALUES (@active, @firstname, @lastname)"
        UpdateCommand="UPDATE old_students SET active = @active, firstname = @firstname, lastname = @lastname WHERE id = @id::uuid"
        DeleteCommand="SELECT FROM old_delete_student(@id)" >
        <SelectParameters>
            <asp:ControlParameter Name="search_text" DbType="String" ControlID="StudentSearch" PropertyName="Text" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="active" Type="Boolean" />
            <asp:Parameter Name="firstname" Type="String" />
            <asp:Parameter Name="lastname" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="active" Type="Boolean" />
            <asp:Parameter Name="firstname" Type="String" />
            <asp:Parameter Name="lastname" Type="String" />
            <asp:Parameter Name="id" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="id" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="srcClasses" runat="server"
        ConnectionString="<%$ ConnectionStrings:Heroku %>"
        ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"
        DeleteCommand="DELETE FROM old_classes WHERE id = @id::uuid"
        InsertCommand="INSERT INTO old_classes (active, name) VALUES (@active, @name)"
        SelectCommand="SELECT id, active, name FROM old_classes ORDER BY name"
        UpdateCommand="UPDATE old_classes SET active = @active, name = @name WHERE id = @id::uuid">
        <InsertParameters>
            <asp:Parameter Name="active" Type="Boolean" />
            <asp:Parameter Name="name" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="active" Type="Boolean" />
            <asp:Parameter Name="name" Type="String" />
            <asp:Parameter Name="id" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="id" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="srcInstructors" runat="server"
        ConnectionString="<%$ ConnectionStrings:Heroku %>"
        ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"
        DeleteCommand="DELETE FROM old_instructors WHERE id = @id"
        InsertCommand="INSERT INTO old_instructors (active, firstname, lastname, email) VALUES (@active, @firstname, @lastname, @email)"
            SelectCommand="SELECT id, active, firstname, lastname, email FROM old_instructors ORDER BY lastname, firstname"
            UpdateCommand="UPDATE old_instructors SET active = @active, firstname = @firstname, lastname = @lastname, email = @email WHERE id = @id::uuid">
        <InsertParameters>
            <asp:Parameter Name="active" Type="Boolean" />
            <asp:Parameter Name="firstname" Type="String" />
            <asp:Parameter Name="lastname" Type="String" />
            <asp:Parameter Name="email" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="active" Type="Boolean" />
            <asp:Parameter Name="firstname" Type="String" />
            <asp:Parameter Name="lastname" Type="String" />
            <asp:Parameter Name="email" Type="String" />
            <asp:Parameter Name="id" Type="Object" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="id" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="srcLocations" runat="server"
        ConnectionString="<%$ ConnectionStrings:Heroku %>"
        ProviderName="<%$ ConnectionStrings:Heroku.ProviderName %>"
        DeleteCommand="DELETE FROM old_locations WHERE id = @id::uuid"
        InsertCommand="INSERT INTO old_locations (active, name) VALUES (@active, @name)"
        SelectCommand="SELECT id, active, name FROM old_locations ORDER BY name"
        UpdateCommand="UPDATE old_locations SET active = @active, name = @name WHERE id = @id::uuid">
        <InsertParameters>
            <asp:Parameter Name="active" Type="Boolean" />
            <asp:Parameter Name="name" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="active" Type="Boolean" />
            <asp:Parameter Name="name" Type="String" />
            <asp:Parameter Name="id" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="id" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.4/umd/popper.min.js" integrity="sha256-EGs9T1xMHdvM1geM8jPpoo8EZ1V1VRsmcJz8OByENLA=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha256-VsEqElsCHSGmnmHXGQzvoWjWwoznFSZc6hs7ARLRacQ=" crossorigin="anonymous"></script>    </body>
</html>