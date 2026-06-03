using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI; // 引入 UI 命名空间

namespace MilkTeaShop
{
    public partial class Default : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MilkTeaConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindList();
            }
        }

        // 绑定数据到 ListView
        private void BindList()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM Products WHERE ProductName LIKE @key OR Category LIKE @key";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@key", "%" + txtSearch.Text.Trim() + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                lvProducts.DataSource = dt;
                lvProducts.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            DataPager dp = lvProducts.FindControl("dpProducts") as DataPager;
            if (dp != null)
            {
                dp.SetPageProperties(0, dp.PageSize, false);
            }
            BindList();
        }

        protected void lvProducts_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            DataPager dp = lvProducts.FindControl("dpProducts") as DataPager;
            if (dp != null)
            {
                dp.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
                BindList();
            }
        }

        // --- 核心修改在这里：点击加入购物车 ---
        protected void lvProducts_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                // Feature 1: 未登录拦截
                // 如果 Session 为空，说明没登录
                if (Session["UserId"] == null)
                {
                    // 使用 JavaScript 弹窗提示，点击确定后跳转到 Login.aspx
                    string script = "alert('温馨提示：\\n\\n您还没有登录，请先登录后再点单哦！'); window.location.href='Login.aspx';";
                    ClientScript.RegisterStartupScript(this.GetType(), "LoginAlert", script, true);
                    return; // 阻止后续代码执行
                }

                // 获取参数
                int productId = Convert.ToInt32(e.CommandArgument);
                int userId = Convert.ToInt32(Session["UserId"]);

                // 执行加入购物车
                AddToShoppingCart(userId, productId);
            }
        }

        private void AddToShoppingCart(int userId, int productId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // A. 获取商品信息 (单价 + 名称)
                // 这次多查一个 ProductName，为了弹窗提示更好看
                decimal price = 0;
                string productName = "";

                SqlCommand cmdProduct = new SqlCommand("SELECT Price, ProductName FROM Products WHERE Id = @pid", conn);
                cmdProduct.Parameters.AddWithValue("@pid", productId);
                SqlDataReader reader = cmdProduct.ExecuteReader();
                if (reader.Read())
                {
                    price = Convert.ToDecimal(reader["Price"]);
                    productName = reader["ProductName"].ToString();
                }
                reader.Close(); // 记得关闭 Reader 才能执行下一个查询

                // B. 检查或创建购物车订单
                int orderId = 0;
                string checkOrderSql = "SELECT Id FROM Orders WHERE UserId = @uid AND Status = N'购物车'";
                SqlCommand cmdCheck = new SqlCommand(checkOrderSql, conn);
                cmdCheck.Parameters.AddWithValue("@uid", userId);
                object orderResult = cmdCheck.ExecuteScalar();

                if (orderResult != null)
                {
                    orderId = Convert.ToInt32(orderResult);
                }
                else
                {
                    string createOrderSql = "INSERT INTO Orders (UserId, Status, TotalAmount) OUTPUT INSERTED.Id VALUES (@uid, N'购物车', 0)";
                    SqlCommand cmdCreate = new SqlCommand(createOrderSql, conn);
                    cmdCreate.Parameters.AddWithValue("@uid", userId);
                    orderId = (int)cmdCreate.ExecuteScalar();
                }

                // C. 更新明细
                string checkDetailSql = "SELECT Id FROM OrderDetails WHERE OrderId = @oid AND ProductId = @pid";
                SqlCommand cmdDetailCheck = new SqlCommand(checkDetailSql, conn);
                cmdDetailCheck.Parameters.AddWithValue("@oid", orderId);
                cmdDetailCheck.Parameters.AddWithValue("@pid", productId);
                object detailResult = cmdDetailCheck.ExecuteScalar();

                if (detailResult != null)
                {
                    // 数量+1
                    string updateQtySql = "UPDATE OrderDetails SET Quantity = Quantity + 1 WHERE Id = @did";
                    SqlCommand cmdUpdate = new SqlCommand(updateQtySql, conn);
                    cmdUpdate.Parameters.AddWithValue("@did", Convert.ToInt32(detailResult));
                    cmdUpdate.ExecuteNonQuery();
                }
                else
                {
                    // 新增明细
                    string insertDetailSql = "INSERT INTO OrderDetails (OrderId, ProductId, Quantity, PriceAtTime) VALUES (@oid, @pid, 1, @price)";
                    SqlCommand cmdInsert = new SqlCommand(insertDetailSql, conn);
                    cmdInsert.Parameters.AddWithValue("@oid", orderId);
                    cmdInsert.Parameters.AddWithValue("@pid", productId);
                    cmdInsert.Parameters.AddWithValue("@price", price);
                    cmdInsert.ExecuteNonQuery();
                }

                // D. 更新总价
                string updateTotalSql = @"UPDATE Orders SET TotalAmount = 
                                        (SELECT ISNULL(SUM(Quantity * PriceAtTime),0) FROM OrderDetails WHERE OrderId = @oid)
                                        WHERE Id = @oid";
                SqlCommand cmdTotal = new SqlCommand(updateTotalSql, conn);
                cmdTotal.Parameters.AddWithValue("@oid", orderId);
                cmdTotal.ExecuteNonQuery();

                // Feature 2: 成功后的明确提醒
                // 弹出一个带商品名称的成功提示
                string successScript = $"alert('✅ 成功加入购物车！\\n\\n已添加：{productName}\\n您可以继续选购，或去购物车结算。');";
                ClientScript.RegisterStartupScript(this.GetType(), "AddSuccess", successScript, true);

                // 同时也保留页面上的文字提示（双重保险）
                lblMsg.Text = $"✨ {productName} 已加入购物车！";
            }
        }
    }
}