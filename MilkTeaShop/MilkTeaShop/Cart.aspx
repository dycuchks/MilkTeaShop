<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="MilkTeaShop.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="page-title" style="margin-bottom: 20px;">
        <h2>🛒 我的购物车</h2>
    </div>

    <asp:Panel ID="pnlCart" runat="server" CssClass="cart-container">
        
        <!-- 左侧：商品列表 -->
        <div class="cart-list-section">
            <asp:GridView ID="gvCart" runat="server" AutoGenerateColumns="False" 
                CssClass="cart-table" GridLines="None" DataKeyNames="DetailId"
                OnRowDeleting="gvCart_RowDeleting" OnRowCommand="gvCart_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="商品信息">
                        <ItemTemplate>
                            <div class="cart-product-info">
                                <img src='<%# Eval("ImageUrl") %>' class="cart-img" onerror="this.src='https://placehold.co/60x60?text=Tea'"/>
                                <div>
                                    <div class="cart-name"><%# Eval("ProductName") %></div>
                                    <div style="color:#999; font-size:12px;"><%# Eval("Category") %></div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="单价">
                        <ItemTemplate>
                            ¥ <%# Eval("PriceAtTime", "{0:F2}") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="数量">
                        <ItemTemplate>
                            <!-- 加减号组件 -->
                            <div class="qty-group">
                                <!-- 减号 -->
                                <asp:LinkButton ID="btnMinus" runat="server" CommandName="DecreaseQty" CommandArgument='<%# Eval("DetailId") %>' CssClass="btn-qty">-</asp:LinkButton>
                                <!-- 数量显示 (只读) -->
                                <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Quantity") %>' CssClass="qty-input-clean" ReadOnly="true"></asp:TextBox>
                                <!-- 加号 -->
                                <asp:LinkButton ID="btnPlus" runat="server" CommandName="IncreaseQty" CommandArgument='<%# Eval("DetailId") %>' CssClass="btn-qty">+</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="小计">
                        <ItemTemplate>
                            <strong style="color:#e74c3c;">¥ <%# Eval("Subtotal", "{0:F2}") %></strong>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="操作">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" Text="删除" CommandName="Delete" CssClass="btn-delete" OnClientClick="return confirm('确定要移除吗？');"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <!-- 右侧：结算信息填写 -->
        <div class="cart-summary-section">
            <h3 style="margin-top:0;">订单确认</h3>
            
            <div class="checkout-form-group">
                <label class="checkout-label">收货人手机</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="checkout-input" placeholder="请输入联系电话"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="* 必填" ForeColor="Red" Display="Dynamic" ValidationGroup="Checkout"></asp:RequiredFieldValidator>
            </div>

            <div class="checkout-form-group">
                <label class="checkout-label">配送地址</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="checkout-input" TextMode="MultiLine" Rows="3" placeholder="请输入宿舍号/详细地址"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" ErrorMessage="* 必填" ForeColor="Red" Display="Dynamic" ValidationGroup="Checkout"></asp:RequiredFieldValidator>
            </div>

            <div style="border-top:1px solid #eee; margin:15px 0;"></div>

            <div class="summary-row">
                <span>商品总数</span>
                <asp:Label ID="lblCount" runat="server" Text="0"></asp:Label>
            </div>
            
            <div class="summary-total">
                <span>应付总额</span>
                <span class="total-price">
                    ¥ <asp:Label ID="lblTotal" runat="server" Text="0.00"></asp:Label>
                </span>
            </div>

            <!-- ValidationGroup="Checkout" 确保点击结算时才验证上面的输入框 -->
            <asp:Button ID="btnCheckout" runat="server" Text="提交订单" CssClass="btn" OnClick="btnCheckout_Click" ValidationGroup="Checkout" />
        </div>

    </asp:Panel>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-cart">
        <img src="https://img.icons8.com/clouds/200/000000/shopping-cart-loaded.png" alt="Empty" style="width:150px; opacity:0.8;"/>
        <h3>购物车空空如也</h3>
        <p>快去选几杯好喝的奶茶犒劳自己吧！</p>
        <a href="Default.aspx" class="btn" style="width:200px; display:inline-block;">去点单 🧋</a>
    </asp:Panel>

</asp:Content>