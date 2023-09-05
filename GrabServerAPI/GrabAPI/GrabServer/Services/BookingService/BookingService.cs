using GrabServerCore.DTOs.Booking;
using GrabServerCore.Models;
using Microsoft.Identity.Client;

namespace GrabServer.Services.BookingService
{
    public class BookingService : IBookingService
    {
        private readonly UnitOfWork _unitOfWork;

        public BookingService(UnitOfWork uof)
        {
            _unitOfWork = uof;
        }
        public List<RecentBookingDTO> GetRecentBookingAsync()
        {
            var result =  _unitOfWork.BookingRepo.GetRecentBooking();
            _unitOfWork.SaveChanges();
            return result;
        }
        public List<ReadReceivedBookingDTO> GetReceivedBookingAsync()
        {
            var result = _unitOfWork.BookingRepo.GetAllReceivedBooking();
            _unitOfWork.SaveChanges();
            return result;
        }
        public async Task<int> AddBooking(AddBookingDTO booking)
        {
            var result = await _unitOfWork.BookingRepo.CreateBookingAsync(booking);
            await _unitOfWork.SaveChangesAsync();
            return result;
        }

        public async Task<int> DeleteBooking(int deleteBooking)
        {
            var result = await _unitOfWork.BookingRepo.DeleteBookingAsync(deleteBooking);
            await _unitOfWork.SaveChangesAsync();

            return result;
        }

        public async Task<List<Booking>> GetAllBookings(int accountId)
        {
            var listBookingAccounts = await _unitOfWork.BookingRepo.GetAllAsync(accountId);
            return listBookingAccounts.ToList();
        }

        public async Task<int> UpdateBooking(Booking request)
        {
            var result = await _unitOfWork.BookingRepo.UpdateAsync(request);
            await _unitOfWork.SaveChangesAsync();

            return result;
        }

        public async Task<int> ConfirmBooking(int accountId, int totalPay)
        {
            var result = await _unitOfWork.BookingRepo.ConfirmBookingAsync(accountId, totalPay);
            return result;
        }

        //public async Task<int> FindDriverBooking(double Longi, double Lati)
        //{
        //    var result = await _unitOfWork.BookingRepo.FindDriverAsync(Longi, Lati);
        //    return result;
        //}
    }
}
