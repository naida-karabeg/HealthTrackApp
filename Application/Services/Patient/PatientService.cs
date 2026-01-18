using Application.DTOs;
using Application.DTOs.Models;
using Application.SearchObjects;
using Application.Services.Base;
using AutoMapper;
using Domain.Entities;
using Infrastructure.Data;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Services.Patient
{
    public class PatientService : BaseCRUDService<PatientModel, PatientSearchObject, PatientInsertRequest, PatientUpdateRequest, Domain.Entities.Patient>,
        IPatientService
    {
        private readonly UserManager<User> _userManager;

        public PatientService(ApplicationDbContext dbContext, IMapper mapper, UserManager<User> userManager) 
            : base(dbContext, mapper)
        {
            _userManager = userManager;
        }

        public override PatientModel Insert(PatientInsertRequest request)
        {
            var patient = Mapper.Map<Domain.Entities.Patient>(request);
            
            // Koristimo UserManager za kreiranje pacijenta
            var result = _userManager.CreateAsync(patient).GetAwaiter().GetResult();
            
            if (!result.Succeeded)
            {
                var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                throw new Exception($"Failed to create patient: {errors}");
            }

            return Mapper.Map<PatientModel>(patient);
        }

        public override PatientModel Update(int id, PatientUpdateRequest request)
        {
            var patient = _userManager.Users.OfType<Domain.Entities.Patient>()
                .FirstOrDefault(p => p.Id == id.ToString());
            
            if (patient == null)
            {
                throw new Exception($"Patient with id {id} not found");
            }

            // Mapiramo promjene na postojeći entitet
            Mapper.Map(request, patient);
            patient.UpdatedAt = DateTime.UtcNow;

            var result = _userManager.UpdateAsync(patient).GetAwaiter().GetResult();
            
            if (!result.Succeeded)
            {
                var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                throw new Exception($"Failed to update patient: {errors}");
            }

            return Mapper.Map<PatientModel>(patient);
        }

        public override IQueryable<Domain.Entities.Patient> AddFilter(PatientSearchObject search, IQueryable<Domain.Entities.Patient> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            if (!string.IsNullOrEmpty(search?.NameGTE))
                filteredQuery = filteredQuery.Where(x => x.FirstName.Contains(search.NameGTE));

            return filteredQuery;
        }
    }
}
