<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="MilkTeaShop.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- 可以在这里补充一些注册页特有的微调样式 -->
    <style>
        .page-title { text-align: center; color: #d2a679; margin-bottom: 20px; font-size: 24px; font-weight: bold; }
        .error-msg { font-size: 12px; color: #e74c3c; display: block; margin-top: 4px; }
        .link-text { text-align: center; margin-top: 15px; font-size: 14px; }
        .link-text a { color: #d2a679; text-decoration: none; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="form-box">
        <div class="page-title">加入遇见·好茶</div>
        
        <!-- 用户名 -->
        <div class="form-group">
            <label>用户名</label>
            <asp:TextBox ID="txtUser" runat="server" CssClass="form-control" placeholder="请输入您的用户名"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUser" 
                ErrorMessage="⚠ 用户名不能为空" CssClass="error-msg" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>

        <!-- 密码 -->
        <div class="form-group">
            <label>密码</label>
            <asp:TextBox ID="txtPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="设置您的登录密码"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPass" 
                ErrorMessage="⚠ 密码不能为空" CssClass="error-msg" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>

        <!-- 确认密码 -->
        <div class="form-group">
            <label>确认密码</label>
            <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-control" TextMode="Password" placeholder="请再次输入密码"></asp:TextBox>
            <asp:CompareValidator ID="cvPass" runat="server" ControlToValidate="txtConfirm" ControlToCompare="txtPass"
                ErrorMessage="⚠ 两次输入的密码不一致" CssClass="error-msg" Display="Dynamic"></asp:CompareValidator>
        </div>

        <!-- 电话 -->
        <div class="form-group">
            <label>手机号码</label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="用于接收取餐通知"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" 
                ErrorMessage="⚠ 手机号不能为空" CssClass="error-msg" Display="Dynamic"></asp:RequiredFieldValidator>
            <!-- 正则表达式验证手机号 -->
            <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone"
                ErrorMessage="⚠ 请输入有效的11位手机号" CssClass="error-msg" Display="Dynamic" 
                ValidationExpression="^1[3-9]\d{9}$"></asp:RegularExpressionValidator>
        </div>

        <!-- 地址 -->
        <div class="form-group">
            <label>配送地址</label>
            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="请输入宿舍号或详细地址"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" 
                ErrorMessage="⚠ 地址不能为空" CssClass="error-msg" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>

        <!-- 注册按钮 -->
        <div class="form-group" style="margin-top: 30px;">
            <asp:Button ID="btnRegister" runat="server" Text="立即注册" CssClass="btn" OnClick="btnRegister_Click" />
        </div>

        <!-- 底部链接 -->
        <div class="link-text">
            已有账号？ <a href="Login.aspx">点击这里登录</a>
        </div>
        
        <!-- 全局错误提示 -->
        <div style="text-align:center; margin-top:10px;">
            <asp:Label ID="lblMsg" runat="server" ForeColor="#e74c3c"></asp:Label>
        </div>
    </div>

</asp:Content>