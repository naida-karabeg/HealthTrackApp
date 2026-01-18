using System.ComponentModel.DataAnnotations;

namespace Application.DTOs.Auth
{
    public class RegisterDto
    {
        [Required(ErrorMessage = "Email je obavezan")]
        [EmailAddress(ErrorMessage = "Neispravan format email-a")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Lozinka je obavezna")]
        [MinLength(6, ErrorMessage = "Lozinka mora imati najmanje 6 karaktera")]
        public string Password { get; set; } = string.Empty;

        [Required(ErrorMessage = "Ime je obavezno")]
        public string FirstName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Prezime je obavezno")]
        public string LastName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Datum ro?enja je obavezan")]
        public DateTime DateOfBirth { get; set; }

        public string? Address { get; set; }

        public string? PhoneNumber { get; set; }

        [Required(ErrorMessage = "Uloga je obavezna")]
        public string Role { get; set; } = "Patient"; // Default: Patient

        // Polja specifi?na za Patient
        public string? Gender { get; set; }
        public string? EmergencyContact { get; set; }
        public string? BloodType { get; set; }

        // Polja specifi?na za Doctor
        public string? Specialization { get; set; }
        public string? Department { get; set; }
    }
}
