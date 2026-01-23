using Application.DTOs;
using Application.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Services.Base
{
    public interface IService<TModel, TSearch, TKey> where TSearch: BaseSearchObject where TKey: notnull
    {
        public PagedResult<TModel> GetPaged(TSearch search);
        public TModel GetById(TKey id);
    }
}
