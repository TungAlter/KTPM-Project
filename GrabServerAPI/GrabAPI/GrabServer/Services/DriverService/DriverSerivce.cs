using GrabServer.Services.BookingService;
using GrabServerCore.Models;
using Microsoft.Identity.Client;

namespace GrabServer.Services.DriverService
{
    public class DriverSerivce : IDriverService
    {
        private readonly UnitOfWork _unitOfWork;

        public DriverSerivce(UnitOfWork uof)
        {
            _unitOfWork = uof;
        }
        //public async Task<int> UpdatePositionAccount(double Long, double Lat)
        //{
        //    var result = await _unitOfWork.DriverRepo.GetAllAsync();
        //    await _unitOfWork.SaveChangesAsync();
        //    return 0;
        //}

        public async Task<int> FindDriverBooking(double Longi, double Lati)
        {
            var result = await _unitOfWork.DriverRepo.FindDriverAsync(Longi, Lati);
            await _unitOfWork.SaveChangesAsync();
            return result;
        }
    }
}
