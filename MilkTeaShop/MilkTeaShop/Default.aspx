<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MilkTeaShop.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- 可以在这里引入特定样式，目前主要用Main.css -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- 标题与搜索 -->
    <div style="text-align:center; margin-bottom:30px;">
        <h1 style="color:#d2a679; margin-bottom:10px;">🧋 遇见·好茶</h1>
        <p style="color:#999; font-size:14px;">精心调制每一杯，温暖你的四季</p>
    </div>

    <div class="search-box">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="输入奶茶名称搜索..."></asp:TextBox>
        <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="search-btn" OnClick="btnSearch_Click" />
    </div>

    <!-- 消息提示区 -->
    <div style="text-align:center; margin-bottom:20px; height:20px;">
        <asp:Label ID="lblMsg" runat="server" ForeColor="#d2a679" Font-Bold="true" Font-Size="16px"></asp:Label>
    </div>

    <!-- 核心：使用 ListView 实现卡片布局 -->
    <asp:ListView ID="lvProducts" runat="server" DataKeyNames="Id" 
        OnPagePropertiesChanging="lvProducts_PagePropertiesChanging" 
        OnItemCommand="lvProducts_ItemCommand">
        
        <LayoutTemplate>
            <!-- 商品网格容器 -->
            <div class="product-grid">
                <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
            </div>

            <!-- 分页器 -->
            <div class="pager-container">
                <asp:DataPager ID="dpProducts" runat="server" PageSize="8">
                    <Fields>
                        <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="false" ShowPreviousPageButton="true" ShowNextPageButton="false" PreviousPageText="< 上一页" ButtonCssClass="pager-btn" />
                        <asp:NumericPagerField CurrentPageLabelCssClass="pager-btn pager-current" NumericButtonCssClass="pager-btn" />
                        <asp:NextPreviousPagerField ButtonType="Button" ShowLastPageButton="false" ShowNextPageButton="true" ShowPreviousPageButton="false" NextPageText="下一页 >" ButtonCssClass="pager-btn" />
                    </Fields>
                </asp:DataPager>
            </div>
        </LayoutTemplate>

        <ItemTemplate>
            <!-- 单个卡片模板 -->
            <div class="product-card">
                <div class="card-img-wrapper">
                    <img src='<%# Eval("ImageUrl") %>' alt="奶茶图片" class="card-img" onerror="this.src='https://placehold.co/400x300?text=MilkTea'"/>
                </div>
                <div class="card-body">
                    <div class="card-tag"><%# Eval("Category") %></div>
                    <div class="card-title"><%# Eval("ProductName") %></div>
                    <div class="card-desc"><%# Eval("Description") %></div>
                    
                    <div class="card-footer">
                        <div class="card-price">¥ <%# Eval("Price", "{0:F2}") %></div>
                        <asp:Button ID="btnAddCart" runat="server" Text="加入购物车" 
                            CommandName="AddToCart" CommandArgument='<%# Eval("Id") %>'
                            CssClass="btn-add" />
                    </div>
                </div>
            </div>
        </ItemTemplate>

        <EmptyDataTemplate>
            <div style="text-align:center; padding:50px; color:#999;">
                <h3>😕 没有找到相关饮品</h3>
                <p>试试其他关键词吧</p>
            </div>
        </EmptyDataTemplate>

    </asp:ListView>

</asp:Content>