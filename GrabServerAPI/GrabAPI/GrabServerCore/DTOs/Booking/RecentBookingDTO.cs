using GrabServerCore.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerCore.DTOs.Booking
{
    public class RecentBookingDTO
    {
        public int Id { get; set; } = 0;
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string SrcAddress { get; set; } = string.Empty;
        public string DesAddress { get; set; } = string.Empty;

        public DateTime DateBooking { get; set; }
    }
}
