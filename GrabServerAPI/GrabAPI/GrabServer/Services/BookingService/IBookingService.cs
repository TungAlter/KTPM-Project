using GrabServerCore.DTOs.Booking;

namespace GrabServer.Services.BookingService
{
    public interface IBookingService
    {
        Task<List<Booking>> GetAllBookings(int accountId);
        Task<int> AddBooking(AddBookingDTO bookingDto);
        Task<int> UpdateBooking(Booking request);
        Task<int> DeleteBooking(int deleteDto);
        Task<int> ConfirmBooking(int accountId, int totalPay);
        List<RecentBookingDTO> GetRecentBookingAsync();
        List<ReadReceivedBookingDTO> GetReceivedBookingAsync();
    }
}
