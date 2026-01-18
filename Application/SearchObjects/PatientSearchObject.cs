using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.SearchObjects
{
    public class PatientSearchObject: BaseSearchObject
    {
        public string? NameGTE { get; set; }
        public string? LastNameGTE { get; set; }
        public string? EmailGTE { get; set; }
    }
}
