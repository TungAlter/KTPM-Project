using GrabServerCore.Common.Helper;
using GrabServerCore.Models;
using GrabServerCore.RepoInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using GrabServerCore.DTOs.Booking;
using Microsoft.EntityFrameworkCore;

namespace GrabServerData.Repositories
{
    public class DriverRepo : RepositoryBase<Driver>, IDriverRepo
    {
        readonly GrabDataContext _dataContext;
        public DriverRepo(GrabDataContext dataContext) : base(dataContext)
        {
            _dataContext = dataContext;
        }
        public async Task<IEnumerable<Booking>> GetAllAsync(int accountId)
        {
            string a = accountId.ToString();
            Console.WriteLine("Customer ID: " + a);

            var builder = new StringBuilder(@"dbo.USP_GetAllBooking ");
            //@AccountId = 
            builder.Append(a);

            Console.WriteLine(builder.ToString());
            var result = await _dataContext.Bookings.FromSqlInterpolated($"EXECUTE({builder.ToString()})").ToListAsync();

            return result;
        }

        public async Task<int> UpdateAsync(Booking booking)
        {
            //int paid = booking.Paid ? 1 : 0;
            //var builder = new StringBuilder("EXECUTE dbo.USP_UpdateBooking ");
            //var str = SetPropValueByReflection.GetPropProcCallString(booking);
            //builder.Append(str);

            //Console.WriteLine(builder.ToString());
            //return await _dataContext.Database.ExecuteSqlInterpolatedAsync($"EXECUTE sp_executesql {builder.ToString()}");
            return 0;
        }

        public async Task<int> DeleteBookingAsync(int deleteBooking)
        {
            //var builder = new StringBuilder("EXECUTE dbo.USP_DeleteBooking ");
            //builder.Append($"@BookingId = \'{deleteBooking}\';");

            //Console.WriteLine(builder.ToString());
            //return await _dataContext.Database.ExecuteSqlInterpolatedAsync($"EXECUTE sp_executesql {builder.ToString()}");
            return 0;
        }
        public async Task<int> FindDriverAsync(double Longi, double Lati)
        {
            //var builder = new StringBuilder(@"EXEC dbo.USP_FindDriver ");
            //builder.Append($"@Longi = \'{Longi}\', ");
            //builder.Append($"@Lati = \'{Lati}\'; ");
            //Console.WriteLine(builder.ToString());
            //var result = await _dataContext.Drivers.ExecuteSqlInterpolatedAsync($"EXECUTE({builder.ToString()})");
            //return result;
            return 0;
        }

        //public async Task<int> FindDriverAsync(double Longi, double Lati)
        //{
        //    var builder = new StringBuilder(@"EXEC dbo.USP_FindDriver ");
        //    builder.Append($"@Longi = \'{Longi}\', ");
        //    builder.Append($"@Lati = \'{Lati}\'; ");
        //    Console.WriteLine(builder.ToString());
        //    var result = await _dataContext.Drivers.ExecuteSqlInterpolatedAsync($"EXECUTE({builder.ToString()})");
        //    return result;
        //}
    }


} 
   
