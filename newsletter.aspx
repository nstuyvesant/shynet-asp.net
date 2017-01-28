<%@ Page Language="C#" AutoEventWireup="true" CodeFile="newsletter.aspx.cs" Inherits="newsletter" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Schoolhouse Yoga Newsletter</title>
        <style type="text/css">
            .button { FONT-SIZE: 8pt; WIDTH: 76px; FONT-FAMILY: MS Sans Serif; HEIGHT: 24px }
        </style>
    </head>
    <body>
        <form id="Form1" method="post" runat="server">
            <asp:Panel id="pnlInput" runat="server">
                <iframe src="https://www.schoolhouseyoga.com/newsletter.html" height="400" width="800"></iframe><br />
                <asp:RadioButtonList ID="batch" runat="server">
                    <asp:ListItem Value="1">Users 0 to 9,000</asp:ListItem>
                    <asp:ListItem Value="2">Users starting at 9,001</asp:ListItem>
                </asp:RadioButtonList><br />
                <asp:Button id="btnSend" onclick="btnSend_Click" runat="server" Text="Send" CssClass="button"/>
            </asp:Panel>
            <asp:Panel id="pnlConfirmation" runat="server" Visible="False">
                <asp:Literal id="litMsg" runat="server"></asp:Literal>
            </asp:Panel>
        </form>
    </body>
</html>
