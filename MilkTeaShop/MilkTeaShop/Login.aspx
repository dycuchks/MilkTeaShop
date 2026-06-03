<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MilkTeaShop.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-title { text-align: center; color: #d2a679; margin-bottom: 30px; font-size: 24px; font-weight: bold; }
        .link-text { text-align: center; margin-top: 15px; font-size: 14px; }
        .link-text a { color: #d2a679; text-decoration: none; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="form-box">
        <div class="page-title">欢迎回来</div>
        
        <div class="form-group">
            <label>用户名</label>
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="请输入用户名"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUsername" 
                ErrorMessage="⚠ 请输入用户名" ForeColor="#e74c3c" Display="Dynamic" Font-Size="12px"></asp:RequiredFieldValidator>
        </div>

        <div class="form-group">
            <label>密码</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="请输入密码"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" 
                ErrorMessage="⚠ 请输入密码" ForeColor="#e74c3c" Display="Dynamic" Font-Size="12px"></asp:RequiredFieldValidator>
        </div>

        <div class="form-group" style="margin-top: 30px;">
            <asp:Button ID="btnLogin" runat="server" Text="登 录" CssClass="btn" OnClick="btnLogin_Click" />
        </div>

        <div class="link-text">
            还没有账号？ <a href="Register.aspx">立即免费注册</a>
        </div>
        
        <div style="text-align:center; margin-top:15px;">
            <asp:Label ID="lblMsg" runat="server" ForeColor="#e74c3c" Font-Bold="true"></asp:Label>
        </div>
    </div>

</asp:Content>