using Application.DTOs;
using Application.DTOs.Models;
using Application.SearchObjects;
using Application.Services.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Services.Patient
{
    public interface IPatientService : ICRUDService<PatientModel, PatientSearchObject, PatientInsertRequest, PatientUpdateRequest, string>
    {

    }
}
