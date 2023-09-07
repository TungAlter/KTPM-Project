using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using CallCenter_MVC.Models;
using GrabServerCore.DTOs.Booking;
namespace CallCenter_MVC.Controllers
{
    public class HomeS2Controller : Controller
    {
        public IActionResult Index()
        {
            var listBooking = new List<ReadNewBookingDTO>{
                new ReadNewBookingDTO{ FullName = "1", AddrFrom = "Trường Đại học Khoa học Tự Nhiên, TP.HCM", 
                                                AddrTo = "216/9 đường Dương Bá Trạc, phường 2, quận 8, TP.HCM" },
                new ReadNewBookingDTO{ FullName = "2", AddrFrom = "46A Đinh Công Tráng, phường Tân Định, quận 1, TP.HCM", 
                                                AddrTo = "216/9 đường Dương Bá Trạc, phường 2, quận 8, TP.HCM" },
                new ReadNewBookingDTO{ FullName = "3", AddrFrom = "53 Cao Thắng quận 3 TP.HCM", 
                                                AddrTo = "18 Ký Hòa phường 11 quận 5 TP.HCM" },
                new ReadNewBookingDTO{ FullName = "4", AddrFrom = "46A Đinh Công Tráng, phường Tân Định, quận 1", 
                                                AddrTo = "116/11 Phan Đăng Lưu, quận Phú Nhuận, TP.HCM" },
                new ReadNewBookingDTO{ FullName = "5", AddrFrom = "415 Nguyễn Trãi, phường 7, quận 5, TP.HCM", 
                                                AddrTo = "Trường Đại học Khoa học Tự Nhiên, TP.HCM" },
                new ReadNewBookingDTO{ FullName = "6", AddrFrom = "415 Nguyễn Trãi phường 7 quận 5 TP.HCM", 
                                                AddrTo = "Trường Đại học Khoa học Tự Nhiên TP.HCM" },
            };
            ViewBag.listBooking = listBooking;
            return View("Index", listBooking);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}