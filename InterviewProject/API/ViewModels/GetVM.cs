using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.ViewModels
{
    public class GetRoleVM
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Session { get; set; }
        public DateTimeOffset InsAt { get; set; }
        public DateTimeOffset UpdAt { get; set; }
    }

    public class GetUserVM
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Name { get; set; }
        public string RoleID { get; set; }
        public string RoleName { get; set; }
        public int Session { get; set; }
    }

    
}
