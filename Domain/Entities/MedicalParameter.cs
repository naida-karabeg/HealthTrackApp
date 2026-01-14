using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class MedicalParameter
    {
        public int Id { get; set; }
        public string ParameterName { get; set; } = string.Empty;
        public string? Unit { get; set; }
        // Navigation properties
        public ICollection<PatientParameter>? PatientParameters { get; set; }
    }

}
