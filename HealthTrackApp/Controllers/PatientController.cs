using Application.DTOs;
using Application.DTOs.Models;
using Application.SearchObjects;
using Application.Services.Base;
using Application.Services.Patient;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    public class PatientController : BaseCRUDController<PatientModel, PatientSearchObject, PatientInsertRequest, PatientUpdateRequest>

    {
        public PatientController(IPatientService service) : base(service)
        {
        }
    }
}
