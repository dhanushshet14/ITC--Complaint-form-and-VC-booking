using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Linq;

namespace VCBooking.Services
{
    public class ZoomService
    {
        public async Task<string> GetAccessTokenAsync()
        {
            string clientId = ConfigurationManager.AppSettings["ZoomClientId"];
            string clientSecret = ConfigurationManager.AppSettings["ZoomClientSecret"];
            string refreshToken = ConfigurationManager.AppSettings["ZoomRefreshToken"];

            using (var client = new HttpClient())
            {
                var byteArray = Encoding.ASCII.GetBytes($"{clientId}:{clientSecret}");
                client.DefaultRequestHeaders.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue(
                        "Basic",
                        Convert.ToBase64String(byteArray));

                var content = new StringContent(
                    $"grant_type=refresh_token&refresh_token={refreshToken}",
                    Encoding.UTF8,
                    "application/x-www-form-urlencoded");

                var response = await client.PostAsync("https://zoom.us/oauth/token", content);
                var responseString = await response.Content.ReadAsStringAsync();

                var json = JObject.Parse(responseString);

                string newAccessToken = json["access_token"].ToString();
                string newRefreshToken = json["refresh_token"].ToString();


                return newAccessToken;
            }
        }


        public async Task<JObject> CreateMeetingAsync(string topic,DateTime startTime,int durationMinutes,string createdByName,string createdByEmail)
        {
            string accessToken = await GetAccessTokenAsync();

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);

                var meetingData = new
                {
                    topic = topic,
                    type = 2,
                    start_time = startTime.ToString("yyyy-MM-ddTHH:mm:ss"),
                    duration = durationMinutes,
                    timezone = "Asia/Kolkata",
                    agenda = $"Meeting created by: {createdByName} ({createdByEmail})"
                };

                string json = Newtonsoft.Json.JsonConvert.SerializeObject(meetingData);

                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("https://api.zoom.us/v2/users/me/meetings", content);
                var responseString = await response.Content.ReadAsStringAsync();

                return JObject.Parse(responseString);
            }
        }

        public async Task DeleteMeetingAsync(string meetingId)
        {
            string accessToken = await GetAccessTokenAsync();

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);

                var response = await client.DeleteAsync($"https://api.zoom.us/v2/meetings/{meetingId}");

                if (!response.IsSuccessStatusCode)
                {
                    string error = await response.Content.ReadAsStringAsync();
                    throw new Exception("Zoom delete failed: " + error);
                }
            }
        }


    }
}