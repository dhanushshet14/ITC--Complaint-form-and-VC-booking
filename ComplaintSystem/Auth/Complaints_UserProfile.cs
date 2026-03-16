using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;

namespace ComplaintSystem.Auth
{
    public class Complaints_UserProfile
    {
        SqlConnection sCon = new SqlConnection(ConfigurationManager.ConnectionStrings["HRMContractConnectionString"].ToString());
        private SqlConnection GetConnection()
        {
            return new SqlConnection(ConfigurationManager.ConnectionStrings["HRMContractConnectionString"].ConnectionString);
        }

        public int verifyLogin(string sUsername, string sPassword)
        {
            int nUserId = 0;
            using (SqlConnection sCon = GetConnection())
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("SP_verifyLogin", sCon);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Username", sUsername);
                    cmd.Parameters.AddWithValue("@Password", sPassword);
                    sCon.Open();

                    DataSet oDS = new DataSet();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(oDS);

                    if (oDS != null && oDS.Tables[0] != null && oDS.Tables[0].Rows.Count > 0)
                    {
                        int nId = Convert.ToInt32(oDS.Tables[0].Rows[0]["ID"]);
                        string sStatus = oDS.Tables[0].Rows[0]["Status"].ToString();
                        if (nId > 0)
                        {
                            nUserId = nId;
                        }
                        cmd.Dispose();
                        
                      }
                    return nUserId;
                }

                catch (Exception ex)
                {
                    return nUserId;
                    //throw;
                }
                finally
                {
                    sCon.Close();
                    sCon.Dispose();
                }
            }
        }

        public DataSet getUserProfile(int nUserId)
        {
            try
            {
                SqlCommand cmd = new SqlCommand("SP_getUserProfile", sCon);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", nUserId);
                sCon.Open();

                DataSet oDS = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(oDS);

                cmd.Dispose();
                return oDS;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                sCon.Close();
                sCon.Dispose();
            }
        }
    }
}