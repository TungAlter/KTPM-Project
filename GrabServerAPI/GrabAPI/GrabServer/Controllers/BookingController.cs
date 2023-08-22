using GrabServer.Services.AccountService;
using GrabServer.Services.BookingService;
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
    public class BookingController : ControllerBase
    {
        IBookingService _bookingService;
        IAccountService _accountService;
        public BookingController(IBookingService bookingService, IAccountService accountService) {
            _bookingService = bookingService;
            _accountService = accountService;
        }
        [HttpGet, Authorize(Roles = GlobalConstant.User)]
        public async Task<ActionResult<ResponseMessageDetails<List<Booking>>>> GetAllUserBookings()
        {
            Account currentAcc = await _accountService.GetByUsername(User.Identity.Name);
            var result = await _bookingService.GetAllBookings(currentAcc.Id);
            var booking_list = new List<Booking>();
            //if (result == null)
            //{
            //    return Ok(new ResponseMessageDetails<List<Booking>>("Not have any Booking", GrabServerCore.Common.Enum.ResponseStatusCode.NoContent));
            //}
            foreach (var item in result)
            {
                booking_list.Add(item);
            }
            return Ok(new ResponseMessageDetails<List<Booking>>("Get bookings successfully", booking_list));
        }

        [HttpPost, Authorize(Roles = GlobalConstant.User)]
        public async Task<ActionResult<ResponseMessageDetails<int>>> AddBooking(AddBookingDTO addBookingDTO)
        {
            Account currentAcc = await _accountService.GetByUsername(User.Identity.Name);
            addBookingDTO.IdCustomer = currentAcc.Id;
            var result = await _bookingService.AddBooking(addBookingDTO);

            if (result == 0)
                return BadRequest("Cannot add booking.");

            return Ok(new ResponseMessageDetails<int>("Add booking successfully", result));
        }

        //[HttpGet("Find-Driver")]
        ////, Authorize(Roles = GlobalConstant.User) 
        //public async Task<ActionResult<ResponseMessageDetails<int>>> FindDriver(double Longi, double Lati)
        //{
        //    var result = await _bookingService.FindDriverBooking(Longi, Lati);

        //    if (result == 0)
        //        return BadRequest("Cannot add booking.");
        //    return Ok(new ResponseMessageDetails<int>("Add booking successfully", result));
        //}

    }
}
