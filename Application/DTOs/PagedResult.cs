using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.DTOs
{
    public class PagedResult<T>
    {
        public int TotalCount { get; set; }
        public IList<T> ResultList { get; set; } = new List<T>();
    }
}
