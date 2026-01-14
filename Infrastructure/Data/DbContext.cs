using Domain.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data
{
    public class ApplicationDbContext : IdentityDbContext<User>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<Patient> Patients { get; set; }
        public DbSet<Doctor> Doctors { get; set; }
        public DbSet<MedicalParameter> MedicalParameters { get; set; }
        public DbSet<Medication> Medications { get; set; }
        public DbSet<Therapy> Therapies { get; set; }
        public DbSet<TherapyLog> TherapyLogs { get; set; }
        public DbSet<Appointment> Appointments { get; set; }
        public DbSet<Diagnosis> Diagnoses { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<HealthJournal> HealthJournals { get; set; }
        public DbSet<PatientParameter> PatientParameters { get; set; }
        public DbSet<Recommendation> Recommendations { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Konfiguracija TPH (Table Per Hierarchy) za User, Patient, Doctor
            modelBuilder.Entity<User>()
                .HasDiscriminator<string>("UserType")
                .HasValue<User>("User")
                .HasValue<Patient>("Patient")
                .HasValue<Doctor>("Doctor");

            // Patient -> Therapy (One-to-Many)
            modelBuilder.Entity<Therapy>()
                .HasOne(t => t.Patient)
                .WithMany(p => p.Therapies)
                .HasForeignKey(t => t.PatientId)
                .OnDelete(DeleteBehavior.Restrict);

            // Doctor -> Therapy (One-to-Many)
            modelBuilder.Entity<Therapy>()
                .HasOne(t => t.Doctor)
                .WithMany(d => d.Therapies)
                .HasForeignKey(t => t.DoctorId)
                .OnDelete(DeleteBehavior.SetNull);

            // Medication -> Therapy (One-to-Many)
            modelBuilder.Entity<Therapy>()
                .HasOne(t => t.Medication)
                .WithMany(m => m.Therapies)
                .HasForeignKey(t => t.MedicationId)
                .OnDelete(DeleteBehavior.Restrict);

            // Therapy -> TherapyLog (One-to-Many)
            modelBuilder.Entity<TherapyLog>()
                .HasOne(tl => tl.Therapy)
                .WithMany(t => t.TherapyLogs)
                .HasForeignKey(tl => tl.TherapyId)
                .OnDelete(DeleteBehavior.Cascade);

            // Patient -> Appointment (One-to-Many)
            modelBuilder.Entity<Appointment>()
                .HasOne(a => a.Patient)
                .WithMany(p => p.Appointments)
                .HasForeignKey(a => a.PatientId)
                .OnDelete(DeleteBehavior.Restrict);

            // Doctor -> Appointment (One-to-Many)
            modelBuilder.Entity<Appointment>()
                .HasOne(a => a.Doctor)
                .WithMany(d => d.Appointments)
                .HasForeignKey(a => a.DoctorId)
                .OnDelete(DeleteBehavior.Restrict);

            // Patient -> Diagnosis (One-to-Many)
            modelBuilder.Entity<Diagnosis>()
                .HasOne(d => d.Patient)
                .WithMany(p => p.Diagnoses)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.Restrict);

            // Patient -> HealthJournal (One-to-Many)
            modelBuilder.Entity<HealthJournal>()
                .HasOne(hj => hj.Patient)
                .WithMany(p => p.HealthJournals)
                .HasForeignKey(hj => hj.PatientId)
                .OnDelete(DeleteBehavior.Restrict);

            // User -> Notification (One-to-Many)
            modelBuilder.Entity<Notification>()
                .HasOne(n => n.User)
                .WithMany(u => u.Notifications)
                .HasForeignKey(n => n.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // Patient -> PatientParameter (One-to-Many)
            modelBuilder.Entity<PatientParameter>()
                .HasOne(pp => pp.Patient)
                .WithMany(p => p.PatientParameters)
                .HasForeignKey(pp => pp.PatientId)
                .OnDelete(DeleteBehavior.Restrict);

            // MedicalParameter -> PatientParameter (One-to-Many)
            modelBuilder.Entity<PatientParameter>()
                .HasOne(pp => pp.Parameter)
                .WithMany(mp => mp.PatientParameters)
                .HasForeignKey(pp => pp.ParameterId)
                .OnDelete(DeleteBehavior.Restrict);

            // Patient -> Recommendation (One-to-Many)
            modelBuilder.Entity<Recommendation>()
                .HasOne(r => r.Patient)
                .WithMany(p => p.Recommendations)
                .HasForeignKey(r => r.PatientId)
                .OnDelete(DeleteBehavior.Restrict);

            // Decimal precision konfiguracija
            modelBuilder.Entity<PatientParameter>()
                .Property(pp => pp.Value)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Recommendation>()
                .Property(r => r.Probability)
                .HasPrecision(5, 2);

            // Indeksi za bolje performanse
            modelBuilder.Entity<Therapy>()
                .HasIndex(t => new { t.PatientId, t.IsActive });

            modelBuilder.Entity<Appointment>()
                .HasIndex(a => new { a.PatientId, a.AppointmentDate });

            modelBuilder.Entity<Appointment>()
                .HasIndex(a => new { a.DoctorId, a.AppointmentDate });

            modelBuilder.Entity<PatientParameter>()
                .HasIndex(pp => new { pp.PatientId, pp.ParameterId, pp.RecordedAt });

            modelBuilder.Entity<Notification>()
                .HasIndex(n => new { n.UserId, n.IsRead, n.CreatedAt });
        }
    }
}
