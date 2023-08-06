using GrabServerCore.DTOs.Booking;

namespace GrabServer.Services.BookingService
{
    public class BookingService : IBookingService
    {
        private readonly UnitOfWork _unitOfWork;

        public BookingService(UnitOfWork uof)
        {
            _unitOfWork = uof;
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
    }
}
