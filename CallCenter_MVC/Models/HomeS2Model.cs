using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.RazorPages;
using GrabServerCore.DTOs;
using GrabServerCore.DTOs.Booking;

namespace CallCenter_MVC.Models {
    public class HomeS2Model: PageModel
    {
        public List<AddBookingDTO> listBooking { get; set; }
        public HomeS2Model()
        {
            listBooking = new List<AddBookingDTO>{
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
                new AddBookingDTO{ IdCustomer = 5, SrcAddress = "415 Nguyễn Trãi, phường 7, quận 5, TP.HCM", 
                                                DesAddress = "Trường Đại học Khoa học Tự Nhiên, TP.HCM" },
            };
        }
    }
}