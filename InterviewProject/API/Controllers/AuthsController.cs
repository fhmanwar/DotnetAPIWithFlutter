using Bcrypt = BCrypt.Net.BCrypt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using API.Context;
using API.Models;
using API.Services;
using API.ViewModels;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using API.Repository;
using Microsoft.AspNetCore.WebUtilities;
using Newtonsoft.Json;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthsController : ControllerBase
    {
        AttrEmail attrEmail = new AttrEmail();
        RandomDigit randDig = new RandomDigit();
        SmtpClient client = new SmtpClient();
        BaseURL baseURL = new BaseURL();
        readonly MyContext _context; 
        public IConfiguration _configuration;
        UserRepository _repo;

        public AuthsController(MyContext myContext, IConfiguration config, UserRepository repo)
        {
            _context = myContext;
            _configuration = config;
            _repo = repo;
        }

        [HttpPost]
        [Route("Login")]
        public IActionResult Login(GetUserVM getUserVM)
        {
            if (ModelState.IsValid)
            {
                var getData = _context.Users.Include("Role").SingleOrDefault(x => x.Email == getUserVM.Email);
                if (getData == null)
                {
                    return NotFound("Email Not Found");
                }
                else if (getUserVM.Password == null || getUserVM.Password.Equals(""))
                {
                    return BadRequest("Password must filled");
                }
                else if (!Bcrypt.Verify(getUserVM.Password, getData.Password))
                {
                    return BadRequest("Password is Wrong");
                }
                else
                {
                    if (getData != null)
                    {
                        var user = new UserVM()
                        {
                            Id = getData.Id,
                            Name = getData.Name,
                            Email = getData.Email,
                            RoleName = getData.Role.RoleName,
                            VerifyCode = getData.VerifyCode,
                        };
                        return Ok(GetJWT(user));
                    }
                    return BadRequest("Invalid credentials");
                }
            }
            return BadRequest("Data Not Valid");
        }

        [HttpPost]
        [Route("Register")]
        public IActionResult Register(GetUserVM getUserVM)
        {
            var getUser = _context.Users.Where(x => x.Email == getUserVM.Email);
            if (getUser.Count() == 0)
            {
                if (ModelState.IsValid)
                {
                    var checkRole = _context.Roles.SingleOrDefault(x => x.RoleName == "User");
                    var usr = new User
                    {
                        Name = getUserVM.Name,
                        Email = getUserVM.Email,
                        Password = Bcrypt.HashPassword(getUserVM.Password),
                        RoleId = checkRole.RoleId,
                        VerifyCode = null,
                        CreateDate = DateTimeOffset.Now,
                        isDelete = false
                    };
                    _context.Users.Add(usr);
                    _context.SaveChanges();

                    return Ok("Successfully Created");
                }
                return BadRequest("Register Not Successfully");
            }
            return BadRequest("Email Already Exists ");
        }

        public string GetJWT(UserVM dataVM)
        {
            var claims = new List<Claim> {
                            new Claim("Id", dataVM.Id.ToString()),
                            new Claim("Name", dataVM.Name),
                            new Claim("Email", dataVM.Email),
                            new Claim("RoleName", dataVM.RoleName),
                            new Claim("VerifyCode", dataVM.VerifyCode == null ? "" : dataVM.VerifyCode),
                        };
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
            var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var token = new JwtSecurityToken(
                            _configuration["Jwt:Issuer"],
                            _configuration["Jwt:Audience"],
                            claims,
                            expires: DateTime.UtcNow.AddDays(1),
                            signingCredentials: signIn
                        );
            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        [HttpPost]
        [Route("code")]
        public IActionResult VerifyCode(UserVM userVM)
        {
            if (ModelState.IsValid)
            {
                var getData = _context.Users.Include("Role").SingleOrDefault(x => x.Email == userVM.Email);
                if (getData == null)
                {
                    return NotFound();
                }
                else if (userVM.VerifyCode != getData.VerifyCode)
                {
                    return BadRequest("Your Code is Wrong");
                }
                else
                {
                    getData.VerifyCode = null;
                    _context.SaveChanges();
                    var user = new UserVM()
                    {
                        Id = getData.Id,
                        Name = getData.Name,
                        Email = getData.Email,
                        RoleName = getData.Role.RoleName,
                        VerifyCode = getData.VerifyCode,
                    };
                    return StatusCode(200, GetJWT(user));
                }
            }
            return BadRequest("Data Not Valid");
        }

    }
}
