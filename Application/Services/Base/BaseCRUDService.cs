using Application.SearchObjects;
using AutoMapper;
using Infrastructure.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Services.Base
{
    public class BaseCRUDService<TModel, TSearch, TInsert, TUpdate, TDbEntity> : BaseService<TModel, TSearch, TDbEntity>,
        ICRUDService<TModel, TSearch, TInsert, TUpdate>
        where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        public BaseCRUDService(ApplicationDbContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }
        public virtual void BeforeInsert(TInsert req, TDbEntity entity)
        { }
        
        public virtual TModel Insert(TInsert request)
        {
            TDbEntity entity = Mapper.Map<TDbEntity>(request);
            BeforeInsert(request, entity);

            dbContext.Set<TDbEntity>().Add(entity);
            dbContext.SaveChanges();
            return Mapper.Map<TModel>(entity);
            
        }

        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity)
        { }

        public virtual TModel Update(int id, TUpdate request)
        {
            var entity = Mapper.Map<TDbEntity>(request);
            BeforeUpdate(request, entity);

            dbContext.Set<TDbEntity>().Update(entity);
            dbContext.SaveChanges();
            return Mapper.Map<TModel>(entity);
        }
    }
}
