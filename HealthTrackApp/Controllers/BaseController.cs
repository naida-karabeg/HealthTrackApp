using Application.SearchObjects;
using Application.Services.Base;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class BaseController<TModel, TSearch, TKey> : ControllerBase
    where TSearch : BaseSearchObject
{
    protected readonly IService<TModel, TSearch, TKey> service;

    public BaseController(IService<TModel, TSearch, TKey> service)
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
    public virtual IActionResult GetById(TKey id)
    {
        var result = service.GetById(id);

        if (result == null)
            return NotFound();

        return Ok(result);
    }
}
