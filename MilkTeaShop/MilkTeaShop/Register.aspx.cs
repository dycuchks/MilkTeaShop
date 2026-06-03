using System;
using System.Data.SqlClient;
using System.Configuration;

namespace MilkTeaShop
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string connStr = ConfigurationManager.ConnectionStrings["MilkTeaConn"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // 默认注册为普通用户 (UserType = 1)
                    string sql = "INSERT INTO Users (Username, Password, UserType, Phone, Address) VALUES (@u, @p, 1, @ph, @add)";
                    SqlCommand cmd = new SqlCommand(sql, conn);

                    cmd.Parameters.AddWithValue("@u", txtUser.Text.Trim());
                    cmd.Parameters.AddWithValue("@p", txtPass.Text.Trim());
                    cmd.Parameters.AddWithValue("@ph", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@add", txtAddress.Text.Trim());

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();

                        // 注册成功，弹窗提示并跳转
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('注册成功！欢迎加入遇见·好茶');window.location='Login.aspx';", true);
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Number == 2627) // 用户名重复错误码
                        {
                            lblMsg.Text = "❌ 注册失败：该用户名已被占用";
                        }
                        else
                        {
                            lblMsg.Text = "系统错误：" + ex.Message;
                        }
                    }
                }
            }
        }
    }
}