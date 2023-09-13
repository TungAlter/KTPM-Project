using GrabServer.Services.AccountService;
using GrabServer.Services.BookingService;
using GrabServer.Services.DriverService;
using GrabServer.Services.WeatherService;
using GrabServerCore.Common.Constant;
using GrabServerCore.DTOs;
using GrabServerCore.DTOs.Booking;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;

namespace GrabServer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        IBookingService _bookingService;
        private readonly IDriverService _driverService;

        public UserController(IBookingService bookingService, IDriverService driverService)
        {
            _bookingService = bookingService;
            _driverService = driverService;
        }

        [HttpGet("DriverInfo/{id}")]
        public async Task<ActionResult<Driver>> GetDriverInformationById(int id)
        {
            var result = await _driverService.GetDriverInfo(id);
            //var d = new Driver();
            if (result != null)
            {
                return Ok(result);
            }
            return BadRequest(result);
            //{
            //    return Ok(new ResponseMessageDetails<List<Booking>>("Not have any Booking", GrabServerCore.Common.Enum.ResponseStatusCode.NoContent));
            //}
        }

    }
}
