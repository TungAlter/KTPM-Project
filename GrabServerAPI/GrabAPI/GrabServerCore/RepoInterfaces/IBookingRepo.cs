using GrabServerCore.DTOs.Booking;
using GrabServerCore.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerCore.RepoInterfaces
{
    public interface IBookingRepo : IRepository<Booking>
    {
        Task<IEnumerable<Booking>> GetAllAsync(int accountId);
        Task<int> CreateBookingAsync(AddBookingDTO booking);
        Task<int> DeleteBookingAsync(int deleteBooking);
        new Task<int> UpdateAsync(Booking deleteBooking);
        Task<int> FindDriverForBooking(int id);
        Task<int> ConfirmBookingAsync(int accountId, int total);
        Task<int> UpdateLocationBookingAsync(int id, float srcLong, float srcLat, float desLong, float desLat, float Distance);
        List<RecentBookingDTO> GetRecentBooking();
        List<ReadReceivedBookingDTO> GetAllReceivedBooking();
        List<RecentBookingDTO> GetNewBooking();
        //Task<int> FindDriverAsync(double Longi, double Lati);
    }
}
