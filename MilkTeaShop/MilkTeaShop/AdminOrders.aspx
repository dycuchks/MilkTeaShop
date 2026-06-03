<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminOrders.aspx.cs" Inherits="MilkTeaShop.AdminOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
        <h2 style="color:#333;">📋 订单管理中心</h2>
        <div>
            <a href="AdminOrders.aspx" class="btn" style="width:auto; padding:8px 20px; font-size:14px; background:#666;">🔄 刷新数据</a>
        </div>
    </div>

    <!-- 订单列表 -->
    <div style="background:white; padding:20px; border-radius:10px; box-shadow:0 5px 15px rgba(0,0,0,0.05);">
        
        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" 
            CssClass="admin-table" GridLines="None" DataKeyNames="Id"
            OnRowCommand="gvOrders_RowCommand" OnRowDataBound="gvOrders_RowDataBound">
            
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="50px" />
                
                <asp:TemplateField HeaderText="订单内容" ItemStyle-Width="300px">
                    <ItemTemplate>
                        <!-- 嵌套的Repeater显示具体的商品列表 -->
                        <div class="order-detail-list">
                            <asp:Repeater ID="rptDetails" runat="server">
                                <ItemTemplate>
                                    <div class="order-detail-item">
                                        <img src='<%# Eval("ImageUrl") %>' class="mini-img" onerror="this.src='https://placehold.co/30x30'"/>
                                        <span class="item-info"><%# Eval("ProductName") %></span>
                                        <span class="item-qty">x <%# Eval("Quantity") %></span>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Username" HeaderText="用户" ItemStyle-Width="80px" />
                
                <asp:TemplateField HeaderText="收货信息" ItemStyle-Width="200px">
                    <ItemTemplate>
                        <div style="font-size:13px;">
                            <div style="font-weight:bold;">📞 <%# Eval("ReceiverPhone") %></div>
                            <div style="color:#888;">📍 <%# Eval("ReceiverAddress") %></div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="OrderDate" HeaderText="时间" DataFormatString="{0:MM-dd HH:mm}" ItemStyle-Width="100px" />
                
                <asp:TemplateField HeaderText="总金额" ItemStyle-Width="80px">
                    <ItemTemplate>
                        <strong style="color:#e74c3c;">¥ <%# Eval("TotalAmount", "{0:F2}") %></strong>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="状态" ItemStyle-Width="80px">
                    <ItemTemplate>
                        <asp:Label ID="lblStatusBadge" runat="server" Text='<%# Eval("Status") %>' CssClass="status-badge"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="操作" ItemStyle-Width="180px">
                    <ItemTemplate>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control" Style="width:100px; padding:4px; display:inline-block; font-size:12px;">
                            <asp:ListItem>待处理</asp:ListItem>
                            <asp:ListItem>制作中</asp:ListItem>
                            <asp:ListItem>派送中</asp:ListItem>
                            <asp:ListItem>已完成</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Button ID="btnUpdate" runat="server" Text="更新" CommandName="UpdateStatus" CommandArgument="<%# Container.DataItemIndex %>" CssClass="btn-action" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

            <EmptyDataTemplate>
                <div style="text-align:center; padding:40px; color:#999;">目前没有订单。</div>
            </EmptyDataTemplate>
        </asp:GridView>

    </div>
    
    <div style="margin-top:20px; text-align:center;">
        <asp:Label ID="lblMsg" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>
    </div>

</asp:Content>