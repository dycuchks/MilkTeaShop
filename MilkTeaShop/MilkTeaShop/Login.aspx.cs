using System;
using System.Data.SqlClient;
using System.Configuration;

namespace MilkTeaShop
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MilkTeaConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM Users WHERE Username=@u AND Password=@p";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@u", txtUsername.Text.Trim());
                cmd.Parameters.AddWithValue("@p", txtPassword.Text.Trim());

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        // 登录成功，保存 Session
                        // 注意：数据库主键现在叫 Id，不是 UserId
                        Session["UserId"] = reader["Id"];
                        Session["Username"] = reader["Username"];
                        Session["UserType"] = reader["UserType"]; // 1普通 2管理员

                        if (reader["UserType"].ToString() == "2")
                        {
                            // 管理员跳转（后续我们会做 Admin.aspx）
                            Response.Redirect("Default.aspx");
                        }
                        else
                        {
                            // 普通用户跳转首页
                            Response.Redirect("Default.aspx");
                        }
                    }
                    else
                    {
                        lblMsg.Text = "❌ 用户名或密码错误";
                    }
                }
                catch (Exception ex)
                {
                    lblMsg.Text = "系统错误：" + ex.Message;
                }
            }
        }
    }
}