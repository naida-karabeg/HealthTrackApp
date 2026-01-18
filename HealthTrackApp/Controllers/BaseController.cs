using Application.SearchObjects;
using Application.Services.Base;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class BaseController<TModel, TSearch> : ControllerBase where TSearch: BaseSearchObject
    {
        protected IService<TModel, TSearch> service;

        public BaseController(IService<TModel, TSearch> service)
        {
            this.service = service;
        }

        [HttpGet]
        public virtual IActionResult Get([FromQuery] TSearch search)
        {
            var result = service.GetPaged(search);
            return Ok(result);
        }

        [HttpGet("{id}")]
        public virtual TModel Get(int id)
        {
            return service.GetById(id);
        }
    }
}
