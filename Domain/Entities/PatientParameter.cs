using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class PatientParameter
    {
        public int Id { get; set; }
        public string PatientId { get; set; } = string.Empty;
        public int ParameterId { get; set; }
        public decimal Value { get; set; }
        public DateTime RecordedAt { get; set; } = DateTime.UtcNow;

        // Navigation properties
        public Patient? Patient { get; set; }
        public MedicalParameter? Parameter { get; set; }
    }

}
