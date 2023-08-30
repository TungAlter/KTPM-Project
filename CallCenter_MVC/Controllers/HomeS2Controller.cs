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
        private readonly ILogger<HomeS2Controller> _logger;

        public HomeS2Controller(ILogger<HomeS2Controller> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            var listBooking = new List<AddBookingDTO>{
                new AddBookingDTO{ IdCustomer = 1, SrcAddress = "Trường Đại học Khoa học Tự Nhiên, TP.HCM", 
                                                DesAddress = "216/9 đường Dương Bá Trạc, phường 2, quận 8, TP.HCM" },
                new AddBookingDTO{ IdCustomer = 2, SrcAddress = "46A Đinh Công Tráng, phường Tân Định, quận 1, TP.HCM", 
                                                DesAddress = "216/9 đường Dương Bá Trạc, phường 2, quận 8, TP.HCM" },
                new AddBookingDTO{ IdCustomer = 3, SrcAddress = "53 Cao Thắng, quận 3, TP.HCM", 
                                                DesAddress = "18 Ký Hòa, phường 11, quận 5, TP.HCM" },
                new AddBookingDTO{ IdCustomer = 4, SrcAddress = "46A Đinh Công Tráng, phường Tân Định, quận 1", 
                                                DesAddress = "116/11 Phan Đăng Lưu, quận Phú Nhuận, TP.HCM" },
                new AddBookingDTO{ IdCustomer = 5, SrcAddress = "415 Nguyễn Trãi, phường 7, quận 5, TP.HCM", 
                                                DesAddress = "Trường Đại học Khoa học Tự Nhiên, TP.HCM" },
                new AddBookingDTO{ IdCustomer = 6, SrcAddress = "415 Nguyễn Trãi, phường 7, quận 5, TP.HCM", 
                                                DesAddress = "Trường Đại học Khoa học Tự Nhiên, TP.HCM" },
            };
            ViewBag.listBooking = listBooking;
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}