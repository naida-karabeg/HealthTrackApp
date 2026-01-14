using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class Patient : User
    {
        public string Gender { get; set; } = string.Empty;
        public string? EmergencyContact { get; set; }
        public string? BloodType { get; set; }

        // Navigation properties
        public ICollection<Therapy>? Therapies { get; set; }
        public ICollection<Appointment>? Appointments { get; set; }
        public ICollection<Diagnosis>? Diagnoses { get; set; }
        public ICollection<HealthJournal>? HealthJournals { get; set; }
        public ICollection<Recommendation>? Recommendations { get; set; }
        public ICollection<PatientParameter>? PatientParameters { get; set; }
    }
}
