using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class HealthJournal
    {
        public int Id { get; set; }
        public string PatientId { get; set; } = string.Empty;
        public DateTime EntryDate { get; set; } = DateTime.UtcNow;
        public string Category { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public string? Notes { get; set; }

        // Navigation properties
        public Patient? Patient { get; set; }
    }

}
