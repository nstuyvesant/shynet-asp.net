<%@ Page Language="C#" AutoEventWireup="true" Debug="true" CodeFile="admin-test.aspx.cs" Inherits="adminTest" %>
<!DOCTYPE html>
<html lang="en">
  <head runat="server">
    <title>SHY Administration</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="x-ua-compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha256-NJWeQ+bs82iAeoT5Ktmqbi3NXwxcHlfaVejzJI2dklU=" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-+d0P83n9kaQMCwj8F4RJB66tzIwOKmrdb46+porD/OvrJ+37WqIM7UoBtwHO6Nlg" crossorigin="anonymous" />
  </head>
  <body>
    <div class="container" style="margin-top:15px;">
      <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <asp:UpdatePanel ID="updatePanel1" runat="server">
          <ContentTemplate>

            <div class="panel panel-primary">
              <div class="panel-heading">
                <h4>Students</h4>
              </div>
              <div class="panel-body">
                <h3>Search for students</h3>
                <div class="form-group">
                  <label class="sr-only" for="StudentSearch">Find Student</label>
                  <div class="input-group">
                    <asp:TextBox ID="StudentSearch" CssClass="form-control" Text="" autofocus runat="server" MaxLength="20" placeholder="Student's first or last name" TextMode="SingleLine" runat="server" />
                    <span class="input-group-btn">
                      <asp:LinkButton id="FindStudent" class="btn btn-warning" onclick="FindStudent_Click" runat="server"><span class="fas fa-search"></span> Search</asp:LinkButton>
                    </span>
                  </div>
                </div>
                <asp:GridView ID="gvStudents" runat="server" CssClass="table table-striped" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="srcStudents" EmptyDataText="No students' name matched the search." AllowPaging="True" AllowSorting="True">
                  <Columns>
                    <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
                    <asp:BoundField DataField="id"  CssClass="form-control" HeaderText="id" ReadOnly="True" Visible="false" SortExpression="id" />
                    <asp:CheckBoxField DataField="active" CssClass="form-control" HeaderText="Active" SortExpression="active" />
                    <asp:BoundField DataField="firstname"  CssClass="form-control" HeaderText="First" SortExpression="firstname" />
                    <asp:BoundField DataField="lastname"  CssClass="form-control" HeaderText="Last" SortExpression="lastname" />
                  </Columns>
                </asp:GridView>
              </div>
            </div>



                        <h3>Add new student</h3>
                        <asp:DetailsView ID="dvStudent" runat="server" Height="50px" Width="436px" AutoGenerateRows="False" CellPadding="4" DataKeyNames="id" DataSourceID="srcStudents" DefaultMode="Insert" ForeColor="#333333" GridLines="None">
                            <Fields>
                                <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                <asp:BoundField DataField="firstname" HeaderText="First" SortExpression="firstname" />
                                <asp:BoundField DataField="lastname" HeaderText="Last" SortExpression="lastname" />
                                <asp:CommandField ButtonType="Button" InsertText="Save" ShowInsertButton="True" />
                            </Fields>
                            <AlternatingRowStyle BackColor="White" />
                            <CommandRowStyle BackColor="#D1DDF1" Font-Bold="True" />
                            <EditRowStyle BackColor="#2461BF" />
                            <FieldHeaderStyle BackColor="#DEE8F5" Font-Bold="True" />
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#EFF3FB" />
                        </asp:DetailsView>

                        <h2>Classes</h2>
                        <h3>Edit classes</h3>

                        <asp:GridView ID="gvClasses" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="srcClasses" EmptyDataText="There are no data records to display." Width="436px" CellPadding="4" ForeColor="#333333" GridLines="None">
                            <Columns>
                                <asp:CommandField ShowEditButton="True" />
                                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" Visible="false" SortExpression="id" />
                                <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" >
                                  <HeaderStyle HorizontalAlign="Center" />
                                  <ItemStyle HorizontalAlign="Center" />
                                </asp:CheckBoxField>
                                <asp:BoundField DataField="name" HeaderText="Class" SortExpression="name" >
                                  <HeaderStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                            </Columns>
                            <AlternatingRowStyle BackColor="White" />
                            <EditRowStyle BackColor="#2461BF" />
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#EFF3FB" />
                            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            <SortedAscendingCellStyle BackColor="#F5F7FB" />
                            <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                            <SortedDescendingCellStyle BackColor="#E9EBEF" />
                            <SortedDescendingHeaderStyle BackColor="#4870BE" />
                        </asp:GridView><br />

                        <h3>Add new class</h3>
                        <asp:DetailsView ID="dvClasses" runat="server" AutoGenerateRows="False" CellPadding="4" DataKeyNames="id" DataSourceID="srcClasses" DefaultMode="Insert" ForeColor="#333333" GridLines="None" Height="50px" Width="436px" AllowPaging="True" DataMember="DefaultView">
                            <Fields>
                                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" Visible="False" />
                                <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                <asp:BoundField DataField="name" HeaderText="Class" SortExpression="name" >
                                  <ControlStyle Width="300px" />
                                </asp:BoundField>
                                <asp:CommandField ButtonType="Button" InsertText="Save" ShowEditButton="True" ShowInsertButton="True" />
                            </Fields>
                            <AlternatingRowStyle BackColor="White" />
                            <CommandRowStyle BackColor="#D1DDF1" Font-Bold="True" />
                            <EditRowStyle BackColor="#2461BF" />
                            <FieldHeaderStyle BackColor="#DEE8F5" Font-Bold="True" />
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#EFF3FB" />
                        </asp:DetailsView>
                        <br />

                        <h2>Instructors</h2>
                        <h3>Edit instructors</h3>
                        <asp:GridView ID="gvInstructors" runat="server" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="srcInstructors" EmptyDataText="There are no data records to display." AllowPaging="True" AllowSorting="True" Width="436px" CellPadding="4" ForeColor="#333333" GridLines="None">
                            <Columns>
                                <asp:CommandField ShowEditButton="True" />
                                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" Visible="false" SortExpression="id" />
                                <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" >
                                  <HeaderStyle HorizontalAlign="Center" />
                                  <ItemStyle HorizontalAlign="Center" />
                                </asp:CheckBoxField>
                                <asp:BoundField DataField="firstname" HeaderText="First" SortExpression="firstname" >
                                  <HeaderStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="lastname" HeaderText="Last" SortExpression="lastname" >
                                  <HeaderStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="email" HeaderText="Email" visible="false" SortExpression="email" >
                                  <HeaderStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                            </Columns>
                            <AlternatingRowStyle BackColor="White" />
                            <EditRowStyle BackColor="#2461BF" />
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#EFF3FB" />
                            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            <SortedAscendingCellStyle BackColor="#F5F7FB" />
                            <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                            <SortedDescendingCellStyle BackColor="#E9EBEF" />
                            <SortedDescendingHeaderStyle BackColor="#4870BE" />
                        </asp:GridView><br />

                        <h3>Add new instructor</h3>
                        <asp:DetailsView ID="dvInstructor" runat="server" Height="50px" Width="436px" AutoGenerateRows="False" CellPadding="4" DataKeyNames="id" DataSourceID="srcInstructors" DefaultMode="Insert" ForeColor="#333333" GridLines="None">
                            <Fields>
                                <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                <asp:BoundField DataField="firstname" HeaderText="First" SortExpression="firstname" />
                                <asp:BoundField DataField="lastname" HeaderText="Last" SortExpression="lastname" />
                                <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                                <asp:CommandField ButtonType="Button" InsertText="Save" ShowInsertButton="True" />
                            </Fields>
                            <AlternatingRowStyle BackColor="White" />
                            <CommandRowStyle BackColor="#D1DDF1" Font-Bold="True" />
                            <EditRowStyle BackColor="#2461BF" />
                            <FieldHeaderStyle BackColor="#DEE8F5" Font-Bold="True" />
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#EFF3FB" />
                        </asp:DetailsView>

                        <h2>Locations</h2>
                        <h3>Edit locations</h3>
                        <asp:GridView ID="gvLocations" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="srcLocations" EmptyDataText="There are no data records to display." Width="436px" CellPadding="4" ForeColor="#333333" GridLines="None">
                            <Columns>
                                <asp:CommandField ShowEditButton="True" />
                                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" Visible="False" SortExpression="id" />
                                <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" >
                                  <HeaderStyle HorizontalAlign="Center" />
                                  <ItemStyle HorizontalAlign="Center" />
                                </asp:CheckBoxField>
                                <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name" >
                                  <HeaderStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                            </Columns>
                            <AlternatingRowStyle BackColor="White" />
                            <EditRowStyle BackColor="#2461BF" />
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#EFF3FB" />
                            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            <SortedAscendingCellStyle BackColor="#F5F7FB" />
                            <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                            <SortedDescendingCellStyle BackColor="#E9EBEF" />
                            <SortedDescendingHeaderStyle BackColor="#4870BE" />
                        </asp:GridView><br />

                        <h3>Add new location</h3>
                        <asp:DetailsView ID="dvLocations" runat="server" Height="50px" Width="436px" AutoGenerateRows="False" CellPadding="4" DataKeyNames="id" DataSourceID="srcLocations" DefaultMode="Insert" ForeColor="#333333" GridLines="None">
                            <Fields>
                                <asp:CheckBoxField DataField="active" HeaderText="Active" SortExpression="active" />
                                <asp:BoundField DataField="name" HeaderText="Location" SortExpression="name">
                                  <ControlStyle Width="300px" />
                                </asp:BoundField>
                                <asp:CommandField ButtonType="Button" InsertText="Save" ShowInsertButton="True" />
                            </Fields>
                            <AlternatingRowStyle BackColor="White" />
                            <CommandRowStyle BackColor="#D1DDF1" Font-Bold="True" />
                            <EditRowStyle BackColor="#2461BF" />
                            <FieldHeaderStyle BackColor="#DEE8F5" Font-Bold="True" />
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#EFF3FB" />
                        </asp:DetailsView>
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
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha256-98vAGjEDGN79TjHkYWVD4s87rvWkdWLHPs5MC3FvFX4=" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha256-C8oQVJ33cKtnkARnmeWp6SDChkU+u7KvsNMFUzkkUzk=" crossorigin="anonymous"></script>
    </body>
</html>


