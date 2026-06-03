<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminProducts.aspx.cs" Inherits="MilkTeaShop.AdminProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h2 style="color:#333; margin-bottom:20px;">🥤 商品管理中心</h2>

    <!-- 1. 添加新商品区域 -->
    <div class="add-product-panel">
        <div class="panel-title">✨ 上架新饮品</div>
        
        <div class="form-grid">
            <!-- 第一行 -->
            <div>
                <label style="display:block; margin-bottom:5px; color:#666;">饮品名称</label>
                <asp:TextBox ID="txtNewName" runat="server" CssClass="admin-input" placeholder="例如：冰摇红梅黑加仑"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtNewName" ErrorMessage="* 必填" ForeColor="Red" ValidationGroup="Add"></asp:RequiredFieldValidator>
            </div>
            <div>
                <label style="display:block; margin-bottom:5px; color:#666;">所属分类</label>
                <asp:DropDownList ID="ddlNewCategory" runat="server" CssClass="admin-input">
                    <asp:ListItem>经典</asp:ListItem>
                    <asp:ListItem>果茶</asp:ListItem>
                    <asp:ListItem>奶盖</asp:ListItem>
                    <asp:ListItem>牛乳</asp:ListItem>
                    <asp:ListItem>新品</asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- 第二行 -->
            <div>
                <label style="display:block; margin-bottom:5px; color:#666;">价格 (元)</label>
                <asp:TextBox ID="txtNewPrice" runat="server" CssClass="admin-input" TextMode="Number" placeholder="18"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtNewPrice" ErrorMessage="* 必填" ForeColor="Red" ValidationGroup="Add"></asp:RequiredFieldValidator>
            </div>
            <div>
                <label style="display:block; margin-bottom:5px; color:#666;">图片上传</label>
                <!-- 文件上传控件 -->
                <asp:FileUpload ID="fuImage" runat="server" CssClass="admin-input" />
                <div style="font-size:12px; color:#999; margin-top:5px;">如果不上传，将使用默认图片</div>
            </div>

            <!-- 第三行：全宽 -->
            <div class="form-row-full">
                <label style="display:block; margin-bottom:5px; color:#666;">商品描述</label>
                <asp:TextBox ID="txtNewDesc" runat="server" CssClass="admin-input" TextMode="MultiLine" Rows="2" placeholder="简短介绍一下口味..."></asp:TextBox>
            </div>
            
            <!-- 提交按钮 -->
            <div class="form-row-full" style="text-align:right;">
                <asp:Button ID="btnAdd" runat="server" Text="+ 立即上架" CssClass="btn-blue" OnClick="btnAdd_Click" ValidationGroup="Add" />
            </div>
        </div>
        
        <div style="margin-top:10px;">
            <asp:Label ID="lblMsg" runat="server" Font-Bold="true"></asp:Label>
        </div>
    </div>

    <!-- 2. 商品列表区域 (支持编辑和删除) -->
    <div style="background:white; padding:20px; border-radius:10px; box-shadow:0 5px 15px rgba(0,0,0,0.05);">
        
        <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" 
            CssClass="admin-table" GridLines="None" DataKeyNames="Id"
            OnRowEditing="gvProducts_RowEditing" 
            OnRowCancelingEdit="gvProducts_RowCancelingEdit" 
            OnRowUpdating="gvProducts_RowUpdating"
            OnRowDeleting="gvProducts_RowDeleting"
            AllowPaging="True" PageSize="8" OnPageIndexChanging="gvProducts_PageIndexChanging">
            
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="True" ItemStyle-Width="50px" />
                
                <asp:TemplateField HeaderText="图片" ItemStyle-Width="80px">
                    <ItemTemplate>
                        <img src='<%# Eval("ImageUrl") %>' class="mini-img" onerror="this.src='https://placehold.co/40x40'"/>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <!-- 编辑模式下也可以修改图片路径，这里简化为只读预览，防止出错 -->
                        <img src='<%# Eval("ImageUrl") %>' class="mini-img"/>
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="名称">
                    <ItemTemplate><%# Eval("ProductName") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEditName" runat="server" Text='<%# Bind("ProductName") %>' CssClass="edit-input"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="分类" ItemStyle-Width="100px">
                    <ItemTemplate><%# Eval("Category") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlEditCategory" runat="server" SelectedValue='<%# Bind("Category") %>' CssClass="edit-input">
                            <asp:ListItem>经典</asp:ListItem>
                            <asp:ListItem>果茶</asp:ListItem>
                            <asp:ListItem>奶盖</asp:ListItem>
                            <asp:ListItem>牛乳</asp:ListItem>
                            <asp:ListItem>新品</asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="价格" ItemStyle-Width="80px">
                    <ItemTemplate>¥ <%# Eval("Price") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEditPrice" runat="server" Text='<%# Bind("Price") %>' CssClass="edit-input" TextMode="Number"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="描述">
                    <ItemTemplate><%# Eval("Description") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEditDesc" runat="server" Text='<%# Bind("Description") %>' CssClass="edit-input"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="操作" ItemStyle-Width="140px">
                    <ItemTemplate>
                        <!-- 正常状态显示的按钮 -->
                        <asp:Button ID="btnEdit" runat="server" Text="编辑" CommandName="Edit" CssClass="btn-action" style="background-color:#3498db;" />
                        <asp:Button ID="btnDelete" runat="server" Text="下架" CommandName="Delete" CssClass="btn-action" style="background-color:#e74c3c;" OnClientClick="return confirm('确定要下架这个商品吗？');" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <!-- 编辑状态显示的按钮 -->
                        <asp:Button ID="btnUpdate" runat="server" Text="保存" CommandName="Update" CssClass="btn-action" style="background-color:#2ecc71;" />
                        <asp:Button ID="btnCancel" runat="server" Text="取消" CommandName="Cancel" CssClass="btn-gray" />
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
            
            <PagerStyle HorizontalAlign="Center" CssClass="pager-container" />
        </asp:GridView>

    </div>

</asp:Content>