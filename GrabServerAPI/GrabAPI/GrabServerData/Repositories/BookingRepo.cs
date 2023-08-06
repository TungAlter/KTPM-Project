using GrabServerCore.DTOs.Booking;
using GrabServerCore.Models;
using GrabServerCore.RepoInterfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerData.Repositories
{
    public class BookingRepo : RepositoryBase<Booking>, IBookingRepo
    {
        readonly GrabDataContext _dataContext;

        public BookingRepo(GrabDataContext dataContext) : base(dataContext)
        {
            _dataContext = dataContext;
        }

        public async Task<IEnumerable<Booking>> GetAllAsync(int accountId)
        {
            var result = await _dataContext.Bookings.FromSqlInterpolated($"USP_GetAllBooking @AccountId = {accountId}").ToListAsync();
            return result;
        }

        public async Task<int> CreateBookingAsync(AddBookingDTO booking)
        {
            var builder = new StringBuilder(@"EXEC dbo.USP_AddBooking");
            builder.Append($"@AccountId = \'{booking.IdCustomer}\', ");
            builder.Append($"@CreatedDate = \'{booking.DateBooking}\', ");
            builder.Append($"@srclongi = \'{booking.SrcLong}\', ");
            builder.Append($"@srclati = \'{booking.SrcLat}\', ");
            builder.Append($"@deslongi = \'{booking.DesLong}\', ");
            builder.Append($"@deslati = \'{booking.DesLat}\', ");
            builder.Append($"@distance = \'{booking.Distance}\';\n");
            builder.Append($"@srcaddr = \'{booking.SrcAddress}\';\n");
            builder.Append($"@desaddr = \'{booking.DesAddress}\';\n");
            builder.Append($"@note= \'{booking.Notes}\';\n");
            builder.Append($"@total = \'{booking.Total}\';\n");

            // Console.WriteLine(builder.ToString());
            var result = await _dataContext.Database.ExecuteSqlInterpolatedAsync($"EXECUTE({builder.ToString()})");
            return result;


        }

        public new async Task<int> UpdateAsync(Booking booking)
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

        public async Task<int> ConfirmBookingAsync(int accountId, int total)
        {
            //string str = $"EXEC USP_ConfirmBooking @AccountId={accountId}, @Total={total};";
            //return await _dataContext.Database.ExecuteSqlInterpolatedAsync($"EXECUTE({str})");
            return 0;
        }
    }
}
