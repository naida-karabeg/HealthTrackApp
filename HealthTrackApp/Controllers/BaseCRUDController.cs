using Application.SearchObjects;
using Application.Services.Base;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [Authorize]
    public class BaseCRUDController<TModel, TSearch, TInsert, TUpdate, TKey> : BaseController<TModel, TSearch, TKey>
        where TSearch : BaseSearchObject where TModel : class where TKey : notnull
    {
        protected new ICRUDService<TModel, TSearch, TInsert, TUpdate, TKey> service;
        public BaseCRUDController(ICRUDService<TModel, TSearch, TInsert, TUpdate, TKey> service) : base((IService<TModel, TSearch, TKey>)service)
        {
            this.service = service;
        }

        [HttpPost]
        public virtual TModel Insert(TInsert request)
        {
            return service.Insert(request);
        }

        [HttpPut("{id}")]
        public virtual TModel Update(TKey id, TUpdate request)
        {
            return service.Update(id, request);
        }   
    }
}
