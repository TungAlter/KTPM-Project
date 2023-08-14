using Microsoft.EntityFrameworkCore;
using GrabServerCore.Common.Helper;
using GrabServerCore.Models;
using GrabServerCore.RepoInterfaces;
using GrabServerCore.DTOs.Booking;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;

namespace GrabServerData.Repositories
{
    public class BookingRepo : RepositoryBase<Booking>, IBookingRepo
    {
        readonly GrabDataContext _dataContext;

        public BookingRepo(GrabDataContext dataContext) : base(dataContext)
        {
            _dataContext = dataContext;
        }


        //eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTUxMiIsInR5cCI6IkpXVCJ9.eyJodHRw
        //    Oi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiaGFoYWhhIiwiaHR0cDovL3NjaG
        //    VtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVXNlciIsImV4cCI6MTY5MTY2NTYyNH0
        //    .31gycnyhrBK1vDIXA4XHxWMKG1kH1C129_iALw7BcAOIusBrfrm8XkGsk1sBGjUSBwY9nlGLzVQAIVAGGOxasw
        public async Task<IEnumerable<Booking>> GetAllAsync(int accountId)
        {
            string a = accountId.ToString();
            Console.WriteLine("Customer ID: "+a);

            var builder = new StringBuilder(@"dbo.USP_GetAllBooking ");
            //@AccountId = 
            builder.Append(a);

            Console.WriteLine(builder.ToString());
            var result = await _dataContext.Bookings.FromSqlInterpolated($"EXECUTE({builder.ToString()})").ToListAsync();
            
            return result;
        }

        public async Task<int> CreateBookingAsync(AddBookingDTO booking)
        {
            var builder = new StringBuilder(@"EXEC dbo.USP_AddBooking ");
            builder.Append($"@AccountId = \'{booking.IdCustomer}\', ");
            //builder.Append($"@CreatedDate = \'{booking.DateBooking}\', ");
            builder.Append($"@srclongi = \'{booking.SrcLong}\', ");
            builder.Append($"@srclati = \'{booking.SrcLat}\', ");
            builder.Append($"@deslongi = \'{booking.DesLong}\', ");
            builder.Append($"@deslati = \'{booking.DesLat}\', ");
            builder.Append($"@distance = \'{booking.Distance}\',\n");
            builder.Append($"@srcaddr = N\'{booking.SrcAddress}\',\n");
            builder.Append($"@desaddr = N\'{booking.DesAddress}\',\n");
            builder.Append($"@note= N\'{booking.Notes}\';\n");
            //builder.Append($"@total = \'{booking.Total}\';\n");

            Console.WriteLine(builder.ToString());
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
