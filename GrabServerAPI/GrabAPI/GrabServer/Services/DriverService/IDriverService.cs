using GrabServerCore.DTOs.Booking;

namespace GrabServer.Services.DriverService
{
    public interface IDriverService
    {
        Task<int> FindDriverBooking(double Longi, double Lati);
        Task<Driver> GetDriverInfo(int id);
    }
}
