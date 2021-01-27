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
        public IActionResult Login(UserVM userVM)
        {
            if (ModelState.IsValid)
            {
                var getData = _context.Users.Include("Role").SingleOrDefault(x => x.Email == userVM.Email);
                if (getData == null)
                {
                    return NotFound("Email Not Found");
                }
                else if (userVM.Password == null || userVM.Password.Equals(""))
                {
                    return BadRequest("Password must filled");
                }
                else if (!Bcrypt.Verify(userVM.Password, getData.Password))
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
        public IActionResult Register(UserVM userVM)
        {
            var getUser = _context.Users.Where(x => x.Email == userVM.Email);
            if (getUser.Count() == 0)
            {
                if (ModelState.IsValid)
                {
                    var code = randDig.GenerateRandom();
                    var fill = "Hi " + userVM.Name + "\n\n"
                              + "Please verifty Code for this Apps : \n"
                              + code
                              + "\n\nThank You";

                    MailMessage mm = new MailMessage("donotreply@domain.com", userVM.Email, "Register Email", fill);
                    mm.BodyEncoding = UTF8Encoding.UTF8;
                    mm.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                    string str1 = "gmail.com";
                    string str2 = attrEmail.mail;

                    if (str2.Contains(str1))
                    {
                        try
                        {
                            client.Port = 587;
                            client.Host = "smtp.gmail.com";
                            client.EnableSsl = true;
                            client.Timeout = 10000;
                            client.DeliveryMethod = SmtpDeliveryMethod.Network;
                            client.UseDefaultCredentials = false;
                            client.Credentials = new NetworkCredential(attrEmail.mail, attrEmail.pass);
                            client.Send(mm);
                        }
                        catch (Exception ex)
                        {
                            return BadRequest("SMTP Gmail Error " + ex);
                        }
                    }
                    else
                    {
                        try
                        {
                            client.Port = 25;
                            client.Credentials = new NetworkCredential(attrEmail.mail, attrEmail.pass);
                            client.EnableSsl = false;
                            client.Send(mm);
                        }
                        catch (Exception ex)
                        {
                            return BadRequest("SMTP Email Error " + ex);
                        }
                    }

                    var user = new UserVM
                    {
                        Email = userVM.Email,
                        Password = userVM.Password,
                        VerifyCode = code,
                    };
                    var create = _repo.Create(user);
                    if (create > 0)
                    {
                        var getUserId = getUser.SingleOrDefault();
                        var checkRole = _context.Roles.SingleOrDefault(x => x.RoleName == "Employee");
                        var usr = new User
                        {
                            Id = getUserId.Id,
                            Name = userVM.Name,
                            RoleId = checkRole.RoleId,
                            CreateDate = DateTimeOffset.Now,
                            isDelete = false
                        };
                        _context.Users.Add(usr);
                        _context.SaveChanges();

                        return Ok("Successfully Created");
                    }
                    return BadRequest("Register Not Successfully");
                }
                return BadRequest("Not Successfully");
            }
            return BadRequest("Email Already Exists ");
        }

        [HttpPost]
        [Route("Forgot")]
        public async Task<IActionResult> Forgot(ForgotVM forgotVM)
        {
            var getUser = _context.Users.Include("Employee").Where(x => x.Email == forgotVM.Email);
            var cekCount = getUser.Count();
            if (cekCount != 0)
            {
                if (ModelState.IsValid)
                {
                    var getUserId = await getUser.SingleOrDefaultAsync();
                    var code = randDig.GenerateRandom();

                    var encode = WebEncoders.Base64UrlEncode(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(forgotVM)));
                    var link = baseURL.UsrManage + "reset?token="+encode;

                    var fill = "Hi " + getUserId.Name + "\n\n"
                              + "Click this link for Reset Password : \n"
                              + "<a href=" + link + ">Reset Password</a>"
                              + "\n\nThank You";

                    MailMessage mm = new MailMessage("donotreply@domain.com", forgotVM.Email, "Forgot Password ", fill);
                    mm.BodyEncoding = UTF8Encoding.UTF8;
                    mm.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                    string str1 = "gmail.com";
                    string str2 = attrEmail.mail;

                    if (str2.Contains(str1))
                    {
                        try
                        {
                            client.Port = 587;
                            client.Host = "smtp.gmail.com";
                            client.EnableSsl = true;
                            client.Timeout = 10000;
                            client.DeliveryMethod = SmtpDeliveryMethod.Network;
                            client.UseDefaultCredentials = false;
                            client.Credentials = new NetworkCredential(attrEmail.mail, attrEmail.pass);
                            client.Send(mm);
                        }
                        catch (Exception ex)
                        {
                            return BadRequest("SMTP Gmail Error " + ex);
                        }
                    }
                    else if (!str2.Contains(str1))
                    {
                        try
                        {
                            client.Port = 25;
                            client.Credentials = new NetworkCredential(attrEmail.mail, attrEmail.pass);
                            client.EnableSsl = false;
                            client.Send(mm);
                        }
                        catch (Exception ex)
                        {
                            return BadRequest("SMTP Email Error " + ex);
                        }
                    }
                    var user = new UserVM
                    {
                        Email = forgotVM.Email,
                        Password = null,
                        Token = encode,
                    };
                    var create = _repo.Update(user, getUserId.Id);
                    if (create > 0)
                    {
                        return Ok("Please check your email");
                    }
                }
                return BadRequest("Not Successfully");
            }
            return BadRequest("Email Doesn't Exists ");
        }

        [HttpPost]
        [Route("Reset")]
        public async Task<IActionResult> Reset(string token, ForgotVM forgotVM)
        {
            var getToken = _context.Users.Where(x => x.Token == token);
            var tokenCount = getToken.Count();
            if (tokenCount > 0)
            {
                var getdecode = WebEncoders.Base64UrlDecode(token);
                var getString = Encoding.UTF8.GetString(getdecode);
                var getDObj = JsonConvert.DeserializeObject<ForgotVM>(getString);
                var decode = JsonConvert.DeserializeObject<ForgotVM>(Encoding.UTF8.GetString(WebEncoders.Base64UrlDecode(token)));
                var getUser = _context.Users.Include("Employee").Where(x => x.Email == decode.Email);
                var cekCount = getUser.Count();
                if (cekCount == 1)
                {
                    if (ModelState.IsValid)
                    {
                        var getUserId = await getUser.SingleOrDefaultAsync();
                    
                        var user = new UserVM
                        {
                            Email = decode.Email,
                            Password = Bcrypt.HashPassword(forgotVM.Password),
                            Token = null,
                        };
                        var create = _repo.Update(user,getUserId.Id);
                        if (create > 0)
                        {
                            return Ok("Reset Password Successfully");
                        }
                        return BadRequest("Reset Password Not Successfully");
                    }
                    return BadRequest("Something wrong");
                }
                return BadRequest("Email Doesn't Exists ");
            }
            return BadRequest("Token Doesn't Exists ");
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
