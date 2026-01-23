using Application.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Services.Base
{
    public interface ICRUDService<TModel, TSearch, TInsert, TUpdate, TKey> where TModel : class where TSearch : BaseSearchObject where TKey : notnull
    {
        TModel Insert(TInsert request);
        TModel Update(TKey id, TUpdate request);
    }
}
