using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.IO; // 需要引用IO来处理文件上传

namespace MilkTeaShop
{
    public partial class AdminProducts : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MilkTeaConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 权限验证
            if (Session["UserType"] == null || Session["UserType"].ToString() != "2")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 按ID倒序，这样新添加的会在最前面
                string sql = "SELECT * FROM Products ORDER BY Id DESC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvProducts.DataSource = dt;
                gvProducts.DataBind();
            }
        }

        // --- 1. 添加商品逻辑 ---
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string name = txtNewName.Text.Trim();
            string category = ddlNewCategory.SelectedValue;
            string price = txtNewPrice.Text.Trim();
            string desc = txtNewDesc.Text.Trim();
            string imageUrl = "/Images/tea1.jpg"; // 默认图片

            // 处理文件上传
            if (fuImage.HasFile)
            {
                try
                {
                    // 获取文件名
                    string fileName = Path.GetFileName(fuImage.FileName);
                    // 保存到服务器的 Images 文件夹
                    string savePath = Server.MapPath("~/Images/") + fileName;
                    fuImage.SaveAs(savePath);
                    // 设置数据库存的相对路径
                    imageUrl = "/Images/" + fileName;
                }
                catch (Exception)
                {
                    // 如果上传失败（比如没文件夹），就用默认图，防止报错
                    lblMsg.Text = "⚠️ 图片上传失败，已使用默认图。";
                    lblMsg.ForeColor = System.Drawing.Color.Orange;
                }
            }

            // 插入数据库
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO Products (ProductName, Category, Price, Description, ImageUrl) VALUES (@n, @c, @p, @d, @img)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@n", name);
                cmd.Parameters.AddWithValue("@c", category);
                cmd.Parameters.AddWithValue("@p", price);
                cmd.Parameters.AddWithValue("@d", desc);
                cmd.Parameters.AddWithValue("@img", imageUrl);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // 清空输入框并刷新
            txtNewName.Text = "";
            txtNewPrice.Text = "";
            txtNewDesc.Text = "";
            lblMsg.Text = "✅ 商品上架成功！";
            lblMsg.ForeColor = System.Drawing.Color.Green;
            BindGrid();
        }

        // --- 2. 进入编辑模式 ---
        protected void gvProducts_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvProducts.EditIndex = e.NewEditIndex;
            BindGrid();
        }

        // --- 3. 取消编辑 ---
        protected void gvProducts_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvProducts.EditIndex = -1;
            BindGrid();
        }

        // --- 4. 更新数据 ---
        protected void gvProducts_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // 获取主键 ID
            int productId = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);

            // 获取用户修改后的值 (从 EditItemTemplate 里的控件找)
            TextBox txtName = (TextBox)gvProducts.Rows[e.RowIndex].FindControl("txtEditName");
            DropDownList ddlCat = (DropDownList)gvProducts.Rows[e.RowIndex].FindControl("ddlEditCategory");
            TextBox txtPrice = (TextBox)gvProducts.Rows[e.RowIndex].FindControl("txtEditPrice");
            TextBox txtDesc = (TextBox)gvProducts.Rows[e.RowIndex].FindControl("txtEditDesc");

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE Products SET ProductName=@n, Category=@c, Price=@p, Description=@d WHERE Id=@id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@n", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@c", ddlCat.SelectedValue);
                cmd.Parameters.AddWithValue("@p", txtPrice.Text.Trim());
                cmd.Parameters.AddWithValue("@d", txtDesc.Text.Trim());
                cmd.Parameters.AddWithValue("@id", productId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            gvProducts.EditIndex = -1; // 退出编辑模式
            BindGrid(); // 刷新
        }

        // --- 5. 删除商品 ---
        protected void gvProducts_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int productId = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 注意：如果商品被订单引用了，直接删除可能会报错（外键约束）
                // 简单的做法是：先删该商品相关的订单明细，或者只把商品标记为下架（逻辑删除）
                // 这里为了大作业简单，我们尝试直接物理删除。如果报错，提示用户。
                try
                {
                    string sql = "DELETE FROM Products WHERE Id = @id";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@id", productId);
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    lblMsg.Text = "✅ 商品下架成功。";
                    lblMsg.ForeColor = System.Drawing.Color.Green;
                }
                catch (Exception)
                {
                    lblMsg.Text = "❌ 删除失败：该商品可能存在于历史订单中，无法直接删除。";
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                }
            }

            BindGrid();
        }

        // --- 6. 分页 ---
        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProducts.PageIndex = e.NewPageIndex;
            BindGrid();
        }
    }
}