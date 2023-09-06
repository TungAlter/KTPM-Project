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
        Task<int> FindDriverAsync(int id);
        Task<int> UpdateLocationAsync(int id, float srcLong, float srcLat, float desLong, float desLat, float Distance);
        List<RecentBookingDTO> GetRecentBookingAsync();
        List<ReadReceivedBookingDTO> GetReceivedBookingAsync();
        List<RecentBookingDTO> GetNewBookingAsync();
    }
}
