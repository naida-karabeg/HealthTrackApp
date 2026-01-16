using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.DTOs
{
    public class PatientUpdateRequest
    {
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public DateTime DateOfBirth { get; set; }
        public string? Address { get; set; }
        public string Gender { get; set; } = string.Empty;
        public string? EmergencyContact { get; set; }
        public string? BloodType { get; set; }
        public string PhoneNumber { get; set; } = string.Empty;
    }
}
