using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VCBooking
{
    public partial class ViewRequests : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRequests();
            }
        }

        protected void LoadRequests()
        {

            string connStr = ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                SELECT 
                 h.VCId,
                 c.CompanyName,
                 t.VCTypeName,
                 a.VCAccountName,
                 h.Topic,
                 h.VCDate,
                 h.FromTime,
                 h.ToTime,
                 l.LocationName,
                 h.VCStatus,
                 h.CreatedDate
                 FROM VCRequestHeader h
                 JOIN Company_Master c ON h.CompanyId = c.CompanyId
                 JOIN VC_Type_Master t ON h.VCTypeId = t.VCTypeId
                 JOIN VC_Account_Master a ON h.VCAccountId = a.VCAccountId
                 JOIN Location_Master l ON h.LocationId = l.LocationId
                 ORDER BY h.CreatedDate DESC";


                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvRequests.DataSource = dt;
                gvRequests.DataBind();
            }

        }
    }
}