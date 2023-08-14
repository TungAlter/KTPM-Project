using GrabServerCore.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerData
{
    public class GrabDataContext : DbContext
    {
        public GrabDataContext(DbContextOptions<GrabDataContext> options) : base(options)
        {

        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Booking>().HasKey(x => new { x.IdCustomer, x.IdDriver, x.DateBooking });
        }

        public DbSet<Account> Accounts { get; set; }
        public DbSet<Booking> Bookings { get; set; }    
    }
}
