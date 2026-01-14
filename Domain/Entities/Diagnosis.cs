using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class Diagnosis
    {
        public int Id { get; set; }
        public string PatientId { get; set; } = string.Empty;
        public string DiagnosisName { get; set; } = string.Empty;
        public string? Description { get; set; }
        public DateTime DiagnosedDate { get; set; }
        public bool IsActive { get; set; } = true;
        public DateTime? ResolvedDate { get; set; }
        public string? PrescribedBy { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Navigation properties
        public Patient? Patient { get; set; }
    }
}
