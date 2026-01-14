using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class TherapyLog
    {
        public int Id { get; set; }
        public int TherapyId { get; set; }
        public DateTime TakenAt { get; set; } = DateTime.UtcNow;
        public bool IsTaken { get; set; }
        public string? Notes { get; set; }

        // Navigation properties
        public Therapy? Therapy { get; set; }
    }

}
