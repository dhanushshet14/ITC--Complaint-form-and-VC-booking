using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace TMG_ITC.Helpers
{
    public static class JwtHelper
    {
        private static string SecretKey
        {
            get
            {
                var key = ConfigurationManager.AppSettings["JwtSecret"];
                if (string.IsNullOrEmpty(key))
                {
                    key = "ITC_CMS_DEFAULT_SECRET_KEY_2026_CHANGE_IN_PROD";
                    ConfigurationManager.AppSettings["JwtSecret"] = key;
                }
                return key;
            }
        }

        private const string CookieName = "jwt_token";
        private const int ExpiryHours = 8;
        private const int RefreshAfterHours = 4;

        public static string GenerateToken(UserSessionData user)
        {
            var header = new JObject
            {
                ["alg"] = "HS256",
                ["typ"] = "JWT"
            };

            var now = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
            var payload = new JObject
            {
                ["sub"] = user.EmpCode,
                ["name"] = user.FullName,
                ["username"] = user.Username,
                ["role"] = user.Role,
                ["loginType"] = user.LoginType,
                ["unitIds"] = user.UnitIds != null ? string.Join(",", user.UnitIds) : "",
                ["iat"] = now,
                ["exp"] = now + (ExpiryHours * 3600)
            };

            string headerB64 = Base64UrlEncode(Encoding.UTF8.GetBytes(header.ToString(Formatting.None)));
            string payloadB64 = Base64UrlEncode(Encoding.UTF8.GetBytes(payload.ToString(Formatting.None)));
            string signature = ComputeSignature(headerB64, payloadB64);

            return $"{headerB64}.{payloadB64}.{signature}";
        }

        public static UserSessionData ValidateToken(string token)
        {
            try
            {
                var parts = token.Split('.');
                if (parts.Length != 3) return null;

                string headerB64 = parts[0];
                string payloadB64 = parts[1];
                string signature = parts[2];

                string expectedSig = ComputeSignature(headerB64, payloadB64);
                if (!ConstantTimeEquals(signature, expectedSig)) return null;

                string payloadJson = Encoding.UTF8.GetString(Base64UrlDecode(payloadB64));
                var payload = JObject.Parse(payloadJson);

                long exp = payload["exp"]?.Value<long>() ?? 0;
                long now = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
                if (now >= exp) return null;

                var unitIds = new List<int>();
                string unitIdsStr = payload["unitIds"]?.Value<string>() ?? "";
                if (!string.IsNullOrEmpty(unitIdsStr))
                {
                    unitIds = unitIdsStr
                        .Split(',')
                        .Where(x => int.TryParse(x, out _))
                        .Select(int.Parse)
                        .ToList();
                }

                return new UserSessionData
                {
                    EmpCode = payload["sub"]?.Value<string>(),
                    FullName = payload["name"]?.Value<string>(),
                    Username = payload["username"]?.Value<string>(),
                    Role = payload["role"]?.Value<string>(),
                    LoginType = payload["loginType"]?.Value<string>(),
                    UnitIds = unitIds
                };
            }
            catch
            {
                return null;
            }
        }

        public static bool ShouldRefresh(string token)
        {
            try
            {
                var parts = token.Split('.');
                if (parts.Length != 3) return false;

                string payloadJson = Encoding.UTF8.GetString(Base64UrlDecode(parts[1]));
                var payload = JObject.Parse(payloadJson);

                long iat = payload["iat"]?.Value<long>() ?? 0;
                long now = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
                return (now - iat) >= (RefreshAfterHours * 3600);
            }
            catch
            {
                return false;
            }
        }

        public static void SetCookie(string token)
        {
            var cookie = new HttpCookie(CookieName, token)
            {
                HttpOnly = true,
                Secure = false,
                SameSite = SameSiteMode.Lax,
                Path = "/",
                Expires = DateTime.UtcNow.AddHours(ExpiryHours)
            };
            HttpContext.Current.Response.Cookies.Set(cookie);
        }

        public static string GetCookie()
        {
            var cookie = HttpContext.Current.Request.Cookies[CookieName];
            return cookie?.Value;
        }

        public static void ClearCookie()
        {
            var cookie = new HttpCookie(CookieName, "")
            {
                HttpOnly = true,
                Secure = false,
                SameSite = SameSiteMode.Lax,
                Path = "/",
                Expires = DateTime.UtcNow.AddDays(-1)
            };
            HttpContext.Current.Response.Cookies.Set(cookie);
        }

        private static string ComputeSignature(string headerB64, string payloadB64)
        {
            string input = $"{headerB64}.{payloadB64}";
            byte[] keyBytes = Encoding.UTF8.GetBytes(SecretKey);
            using (var hmac = new HMACSHA256(keyBytes))
            {
                byte[] hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(input));
                return Base64UrlEncode(hash);
            }
        }

        private static string Base64UrlEncode(byte[] data)
        {
            return Convert.ToBase64String(data)
                .Replace('+', '-')
                .Replace('/', '_')
                .TrimEnd('=');
        }

        private static byte[] Base64UrlDecode(string input)
        {
            string b64 = input.Replace('-', '+').Replace('_', '/');
            switch (b64.Length % 4)
            {
                case 2: b64 += "=="; break;
                case 3: b64 += "="; break;
            }
            return Convert.FromBase64String(b64);
        }

        private static bool ConstantTimeEquals(string a, string b)
        {
            if (a.Length != b.Length) return false;
            int diff = 0;
            for (int i = 0; i < a.Length; i++)
                diff |= a[i] ^ b[i];
            return diff == 0;
        }
    }
}
