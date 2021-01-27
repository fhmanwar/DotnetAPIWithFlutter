using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Services
{
    public class Helper
    {
    }
    public class AttrEmail
    {
        public string mail = "";
        public string pass = "";

    }

    public class RandomDigit
    {
        private Random _random = new Random();
        public string GenerateRandom()
        {
            return _random.Next(0, 9999).ToString("D4");
        }
    }

    public class BaseURL
    {
        public string UsrManage = "https://localhost:44349/";
        public string assetM = "https://localhost:44380/";
        public string interview = "https://localhost:44303/";
        public string examOnline = "https://localhost:44332/";
        public string reimbursParking = "https://localhost:44360/";
    }
}
