using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class Doctor : User
    {
        public string Specialization { get; set; } = string.Empty;
        public string Department { get; set; } = string.Empty;
        // Navigation properties
        public ICollection<Therapy>? Therapies { get; set; }
        public ICollection<Appointment>? Appointments { get; set; }
    }
}
