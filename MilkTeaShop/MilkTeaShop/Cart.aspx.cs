using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace MilkTeaShop
{
    public partial class Cart : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MilkTeaConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCart();
                // 首次加载时，预填充用户的默认信息，方便修改
                LoadUserProfile();
            }
        }

        private void LoadCart()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT 
                        d.Id AS DetailId, 
                        p.ProductName, 
                        p.ImageUrl, 
                        p.Category,
                        d.Quantity, 
                        d.PriceAtTime,
                        (d.Quantity * d.PriceAtTime) AS Subtotal
                    FROM OrderDetails d
                    JOIN Products p ON d.ProductId = p.Id
                    JOIN Orders o ON d.OrderId = o.Id
                    WHERE o.UserId = @uid AND o.Status = N'购物车'";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                da.SelectCommand.Parameters.AddWithValue("@uid", userId);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    gvCart.DataSource = dt;
                    gvCart.DataBind();

                    decimal total = 0;
                    int count = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        total += Convert.ToDecimal(row["Subtotal"]);
                        count += Convert.ToInt32(row["Quantity"]);
                    }

                    lblTotal.Text = total.ToString("F2");
                    lblCount.Text = count.ToString();

                    pnlCart.Visible = true;
                    pnlEmpty.Visible = false;
                }
                else
                {
                    pnlCart.Visible = false;
                    pnlEmpty.Visible = true;
                }
            }
        }

        // 预加载用户资料到输入框
        private void LoadUserProfile()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 读取用户的默认电话和地址
                string sql = "SELECT Phone, Address FROM Users WHERE Id = @uid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", userId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    if (txtPhone.Text == "") txtPhone.Text = reader["Phone"].ToString();
                    if (txtAddress.Text == "") txtAddress.Text = reader["Address"].ToString();
                }
            }
        }

        protected void gvCart_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int detailId = Convert.ToInt32(gvCart.DataKeys[e.RowIndex].Value);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "DELETE FROM OrderDetails WHERE Id = @did";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@did", detailId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            LoadCart();
        }

        // 处理加减号逻辑
        protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "IncreaseQty" || e.CommandName == "DecreaseQty")
            {
                int detailId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    // 1. 先查当前数量
                    string selectSql = "SELECT Quantity FROM OrderDetails WHERE Id = @did";
                    SqlCommand cmdSelect = new SqlCommand(selectSql, conn);
                    cmdSelect.Parameters.AddWithValue("@did", detailId);
                    int currentQty = Convert.ToInt32(cmdSelect.ExecuteScalar());

                    int newQty = currentQty;
                    if (e.CommandName == "IncreaseQty")
                    {
                        newQty++;
                    }
                    else if (e.CommandName == "DecreaseQty")
                    {
                        if (currentQty > 1)
                        {
                            newQty--;
                        }
                        else
                        {
                            // 如果数量是1还点减号，这里不做操作，或者你可以选择删除
                            return;
                        }
                    }

                    // 2. 更新数量
                    string updateSql = "UPDATE OrderDetails SET Quantity = @q WHERE Id = @did";
                    SqlCommand cmdUpdate = new SqlCommand(updateSql, conn);
                    cmdUpdate.Parameters.AddWithValue("@q", newQty);
                    cmdUpdate.Parameters.AddWithValue("@did", detailId);
                    cmdUpdate.ExecuteNonQuery();
                }

                // 3. 刷新页面，这会自动重新计算总价
                LoadCart();
            }
        }

        // 结算逻辑：保存订单信息并提交
        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            decimal totalAmount = Convert.ToDecimal(lblTotal.Text);

            // 获取用户填写的收货信息
            string address = txtAddress.Text.Trim();
            string phone = txtPhone.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string findOrderSql = "SELECT Id FROM Orders WHERE UserId = @uid AND Status = N'购物车'";
                SqlCommand cmdFind = new SqlCommand(findOrderSql, conn);
                cmdFind.Parameters.AddWithValue("@uid", userId);
                object result = cmdFind.ExecuteScalar();

                if (result != null)
                {
                    int orderId = Convert.ToInt32(result);

                    // 更新：不仅改状态，还保存收货地址和电话
                    string updateSql = @"UPDATE Orders 
                                         SET Status = N'待处理', 
                                             OrderDate = GETDATE(), 
                                             TotalAmount = @total,
                                             ReceiverAddress = @addr,
                                             ReceiverPhone = @ph
                                         WHERE Id = @oid";

                    SqlCommand cmdUpdate = new SqlCommand(updateSql, conn);
                    cmdUpdate.Parameters.AddWithValue("@total", totalAmount);
                    cmdUpdate.Parameters.AddWithValue("@addr", address);
                    cmdUpdate.Parameters.AddWithValue("@ph", phone);
                    cmdUpdate.Parameters.AddWithValue("@oid", orderId);
                    cmdUpdate.ExecuteNonQuery();

                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('下单成功！商家已收到您的订单。');window.location='Default.aspx';", true);
                }
            }
        }
    }
}