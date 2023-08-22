using GrabServerCore.DTOs.Booking;
using GrabServerCore.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerCore.RepoInterfaces
{
    public interface IDriverRepo : IRepository<Driver>
    {
        Task<IEnumerable<Booking>> GetAllAsync(int accountId);
        //Task<int> CreateBookingAsync(AddBookingDTO booking);
        Task<int> DeleteBookingAsync(int deleteBooking);
        Task<int> UpdateAsync(Booking deleteBooking);
        Task<int> FindDriverAsync(double Longi, double Lat);
        //Task<int> UpdatePositionAccountAsync(string username, double Long, double Lat);
    }
}
