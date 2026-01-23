using Application.DTOs;
using Application.SearchObjects;
using AutoMapper;
using Infrastructure.Data;
using Microsoft.EntityFrameworkCore.Metadata;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Services.Base
{
    public class BaseService<TModel, TSearch, TDbEntity, TKey> : IService<TModel, TSearch, TKey>
        where TModel : class
        where TSearch : BaseSearchObject
        where TDbEntity : class
        where TKey: notnull
    {
        public ApplicationDbContext dbContext { get; set; }
        protected readonly IMapper Mapper;

        public BaseService(ApplicationDbContext dbContext, IMapper mapper)
        {
            this.dbContext = dbContext;
            Mapper = mapper;
        }
        public TModel GetById(TKey id)
        {
            var entity = dbContext.Set<TDbEntity>().Find(id);

            if(entity !=  null)
                return Mapper.Map<TModel>(entity);
            return null;
        }

        public PagedResult<TModel> GetPaged(TSearch search)
        {
            List<TModel> result = new List<TModel>();

            var queryable = dbContext.Set<TDbEntity>().AsQueryable();

            int count = queryable.Count();

            if (search?.PageSize.HasValue == true && search?.Page.HasValue == true)
                queryable = queryable.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);

            var lst = queryable.ToList();

            result = Mapper.Map(lst, result);

            PagedResult<TModel> paged = new PagedResult<TModel>();
            paged.ResultList = result;
            paged.TotalCount = count;

            return paged;
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }
    }
}
