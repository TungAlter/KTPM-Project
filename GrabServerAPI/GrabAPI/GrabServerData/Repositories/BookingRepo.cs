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
using AutoMapper;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace GrabServerData.Repositories
{
    public class BookingRepo : RepositoryBase<Booking>, IBookingRepo
    {
        readonly GrabDataContext _dataContext;
        private readonly IMapper _mapper;

        public BookingRepo(GrabDataContext dataContext, IMapper mapper) : base(dataContext)
        {
            _dataContext = dataContext;
            _mapper = mapper;
        }

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

        public List<RecentBookingDTO> GetRecentBooking()
        {
            var builder = new StringBuilder(@"dbo.USP_Get3RecentBooking");;

            Console.WriteLine(builder.ToString());
            var bookings = new List<RecentBookingDTO>();
            //bookings = _dataContext.Database.SqlQuery<RecentBookingDTO>($"EXECUTE({builder.ToString()})").ToList();
            bookings = _dataContext.RecentBookings.FromSqlInterpolated($"EXECUTE({builder.ToString()})").ToList();

            return bookings;
        }

        public List<ReadReceivedBookingDTO> GetAllReceivedBooking()
        {
            var builder = new StringBuilder(@"dbo.USP_GetReceivedBooking"); ;

            Console.WriteLine(builder.ToString());
            var bookings = new List<ReadReceivedBookingDTO>();
            //bookings = _dataContext.Database.SqlQuery<RecentBookingDTO>($"EXECUTE({builder.ToString()})").ToList();
            bookings = _dataContext.ReadReceivedBookings.FromSqlInterpolated($"EXECUTE({builder.ToString()})").ToList();

            return bookings;
        }

        public List<RecentBookingDTO> GetNewBooking()
        {
            var builder = new StringBuilder(@"dbo.USP_GetNewBooking"); ;

            Console.WriteLine(builder.ToString());
            var bookings = new List<RecentBookingDTO>();
            //bookings = _dataContext.Database.SqlQuery<RecentBookingDTO>($"EXECUTE({builder.ToString()})").ToList();
            bookings = _dataContext.RecentBookings.FromSqlInterpolated($"EXECUTE({builder.ToString()})").ToList();
            //List<ReadNewBookingDTO> lists = new List<ReadNewBookingDTO>();
            //foreach ( var item in bookings )
            //{
            //    ReadNewBookingDTO p = new<ReadNewBookingDTO>();
            //    lists.Add(p);
            //}
            return bookings;
        }
        public async Task<int> CreateBookingAsync(AddBookingDTO booking)
        {
            string srcaddr = booking.addrFrom.address+","+booking.addrFrom.ward+","+booking.addrFrom.district+","+booking.addrFrom.province;
            string desaddr = booking.addrTo.address + "," + booking.addrTo.ward + "," + booking.addrTo.district + "," + booking.addrTo.province;
            var builder = new StringBuilder(@"EXEC dbo.USP_AddBooking ");
            builder.Append($"@fullname = N\'{booking.FullName}\', ");
            builder.Append($"@email = N\'{booking.Email}\', ");
            builder.Append($"@phone = N\'{booking.Phone}\', ");
            builder.Append($"@srcaddr = N\'{srcaddr}\', ");
            builder.Append($"@desaddr = N\'{desaddr}\' ");
            Console.WriteLine(builder.ToString());
            var result = await _dataContext.Database.ExecuteSqlInterpolatedAsync($"EXECUTE({builder.ToString()})");
            return result;
        }
        public async Task<int> FindDriverForBooking(int id)
        {
            var builder = new StringBuilder(@"EXEC dbo.USP_FindDriverForBooking ");
            builder.Append($"@BookingId = \'{id}\' ");
            Console.WriteLine(builder.ToString());
            var result = await _dataContext.Database.ExecuteSqlInterpolatedAsync($"EXECUTE({builder.ToString()})");
            return result;
        }
        public async Task<int> UpdateLocationBookingAsync(int id, float srcLong, float srcLat, float desLong, float desLat, float Distance)
        {
            var builder = new StringBuilder(@"EXEC dbo.USP_UpdateLocationBooking ");
            builder.Append($"@BookingId = \'{id}\', ");
            builder.Append($"@srcLong = \'{srcLong}\', ");
            builder.Append($"@srcLat = \'{srcLat}\', ");
            builder.Append($"@desLong = \'{desLong}\', ");
            builder.Append($"@desLat = \'{desLat}\', ");
            builder.Append($"@Distance = \'{Distance}\' ");
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
            var builder = new StringBuilder("EXECUTE dbo.USP_DeleteBooking ");
            builder.Append($"@BookingId = \'{deleteBooking}\' ");

            Console.WriteLine(builder.ToString());
            var result = await _dataContext.Database.ExecuteSqlInterpolatedAsync($"EXECUTE sp_executesql {builder.ToString()}");
            return result;
        }

        public async Task<int> UpdateCompletedBooking(int bookingId)
        {
            var builder = new StringBuilder(@"EXEC dbo.USP_UpdateCompleteBooking ");
            builder.Append($"@BookingId = \'{bookingId}\' ");
            Console.WriteLine(builder.ToString());
            var result = await _dataContext.Database.ExecuteSqlInterpolatedAsync($"EXECUTE({builder.ToString()})");
            return result;
            //string str = $"EXEC USP_ConfirmBooking @AccountId={accountId}, @Total={total};";
            //return await _dataContext.Database.ExecuteSqlInterpolatedAsync($"EXECUTE({str})");
        }
        public async Task<int> CaculatingTotalBooking(int bookingId, int WeatherInfo, bool isPeak)
        {
            int Peak = 0;
            if(isPeak == true)
            {
                Peak = 1;
            }
            var builder = new StringBuilder(@"EXEC dbo.USP_CaculatingTotal ");
            builder.Append($"@BookingId = \'{bookingId}\', ");
            builder.Append($"@srcLong = \'{WeatherInfo}\', ");
            builder.Append($"@srcLat = \'{Peak}\' ");
            Console.WriteLine(builder.ToString());
            var result = await _dataContext.Database.ExecuteSqlInterpolatedAsync($"EXECUTE({builder.ToString()})");
            return result;
        }
    }
}
