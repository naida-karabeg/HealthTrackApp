using Application.DTOs;
using Application.DTOs.Models;
using AutoMapper;
using Domain.Entities;

namespace Application.Mappings
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            // Patient mappings
            CreateMap<Patient, PatientModel>()
                .ForMember(dest => dest.PatientId, opt => opt.MapFrom(src => src.Id));
            
            CreateMap<PatientInsertRequest, Patient>()
                .ForMember(dest => dest.CreatedAt, opt => opt.MapFrom(src => DateTime.UtcNow))
                .ForMember(dest => dest.Id, opt => opt.Ignore())
                .ForMember(dest => dest.NormalizedUserName, opt => opt.MapFrom(src => src.UserName.ToUpper()))
                .ForMember(dest => dest.NormalizedEmail, opt => opt.MapFrom(src => src.Email.ToUpper()));
            
            CreateMap<PatientUpdateRequest, Patient>()
                .ForMember(dest => dest.UpdatedAt, opt => opt.MapFrom(src => DateTime.UtcNow))
                .ForMember(dest => dest.Id, opt => opt.Ignore())
                .ForMember(dest => dest.Email, opt => opt.Ignore())
                .ForMember(dest => dest.UserName, opt => opt.Ignore())
                .ForMember(dest => dest.NormalizedUserName, opt => opt.Ignore())
                .ForMember(dest => dest.NormalizedEmail, opt => opt.Ignore())
                .ForMember(dest => dest.CreatedAt, opt => opt.Ignore())
                .ForMember(dest => dest.PasswordHash, opt => opt.Ignore())
                .ForMember(dest => dest.SecurityStamp, opt => opt.Ignore());
        }
    }
}
