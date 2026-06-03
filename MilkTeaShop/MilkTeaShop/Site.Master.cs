using System;
using System.Web.UI;

namespace MilkTeaShop
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] != null)
                {
                    // 已登录
                    phGuest.Visible = false;
                    phUser.Visible = true;
                    if (Session["Username"] != null)
                    {
                        lblUser.Text = Session["Username"].ToString();
                    }

                    // 核心逻辑：如果是管理员 (UserType=2)，显示管理菜单
                    if (Session["UserType"] != null && Session["UserType"].ToString() == "2")
                    {
                        phAdmin.Visible = true;
                    }
                    else
                    {
                        phAdmin.Visible = false;
                    }
                }
                else
                {
                    // 未登录
                    phGuest.Visible = true;
                    phUser.Visible = false;
                    phAdmin.Visible = false;

                    // 页面访问权限控制
                    string path = Request.AppRelativeCurrentExecutionFilePath.ToLower();
                    // 如果是管理员页面，严禁未登录访问
                    if (path.Contains("admin"))
                    {
                        Response.Redirect("Login.aspx");
                    }

                    if (!path.Contains("login.aspx") &&
                        !path.Contains("register.aspx") &&
                        !path.Contains("default.aspx"))
                    {
                        Response.Redirect("Login.aspx");
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}