using Application.DTOs.Auth;
using Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly SignInManager<User> _signInManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly IConfiguration _configuration;

        public AuthController(
            UserManager<User> userManager,
            SignInManager<User> signInManager,
            RoleManager<IdentityRole> roleManager,
            IConfiguration configuration)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _roleManager = roleManager;
            _configuration = configuration;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Kreiranje odgovaraju?eg tipa korisnika na osnovu uloge
            User user;
            
            if (model.Role.Equals("Patient", StringComparison.OrdinalIgnoreCase))
            {
                user = new Patient
                {
                    UserName = model.Email,
                    Email = model.Email,
                    FirstName = model.FirstName,
                    LastName = model.LastName,
                    DateOfBirth = model.DateOfBirth,
                    Address = model.Address,
                    PhoneNumber = model.PhoneNumber,
                    Gender = model.Gender ?? string.Empty,
                    EmergencyContact = model.EmergencyContact,
                    BloodType = model.BloodType
                };
            }
            else if (model.Role.Equals("Doctor", StringComparison.OrdinalIgnoreCase))
            {
                user = new Doctor
                {
                    UserName = model.Email,
                    Email = model.Email,
                    FirstName = model.FirstName,
                    LastName = model.LastName,
                    DateOfBirth = model.DateOfBirth,
                    Address = model.Address,
                    PhoneNumber = model.PhoneNumber,
                    Specialization = model.Specialization,
                    Department = model.Department
                };
            }
            else
            {
                return BadRequest(new { Message = "Nepoznata uloga. Dostupne uloge: Patient, Doctor" });
            }

            var result = await _userManager.CreateAsync(user, model.Password);

            if (!result.Succeeded)
                return BadRequest(new { Errors = result.Errors.Select(e => e.Description) });

            // Osiguraj da uloga postoji
            if (!await _roleManager.RoleExistsAsync(model.Role))
            {
                await _roleManager.CreateAsync(new IdentityRole(model.Role));
            }

            await _userManager.AddToRoleAsync(user, model.Role);

            // Generiši token i vrati odgovor
            var token = await GenerateJwtToken(user);
            var roles = await _userManager.GetRolesAsync(user);
            var expiresAt = DateTime.UtcNow.AddMinutes(Convert.ToDouble(_configuration["JwtSettings:ExpirationMinutes"]));

            return Ok(new AuthResponseDto
            {
                Token = token,
                UserId = user.Id,
                Email = user.Email!,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Role = roles.FirstOrDefault() ?? model.Role,
                ExpiresAt = expiresAt
            });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var user = await _userManager.FindByEmailAsync(model.Email);
            if (user == null)
                return Unauthorized(new { Message = "Neispravni kredencijali" });

            var result = await _signInManager.CheckPasswordSignInAsync(user, model.Password, false);

            if (!result.Succeeded)
                return Unauthorized(new { Message = "Neispravni kredencijali" });

            var token = await GenerateJwtToken(user);
            var roles = await _userManager.GetRolesAsync(user);
            var expiresAt = DateTime.UtcNow.AddMinutes(Convert.ToDouble(_configuration["JwtSettings:ExpirationMinutes"]));

            return Ok(new AuthResponseDto
            {
                Token = token,
                UserId = user.Id,
                Email = user.Email!,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Role = roles.FirstOrDefault() ?? "Patient",
                ExpiresAt = expiresAt
            });
        }

        [HttpGet("me")]
        [Authorize]
        public async Task<ActionResult<AuthResponseDto>> GetCurrentUser()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
                return Unauthorized(new { Message = "Korisnik nije autentifikovan" });

            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
                return NotFound(new { Message = "Korisnik nije prona?en" });

            var roles = await _userManager.GetRolesAsync(user);

            return Ok(new AuthResponseDto
            {
                Token = string.Empty, // Token nije potreban jer korisnik ve? ima token
                UserId = user.Id,
                Email = user.Email!,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Role = roles.FirstOrDefault() ?? "Patient",
                ExpiresAt = DateTime.MinValue
            });
        }

        [HttpPost("logout")]
        [Authorize]
        public async Task<IActionResult> Logout()
        {
            await _signInManager.SignOutAsync();
            return Ok(new { Message = "Uspješno ste se odjavili" });
        }

        private async Task<string> GenerateJwtToken(User user)
        {
            var jwtSettings = _configuration.GetSection("JwtSettings");
            var secretKey = jwtSettings["SecretKey"];
            var roles = await _userManager.GetRolesAsync(user);

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id),
                new Claim(ClaimTypes.Email, user.Email!),
                new Claim(ClaimTypes.Name, $"{user.FirstName} {user.LastName}"),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };

            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey!));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var expires = DateTime.UtcNow.AddMinutes(Convert.ToDouble(jwtSettings["ExpirationMinutes"]));

            var token = new JwtSecurityToken(
                issuer: jwtSettings["Issuer"],
                audience: jwtSettings["Audience"],
                claims: claims,
                expires: expires,
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
