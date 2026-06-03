using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MilkTeaShop
{
    public partial class AdminOrders : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MilkTeaConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 安全检查：只有管理员(Type=2)能进
            if (Session["UserType"] == null || Session["UserType"].ToString() != "2")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindOrders();
            }
        }

        private void BindOrders()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 查询所有非购物车状态的订单
                string sql = @"
                    SELECT o.*, u.Username 
                    FROM Orders o
                    JOIN Users u ON o.UserId = u.Id
                    WHERE o.Status <> N'购物车'
                    ORDER BY o.OrderDate DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvOrders.DataSource = dt;
                gvOrders.DataBind();
            }
        }

        // 行数据绑定时：1. 设置状态颜色 2. 选中下拉框 3. 加载订单明细
        protected void gvOrders_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // A. 设置状态颜色
                Label lblStatus = (Label)e.Row.FindControl("lblStatusBadge");
                string status = DataBinder.Eval(e.Row.DataItem, "Status").ToString();

                if (status == "待处理") lblStatus.CssClass += " status-pending";
                else if (status == "制作中") lblStatus.CssClass += " status-making";
                else if (status == "派送中") lblStatus.CssClass += " status-shipping";
                else if (status == "已完成") lblStatus.CssClass += " status-completed";

                // B. 让下拉框默认选中当前状态
                DropDownList ddl = (DropDownList)e.Row.FindControl("ddlStatus");
                if (ddl != null)
                {
                    ddl.SelectedValue = status;
                }

                // C. 核心升级：加载该订单的具体商品明细
                // 1. 获取当前行的 OrderId
                int orderId = Convert.ToInt32(gvOrders.DataKeys[e.Row.RowIndex].Value);
                // 2. 找到该行的 Repeater 控件
                Repeater rpt = (Repeater)e.Row.FindControl("rptDetails");

                if (rpt != null)
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        // 联表查询：OrderDetails -> Products (获取图片和名称)
                        string sqlDetail = @"
                            SELECT d.Quantity, p.ProductName, p.ImageUrl 
                            FROM OrderDetails d 
                            JOIN Products p ON d.ProductId = p.Id 
                            WHERE d.OrderId = @oid";

                        SqlCommand cmd = new SqlCommand(sqlDetail, conn);
                        cmd.Parameters.AddWithValue("@oid", orderId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dtDetail = new DataTable();
                        da.Fill(dtDetail);

                        // 3. 绑定给子列表
                        rpt.DataSource = dtDetail;
                        rpt.DataBind();
                    }
                }
            }
        }

        // 处理“更新”按钮点击
        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateStatus")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int orderId = Convert.ToInt32(gvOrders.DataKeys[rowIndex].Value);

                // 获取下拉框选中的新状态
                DropDownList ddl = (DropDownList)gvOrders.Rows[rowIndex].FindControl("ddlStatus");
                string newStatus = ddl.SelectedValue;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE Orders SET Status = @s WHERE Id = @oid";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@s", newStatus);
                    cmd.Parameters.AddWithValue("@oid", orderId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMsg.Text = $"✅ 订单 #{orderId} 状态已更新为：{newStatus}";
                BindOrders(); // 刷新列表
            }
        }
    }
}