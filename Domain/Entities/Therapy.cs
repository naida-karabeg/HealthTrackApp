using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class Therapy
    {
        public int Id { get; set; }
        public string PatientId { get; set; } = string.Empty;
        public int MedicationId { get; set; }
        public string Dosage { get; set; } = string.Empty;
        public string Frequency { get; set; } = string.Empty; // npr. "3x dnevno", "ujutro i uveče"
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsActive { get; set; } = true;
        public string? Instructions { get; set; }
        public string? DoctorId { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }

        // Navigation properties
        public Patient? Patient { get; set; }
        public Medication? Medication { get; set; }
        public ICollection<TherapyLog>? TherapyLogs { get; set; }
        public Doctor? Doctor { get; set; }
    }

}
