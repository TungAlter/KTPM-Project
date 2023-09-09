﻿using GrabServer.Services.AccountService;
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
            //Account currentAcc = await _accountService.GetByUsername(User.Identity.Name);
            //var result = await _bookingService.GetAllBookings(currentAcc.Id);
            //var booking_list = new List<Booking>();
            ////if (result == null)
            ////{
            ////    return Ok(new ResponseMessageDetails<List<Booking>>("Not have any Booking", GrabServerCore.Common.Enum.ResponseStatusCode.NoContent));
            ////}
            //foreach (var item in result)
            //{
            //    booking_list.Add(item);
            //}
            //return Ok(new ResponseMessageDetails<List<Booking>>("Get bookings successfully", booking_list));
            return BadRequest("Not Supported This Methods");
        }
        [HttpGet("recent")]
        public List<RecentBookingDTO> GetRecentBooking()
        {
            var result = _bookingService.GetRecentBookingAsync();
            var booking_list = new List<RecentBookingDTO>();
            //if (result == null)
            //{
            //    return Ok(new ResponseMessageDetails<List<Booking>>("Not have any Booking", GrabServerCore.Common.Enum.ResponseStatusCode.NoContent));
            //}
            foreach (var item in result)
            {
                booking_list.Add(item);
            }
            return booking_list;
        }

        [HttpGet("new")]
        public List<ReadNewBookingDTO> GetNewBooking()
        {
            var result = _bookingService.GetNewBookingAsync();
            var booking_list = new List<ReadNewBookingDTO>();
            foreach (var item in result)
            {
                var p = new ReadNewBookingDTO ();
                p.Id = item.Id;
                p.FullName = item.FullName;
                p.Email = item.Email;
                p.Phone = item.PhoneNumber;
                p.AddrFrom = item.SrcAddress;
                p.AddrTo = item.DesAddress;
                booking_list.Add (p);
            }
            return booking_list;
        }

        [HttpGet("received")]
        public List<ReadReceivedBookingDTO> GetAllReceivedBooking()
        {
            var result = _bookingService.GetReceivedBookingAsync();
            var booking_list = new List<ReadReceivedBookingDTO>();
            //if (result == null)
            //{
            //    return Ok(new ResponseMessageDetails<List<Booking>>("Not have any Booking", GrabServerCore.Common.Enum.ResponseStatusCode.NoContent));
            //}
            foreach (var item in result)
            {
                booking_list.Add(item);
            }
            return booking_list;
        }

        [HttpPost, Authorize(Roles = GlobalConstant.User)]
        public async Task<ActionResult<ResponseMessageDetails<int>>> AddBooking(AddBookingDTO obj)
        {
            //Account currentAcc = await _accountService.GetByUsername(User.Identity.Name);
            //addBookingDTO.IdCustomer = currentAcc.Id;
            if (obj.Phone == null || obj.addrFrom.address == null || obj.addrFrom.ward == null || obj.addrFrom.district == null
                || obj.addrFrom.province == null || obj.addrTo.address == null || obj.addrTo.ward == null || obj.addrTo.district == null
                || obj.addrTo.province == null || obj.Email == null)
            {
                return BadRequest("Invalid Input.");
            }
            var result = await _bookingService.AddBooking(obj);

            if (result == 0)
                return BadRequest("Cannot add booking.");

            return Ok(new ResponseMessageDetails<int>("Add booking successfully", result));
        }
        [HttpPut("location")]
        public async Task<ActionResult<ResponseMessageDetails<int>>> UpdateLocationBooking(int id, float srcLong, float srcLat, float desLong, float desLat, float Distance)
        {
            if(id == 0 || srcLong == float.NaN || srcLat == float.NaN || desLong == float.NaN || desLat == float.NaN || Distance <= 0)
            {
                return BadRequest("Not Valid Input");
            }
            var result = await _bookingService.UpdateLocationAsync(id, srcLong, srcLat, desLong, desLat, Distance);
            if (result == -1)
                return BadRequest("Cannot Update Location.");

            return Ok(new ResponseMessageDetails<int>("Update Location Success", result));
        }
        [HttpPut("FindDriver")]
        public async Task<ActionResult<ResponseMessageDetails<int>>> FindDriver(int id)
        {
            var result = await _bookingService.FindDriverAsync(id);
            if (result == -1)
                return BadRequest("Cannot Find a possible Driver.");

            return Ok(new ResponseMessageDetails<int>("Find Driver Success", result));
        }
        [HttpPut("Completed")]
        public async Task<ActionResult<ResponseMessageDetails<int>>> CompletedBooking(int IdBooking)
        {
            var result = await _bookingService.CompletedBooking(IdBooking);
            if (result == -1)
                return BadRequest("Cannot Completed this booking.");

            return Ok(new ResponseMessageDetails<int>("Completed Success", result));
        }
        [HttpPut("CaculateTotal")]
        public async Task<ActionResult<ResponseMessageDetails<int>>> CaculatingTotalBooking(int IdBooking)
        {
            int weather = 1;
            bool Peak = true;
            var result = await _bookingService.CaculatingTotalBooking(IdBooking,weather,Peak);
            if (result == -1)
                return BadRequest("Cannot Caculating total.");

            return Ok(new ResponseMessageDetails<int>("Total:", result));
        }

        [HttpDelete]
        public async Task<ActionResult<ResponseMessageDetails<int>>> DeleteBooking(int IdBooking)
        {
            var result = await _bookingService.DeleteBooking(IdBooking);
            if (result == -1)
                return BadRequest("Cannot Delete this booking.");

            return Ok(new ResponseMessageDetails<int>("Delete Success !", result));
        }
    }
}
